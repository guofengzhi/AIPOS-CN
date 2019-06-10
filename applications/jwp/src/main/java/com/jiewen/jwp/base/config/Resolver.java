package com.jiewen.jwp.base.config;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.PropertiesConfiguration;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.i18n.CookieLocaleResolver;

import com.jiewen.jwp.common.StringUtils;






public class Resolver implements LocaleResolver {
	
	@Override 
	public Locale resolveLocale(HttpServletRequest httpServletRequest) {
		
		//获取url请求参数 
		String l = httpServletRequest.getParameter("loginLang"); 
	
		//设置默认的locale区域语言
		Locale locale= Locale.getDefault(); 
		if (!StringUtils.isEmpty(l)){ 
			String[] split = l.split("_"); 
			locale = new Locale(split[0], split[1]); 
			httpServletRequest.getSession().setAttribute("loginLang", locale);
		}else{
			if(httpServletRequest.getSession().getAttribute("loginLang")!=null){
				String lA=httpServletRequest.getSession().getAttribute("loginLang").toString();
				if (!StringUtils.isEmpty(lA)){ 
					String[] split = lA.split("_"); 
					locale = new Locale(split[0], split[1]); 
				}
			} 
			
		} 
			    CookieLocaleResolver localeResolver = new CookieLocaleResolver();
		        // 设置默认区域,
		        localeResolver.setDefaultLocale(locale);
		        // 设置cookie有效期.
		        localeResolver.setCookieMaxAge(3600);
				return locale; 
		} 
	
		@Override
		public void setLocale(HttpServletRequest request,
				HttpServletResponse response, Locale locale) {
			// TODO Auto-generated method stub
			
		}
		
		 public void  updateLanguage(String updateLanguage) {
				try {
					PropertiesConfiguration conf = new PropertiesConfiguration("application.properties");
					conf.setProperty("default.locale", updateLanguage);
					conf.save();
				} catch (ConfigurationException e) {
					
				}
			}
}


