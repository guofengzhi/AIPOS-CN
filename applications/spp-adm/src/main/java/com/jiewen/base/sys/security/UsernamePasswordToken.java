
package com.jiewen.base.sys.security;

/**
 * 用户和密码（包含验证码）令牌类
 *
 */
public class UsernamePasswordToken extends org.apache.shiro.authc.UsernamePasswordToken {

    private static final long serialVersionUID = 1L;

    private String captcha;

    private boolean mobileLogin;

    private String loginType;

    public UsernamePasswordToken() {
        super();
    }

    public UsernamePasswordToken(String username, char[] password, boolean rememberMe, String host,
            String captcha, boolean mobileLogin, String loginType) {
        super(username, password, rememberMe, host);
        this.captcha = captcha;
        this.mobileLogin = mobileLogin;
        this.loginType = loginType;
    }

    public String getCaptcha() {
        return captcha;
    }

    public void setCaptcha(String captcha) {
        this.captcha = captcha;
    }

    public boolean isMobileLogin() {
        return mobileLogin;
    }

    public String getLoginType() {
        return loginType;
    }

    public void setLoginType(String loginType) {
        this.loginType = loginType;
    }

}