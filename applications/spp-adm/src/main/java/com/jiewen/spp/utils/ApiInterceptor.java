
package com.jiewen.spp.utils;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Arrays;

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
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.alibaba.fastjson.JSONObject;
import com.jiewen.commons.Encodings;
import com.jiewen.commons.util.StringUtil;

@Aspect
@Component
public class ApiInterceptor {

	protected Logger logger = LoggerFactory.getLogger(getClass());

	@Value("${md5.secret}")
	private String secret;

	@Pointcut("@annotation(com.jiewen.commons.toolkit.annotation.JsonApiMethod)")
	public void jsonApiMethodAspect() {

	}

	@SuppressWarnings("unchecked")
	@Around("jsonApiMethodAspect()")
	public Object doAround(ProceedingJoinPoint joinPoint) throws Throwable {
		ServletRequestAttributes sra = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
		HttpServletRequest request = sra.getRequest();
		HttpServletResponse response = sra.getResponse();

		String contextPath = request.getContextPath();
		String requestURI = request.getRequestURI();

		if (logger.isDebugEnabled()) {
			logger.info("ContextPath=" + contextPath);
			logger.info("RequestURI=" + requestURI);
			logger.info("Character-Encoding=" + request.getCharacterEncoding());
			logger.info("Content-Type=" + request.getContentType());
			logger.info("Content-Length=" + request.getContentLength());
		}

		Object[] args = joinPoint.getArgs();
		String method = joinPoint.getSignature().getName();
		ArrayList<Object> reqStr = (ArrayList<Object>) args[0];
		String reqSign = request.getHeader("sign");
		String timestamp = request.getHeader("timestamp");

		if (logger.isDebugEnabled()) {
			StrBuilder sb = new StrBuilder();
			sb.append("请求数据:").appendNewLine();
			sb.append("sign=").appendln(reqSign);
			sb.append("timestemp=").appendln(timestamp);
			sb.append("body=").appendln(reqStr);
			sb.append("Method=").append(method);
			logger.debug(sb.toString());
		}

		if (StringUtils.isEmpty(reqSign)) {
			logger.error("缺少签名数据");
			return null;
		}
		if (StringUtil.isEmpty(timestamp)) {
			logger.error("缺少时间签名");
			return null;
		}

		if (StringUtils.isBlank(method)) {
			logger.info("签名认证参数为空，请求接口：{}，请求IP：{}，请求参数：{}", request.getRequestURI(), getIpAddress(request),
					Arrays.toString(args));
		}
		Object ret = null;
		try {
			boolean pass = verify(method, timestamp, reqSign);
			if (!pass) {
				logger.error("签名认证失败，请求接口：{}，请求IP：{}，请求参数：{}", request.getRequestURI(), getIpAddress(request),
						Arrays.toString(args));
			}

			ret = joinPoint.proceed();
			if (ret != null) {
				long restemp = System.currentTimeMillis();
				String sign = sign(method, String.valueOf(restemp));
				response.setHeader("sign", sign);
				response.setHeader("timestamp", String.valueOf(restemp));
				response.setContentType(request.getContentType());
			}
		} catch (Exception e) {
			logger.error("处理失败", e);
			JSONObject rspJson = new JSONObject();
			ret = rspJson.toJSONString();
		}

		return ret;
	}

	private boolean verify(String method, String timestemp, String reqSign) throws Exception {
		String keySecret = encrypt(timestemp, this.secret);
		String data = method + keySecret;
		if (logger.isDebugEnabled()) {
			logger.debug("请求数据方法名 ：" + method);
			logger.debug("MD5 key:" + keySecret);
		}
		String sign = StringUtil.md5sum(data.getBytes(Encodings.UTF8));
		if (logger.isDebugEnabled()) {
			logger.debug("报文中的签名=" + reqSign);
			logger.debug("计算出的签名=" + sign);
		}
		logger.info("请求数据字符串 ：" + data);
		logger.info("报文中的签名=" + reqSign);
		logger.info("计算出的签名=" + sign);
		return StringUtils.equalsIgnoreCase(sign, reqSign);
	}

	/**
	 * 计算签名
	 * 
	 * @param reqStr
	 * @return
	 */
	public String sign(String method, String timestemp) {
		try {
			// this.secret
			String keySecret = encrypt(timestemp, "daf1eedfef5f69d61dc8c936f106f11d");
			String data = method + keySecret;
			if (logger.isDebugEnabled()) {
				logger.debug("响应数据方法 ：" + method);
				logger.debug("key:" + keySecret);
			}
			String sign = StringUtil.md5sum(data.getBytes(Encodings.UTF8));
			if (logger.isDebugEnabled()) {
				logger.debug("计算出的签名=" + sign);
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

	public static String encrypt(String timestamp, String strKey) {
		byte[] data = null;
		byte[] keyData = null;
		try {
			data = StringUtil.addRightSpace(timestamp, 32).getBytes(Encodings.UTF8);
			keyData = StringUtil.addRightSpace(strKey, 32).getBytes(Encodings.UTF8);

		} catch (UnsupportedEncodingException e) {
			e.getMessage();
		}
		for (int x = 0; x < data.length; x++) {
			data[x] = (byte) (data[x] ^ keyData[x]);
		}
		return StringUtil.hexDump(data);
	}

}