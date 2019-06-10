package com.jiewen.spp.aop;

import java.io.UnsupportedEncodingException;
import java.util.Map;
import java.util.Objects;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.text.StrBuilder;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.jiewen.base.excetion.OTAExcetion;
import com.jiewen.commons.Encodings;
import com.jiewen.commons.util.StringUtil;
import com.jiewen.constant.ControlCommand;
import com.jiewen.utils.RspCode;
import com.jiewen.utils.RspJsonNode;
import com.jiewen.utils.TransLogUtils;

@Aspect
@Component
public class ApiInterceptor {

    protected Logger logger = LoggerFactory.getLogger(getClass());

    @Value("${spring.profiles.active}")
    private String env; // 当前激活的配置文件

    @Value("#{${md5.secret}}")
    private Map<String, String> secret;
    
    @Autowired
    public TransLogUtils transLogUtils;

    public static final String DEFAULT_SOURCEID = "000000";
    

    @Pointcut("@annotation(com.jiewen.commons.toolkit.annotation.JsonApiMethod)")
    public void jsonApiMethodAspect() {
        // Do nothing because of X and Y.
    }

    @Around("jsonApiMethodAspect()")
    public Object doAround(ProceedingJoinPoint joinPoint) throws Throwable {
        ServletRequestAttributes sra = (ServletRequestAttributes) RequestContextHolder
                .getRequestAttributes();
        HttpServletRequest request = sra.getRequest();
        HttpServletResponse response = sra.getResponse();

        String contextPath = request.getContextPath();
        String requestURI = request.getRequestURI();

        if (logger.isDebugEnabled()) {
            logger.info("ContextPath={}", contextPath);
            logger.info("RequestURI={}", requestURI);
            logger.info("Character-Encoding={}", request.getCharacterEncoding());
            logger.info("Content-Type={}", request.getContentType());
            logger.info("Content-Length={}", request.getContentLength());
        }

        Object[] args = joinPoint.getArgs();
        String reqStr = (String) args[0];
        String reqSign = request.getHeader("sign");
        String timestamp = request.getHeader("timestamp");

        if (logger.isDebugEnabled()) {
            StrBuilder sb = new StrBuilder();
            sb.append("请求数据:").appendNewLine();
            sb.append("sign=").appendln(reqSign);
            sb.append("timestamp=").appendln(timestamp);
            sb.append("body=").appendln(reqStr);

            logger.debug(sb.toString());
        }

        if (StringUtils.isEmpty(reqStr)) {
            logger.info("请求数据为空");
            return null;
        }
        if (StringUtils.isEmpty(reqSign)) {
            logger.error("缺少签名数据");
            return null;
        }
        if (StringUtil.isEmpty(timestamp)) {
            logger.error("缺少时间签名");
            return null;
        }

        JSONObject reqJson = null;
        try {
            reqJson = JSON.parseObject(reqStr);
        } catch (Exception e) {
            logger.info("非法的数据格式");
            return null;
        }
        if (reqJson == null || reqJson.isEmpty()) {
            logger.info("无效的数据内容");
            return null;
        }
        String sn = reqJson.getString(RspJsonNode.SN);
        if (StringUtils.isBlank(sn)) {
            logger.warn("签名认证参数为空，请求接口：{}，请求IP：{}，请求参数：{}", request.getRequestURI(),
                    getIpAddress(request), reqJson.toJSONString());
            throw new OTAExcetion(RspCode.PARAM_ERROR, "签名校验参数为空");
        }
        String sourceId = reqJson.getString(RspJsonNode.SOURCE_ID);
        if (StringUtils.isBlank(sourceId)) {
            sourceId = DEFAULT_SOURCEID;
        }
        Object ret = null;
        try {
            boolean pass = verify(reqStr, reqSign, sn, timestamp, sourceId);
            if (!pass) {
                logger.warn("签名认证失败，请求接口：{}，请求IP：{}，请求参数：{}", request.getRequestURI(),
                        getIpAddress(request), reqJson.toJSONString());
                throw new OTAExcetion(RspCode.SIGN_ERROR, "签名校验失败");
            }
            transLogUtils.asyncSaveTransLog(reqJson, request.getRequestURI());

            ret = joinPoint.proceed();

        } catch (OTAExcetion e) {
            logger.error(e.getMessage(), e);

            JSONObject rspJson = new JSONObject();
            rspJson.put(RspJsonNode.SN, sn);
            if (StringUtils.equalsIgnoreCase("prod", env)
                    && StringUtils.equalsIgnoreCase(RspCode.NO_DEVICE_ERROR, e.getCode())) {
                rspJson.put(RspJsonNode.VERSION, reqJson.getString(RspJsonNode.VERSION));
                rspJson.put(RspJsonNode.DEVICE_TYPE, reqJson.getString(RspJsonNode.DEVICE_TYPE));
                rspJson.put(RspJsonNode.MANUFACTURER, reqJson.getString(RspJsonNode.MANUFACTURER));
                rspJson.put(RspJsonNode.IS_UPGRADE, ControlCommand.Upgrade.UPGRADE_NO);
                rspJson.put(RspJsonNode.RESP_CODE, "00");
            } else {
                rspJson.put(RspJsonNode.RESP_CODE, e.getCode());
                rspJson.put(RspJsonNode.RESP_MSG, e.getMessage());
            }
            ret = rspJson.toJSONString();
        } catch (Exception e) {
            logger.error("处理失败", e);

            JSONObject rspJson = new JSONObject();
            rspJson.put(RspJsonNode.SN, sn);
            rspJson.put(RspJsonNode.RESP_CODE, RspCode.SYSTEM_ERROR);
            rspJson.put(RspJsonNode.RESP_MSG, "系统错误,请联系服务提供方!");
            ret = rspJson.toJSONString();
        } finally {
            if (ret != null) {
                long restemp = System.currentTimeMillis();
                String sign = sign(Objects.toString(ret), String.valueOf(restemp), sourceId);
                response.setHeader("sign", sign);
                response.setHeader("timestamp", String.valueOf(restemp));
                response.setContentType(request.getContentType());
            }
        }

        return ret;
    }

    private boolean verify(String reqStr, String reqSign, String sn, String timestemp,
            String sourceId) throws UnsupportedEncodingException {
        String keySecret = com.jiewen.utils.StringUtil.encrypt(sn, timestemp,
                this.secret.get(sourceId));
        String data = reqStr + keySecret;
        if (logger.isDebugEnabled()) {
            logger.debug("请求数据字符串 ：{}", reqStr);
            logger.debug("MD5 key:{}", keySecret);
        }
        String sign = StringUtil.md5sum(data.getBytes(Encodings.UTF8));
        if (logger.isDebugEnabled()) {
            logger.debug("报文中的签名={}", reqSign);
            logger.debug("计算出的签名={}", sign);
        }
        if ("test".equals(env)) {
            logger.info("请求数据字符串 ：{}", reqStr);
            logger.info("报文中的签名={}", reqSign);
            logger.info("计算出的签名={}", sign);
        }
        return StringUtils.equalsIgnoreCase(sign, reqSign);
    }

    /**
     * 计算签名
     * 
     * @param reqStr
     * @return
     */
    private String sign(String rspStr, String timestemp, String sourceId) {
        try {
            JSONObject rspJson = JSONObject.parseObject(rspStr);
            String keySecret = com.jiewen.utils.StringUtil.encrypt(
                    rspJson.getString(RspJsonNode.SN), timestemp, this.secret.get(sourceId));
            String data = rspStr + keySecret;
            if (logger.isDebugEnabled()) {
                logger.debug("响应数据字符串 ：{}", rspStr);
                logger.debug("key:{}", keySecret);
            }
            String sign = StringUtil.md5sum(data.getBytes(Encodings.UTF8));
            if (logger.isDebugEnabled()) {
                logger.debug("计算出的签名={}", sign);
            }
            return sign;
        } catch (UnsupportedEncodingException e) {
            // 不会不支持UTF-8
            return null;
        }
    }

    private String getIpAddress(HttpServletRequest request) {
        String ip = request.getHeader("x-forwarded-for");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        // 如果是多级代理，那么取第一个ip为客户端ip
        if (ip != null && ip.indexOf(",") != -1) {
            ip = ip.substring(0, ip.indexOf(",")).trim();
        }

        return ip;
    }

}