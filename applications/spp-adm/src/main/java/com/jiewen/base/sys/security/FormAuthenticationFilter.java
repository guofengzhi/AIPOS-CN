
package com.jiewen.base.sys.security;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.IncorrectCredentialsException;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.web.util.WebUtils;

import com.jiewen.jwp.common.utils.StringUtils;

/**
 * 表单验证（包含验证码）过滤类
 */
public class FormAuthenticationFilter
        extends org.apache.shiro.web.filter.authc.FormAuthenticationFilter {

    public static final String DEFAULT_CAPTCHA_PARAM = "validateCode";

    public static final String DEFAULT_MOBILE_PARAM = "mobileLogin";

    public static final String DEFAULT_MESSAGE_PARAM = "message";

    public static final String DEFAULT_LOGINTYPE_PARAM = "loginType";

    private String captchaParam = DEFAULT_CAPTCHA_PARAM;

    private String mobileLoginParam = DEFAULT_MOBILE_PARAM;

    private String messageParam = DEFAULT_MESSAGE_PARAM;

    private String loginTypeParam = DEFAULT_LOGINTYPE_PARAM;

    @Override
    protected AuthenticationToken createToken(ServletRequest request, ServletResponse response) {
        String username = getUsername(request);
        String password = StringUtils.defaultString(getPassword(request), StringUtils.EMPTY);
        boolean rememberMe = isRememberMe(request);
        String host = StringUtils.getRemoteAddr((HttpServletRequest) request);
        String captcha = getCaptcha(request);
        boolean mobile = isMobileLogin(request);
        String loginType = getLoginType(request);
        return new UsernamePasswordToken(username, password.toCharArray(), rememberMe, host,
                captcha, mobile, loginType);
    }

    /**
     * 获取登录用户名
     */
    @Override
    protected String getUsername(ServletRequest request) {
        String username = super.getUsername(request);
        if (StringUtils.isBlank(username)) {
            username = StringUtils.toString(request.getAttribute(getUsernameParam()),
                    StringUtils.EMPTY);
        }
        return username;
    }

    /**
     * 获取登录密码
     */
    @Override
    protected String getPassword(ServletRequest request) {
        String password = super.getPassword(request);
        if (StringUtils.isBlank(password)) {
            password = StringUtils.toString(request.getAttribute(getPasswordParam()),
                    StringUtils.EMPTY);
        }
        return password;
    }

    /**
     * 获取记住我
     */
    @Override
    protected boolean isRememberMe(ServletRequest request) {
        String isRememberMe = WebUtils.getCleanParam(request, getRememberMeParam());
        if (StringUtils.isBlank(isRememberMe)) {
            isRememberMe = StringUtils.toString(request.getAttribute(getRememberMeParam()),
                    StringUtils.EMPTY);
        }
        return StringUtils.toBoolean(isRememberMe);
    }

    public String getCaptchaParam() {
        return captchaParam;
    }

    protected String getCaptcha(ServletRequest request) {
        return WebUtils.getCleanParam(request, getCaptchaParam());
    }

    public String getMobileLoginParam() {
        return mobileLoginParam;
    }

    protected boolean isMobileLogin(ServletRequest request) {
        return WebUtils.isTrue(request, getMobileLoginParam());
    }

    public String getMessageParam() {
        return messageParam;
    }

    public String getLoginTypeParam() {
        return loginTypeParam;
    }

    protected String getLoginType(ServletRequest request) {
        return WebUtils.getCleanParam(request, getLoginTypeParam());
    }

    @Override
    protected void issueSuccessRedirect(ServletRequest request, ServletResponse response)
            throws Exception {
        WebUtils.issueRedirect(request, response, getSuccessUrl(), null, true);
    }

    /**
     * 登录失败调用事件
     */
    @Override
    protected boolean onLoginFailure(AuthenticationToken token, AuthenticationException e,
            ServletRequest request, ServletResponse response) {
        String className = e.getClass().getName();
        String message = "";
        if (e instanceof IncorrectCredentialsException || e instanceof UnknownAccountException) {
            message = "用户或密码错误, 请重试.";
        } else if (e.getMessage() != null && StringUtils.startsWith(e.getMessage(), "msg:")) {
            message = StringUtils.replace(e.getMessage(), "msg:", "");
        } else {
            message = "系统出现点问题，请稍后再试！";
        }
        request.setAttribute(getFailureKeyAttribute(), className);
        request.setAttribute(getMessageParam(), message);
        return true;
    }

}
