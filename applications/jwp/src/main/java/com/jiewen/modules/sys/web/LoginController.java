package com.jiewen.modules.sys.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.configuration.ConfigurationException;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authz.UnauthorizedException;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.apache.shiro.web.util.WebUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.collect.Maps;
import com.jiewen.jwp.base.config.Global;
import com.jiewen.jwp.base.utils.CacheUtils;
import com.jiewen.jwp.base.utils.IdGen;
import com.jiewen.jwp.base.utils.SessionDAO;
import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.common.CookieUtils;
import com.jiewen.modules.sys.entity.Menu;
import com.jiewen.modules.sys.security.FormAuthenticationFilter;
import com.jiewen.modules.sys.security.SystemAuthorizingRealm.Principal;
import com.jiewen.modules.sys.servlet.ValidateCodeServlet;
import com.jiewen.modules.sys.utils.UserUtils;

/**
 * 登录Controller
 */
@Controller
public class LoginController extends BaseController {

	@Autowired
	private SessionDAO sessionDAO;


	@Value("${error.password.times}")
	private Integer errorTimes;

	/**
	 * 管理登录
	 */
	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String login(HttpServletRequest request, HttpServletResponse response) {
		Principal principal = UserUtils.getPrincipal();

		if (logger.isDebugEnabled()) {
			logger.debug("login, active session size: {}", sessionDAO
					.getActiveSessions(false).size());
		}

		// 如果已登录，再次访问主页，则退出原账号。
		if (Global.TRUE.equals(Global.getConfig("notAllowRefreshIndex"))) {
			CookieUtils.setCookie(response, "LOGINED", "false");
		}

		// 如果已经登录，则跳转到管理首页
		if (principal != null && !principal.isMobileLogin()) {
			return "redirect:/";
		}
		return "modules/sys/sysLogin";
	}

	/**
	 * 登录失败，真正登录的POST请求由Filter完成
	 */
	@RequestMapping(value = "/login", method = RequestMethod.POST)
	public String loginFail(HttpServletRequest request,
			HttpServletResponse response, Model model) {
		Principal principal = UserUtils.getPrincipal();
		// 如果已经登录，则跳转到管理首页
		if (principal != null) {
			return "redirect:/";
		}

		String username = WebUtils
				.getCleanParam(
						request,
						org.apache.shiro.web.filter.authc.FormAuthenticationFilter.DEFAULT_USERNAME_PARAM);
		boolean rememberMe = WebUtils
				.isTrue(request,
						org.apache.shiro.web.filter.authc.FormAuthenticationFilter.DEFAULT_REMEMBER_ME_PARAM);
        //获取是否自动登录
		boolean   rememberLogin=WebUtils.isTrue(request, "rememberLogin");
		String message = (String) request
				.getAttribute(FormAuthenticationFilter.DEFAULT_MESSAGE_PARAM);

		if (org.apache.commons.lang3.StringUtils.isBlank(message)
				|| org.apache.commons.lang3.StringUtils.equals(message, "null")) {
			message = messageSourceUtil.getMessage("common.UserOrPasswordIsError");
		}
		boolean mobile = WebUtils.isTrue(request,
				FormAuthenticationFilter.DEFAULT_MOBILE_PARAM);
		String exception = (String) request
				.getAttribute(org.apache.shiro.web.filter.authc.FormAuthenticationFilter.DEFAULT_ERROR_KEY_ATTRIBUTE_NAME);
		model.addAttribute(
				org.apache.shiro.web.filter.authc.FormAuthenticationFilter.DEFAULT_USERNAME_PARAM,
				username);
		model.addAttribute(
				org.apache.shiro.web.filter.authc.FormAuthenticationFilter.DEFAULT_REMEMBER_ME_PARAM,
				rememberMe);
		model.addAttribute("rememberLogin", rememberLogin);
		model.addAttribute(FormAuthenticationFilter.DEFAULT_MOBILE_PARAM,
				mobile);
		model.addAttribute(
				org.apache.shiro.web.filter.authc.FormAuthenticationFilter.DEFAULT_ERROR_KEY_ATTRIBUTE_NAME,
				exception);
		model.addAttribute(FormAuthenticationFilter.DEFAULT_MESSAGE_PARAM,
				message);

		if (logger.isDebugEnabled()) {
			logger.debug(
					"login fail, active session size: {}, message: {}, exception: {}",
					sessionDAO.getActiveSessions(false).size(), message,
					exception);
		}
		 // 非授权异常，登录失败，验证码加1。
		if (!UnauthorizedException.class.getName().equals(exception)) {
			model.addAttribute("isValidateCodeLogin",
					isValidateCodeLogin(username, true, false, errorTimes));
		}
		// 验证失败清空验证码
		request.getSession().setAttribute(ValidateCodeServlet.VALIDATE_CODE,
				IdGen.uuid());
		// 如果是手机登录，则返回JSON字符串
		if (mobile) {
			return renderString(response, model);
		}
		model.addAttribute("yanCount",
				 UserUtils.getSession().getAttribute(username));
		return "modules/sys/sysLogin";
	}

	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	public String logout(Model model) {

		SecurityUtils.getSubject().logout();
		UserUtils.clearCache();
		model.addAttribute("logout", "logout");
		return "redirect:/";
	}

	@RequestMapping(value = "/homePage")
	public String home() {
		return "modules/sys/homePage";
	}

	/**
	 * 登录成功，进入管理首页
	 * @throws ConfigurationException 
	 */
	@RequiresPermissions("user")
	@RequestMapping(value = "/")
	public String index(HttpServletRequest request, HttpServletResponse response) throws ConfigurationException {
		Principal principal = UserUtils.getPrincipal();
		//登录错误次数清零
		//request.getSession().removeAttribute(principal.getLoginName());
		 UserUtils.getSession().removeAttribute(principal.getLoginName());
		// 登录成功后，验证码计算器清零
		isValidateCodeLogin(principal.getLoginName(), false, true, errorTimes);

		if (logger.isDebugEnabled()) {
			logger.debug("show index, active session size: {}", sessionDAO
					.getActiveSessions(false).size());
		}

		// 如果已登录，再次访问主页，则退出原账号。
		if (Global.TRUE.equals(Global.getConfig("notAllowRefreshIndex"))) {
			String logined = CookieUtils.getCookie(request, "LOGINED");
			if (org.apache.commons.lang3.StringUtils.isBlank(logined)
					|| "false".equals(logined)) {
				CookieUtils.setCookie(response, "LOGINED", "true");
			} else if (org.apache.commons.lang3.StringUtils.equals(logined,
					"true")) {
				UserUtils.getSubject().logout();
				return "redirect:" + "/login";
			}
		}

		// 如果是手机登录，则返回JSON字符串
		if (principal.isMobileLogin()) {
			if (request.getParameter("login") != null) {
				return renderString(response, principal);
			}
			if (request.getParameter("index") != null) {
				return "modules/sys/sysIndex";
			}
			return "redirect:" + "/login";
		}
		return "modules/sys/sysIndex";
	}

	/**
	 * 是否是验证码登录
	 * 
	 * @param username
	 *            用户名
	 * @param isFail
	 *            计数加1
	 * @param clean
	 *            计数清零
	 * @return
	 */
	public static boolean isValidateCodeLogin(String username, boolean isFail,
			boolean clean, Integer errorTimes) {
		@SuppressWarnings("unchecked")
		Map<String, Integer> loginFailMap = (Map<String, Integer>) CacheUtils
				.get("loginFailMap");
		if (loginFailMap == null) {
			loginFailMap = Maps.newHashMap();
			CacheUtils.put("loginFailMap", loginFailMap);
		}
		Integer loginFailNum = loginFailMap.get(username);
		if (loginFailNum == null) {
			loginFailNum = 0;
		}
		if (isFail) {
			loginFailNum++;
			loginFailMap.put(username, loginFailNum);
		}
		if (clean) {
			loginFailMap.remove(username);
		}
		return loginFailNum >= errorTimes;
	}

	@RequiresPermissions("user")
	@RequestMapping(value = "/getMenuList")
	@ResponseBody
	public List<Menu> getMenuList(HttpServletRequest httpServletRequest) {
		String language = LocaleContextHolder.getLocale().toString().toLowerCase();
		List<Menu> menuList = UserUtils.getMenuList(language);
		if(menuList.isEmpty()) {
			menuList = UserUtils.getMenuList(defalutLocale);
		}
		return menuList;
	}
}
