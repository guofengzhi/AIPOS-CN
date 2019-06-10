
package com.jiewen.jwp.base.config;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.UnauthorizedException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.NoHandlerFoundException;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.servlet.i18n.LocaleChangeInterceptor;

import com.alibaba.fastjson.JSON;
import com.jiewen.commons.ServiceException;
import com.jiewen.jwp.base.web.Result;
import com.jiewen.jwp.base.web.ResultCode;
import com.jiewen.jwp.base.web.ServletsUtils;
import com.jiewen.modules.sys.interceptor.CSRFInterceptor;
import com.jiewen.modules.sys.interceptor.LogInterceptor;
import com.jiewen.modules.sys.interceptor.MobileInterceptor;

//import java.nio.charset.Charset;
//import java.util.Properties;
//import org.springframework.context.annotation.Bean;
//import org.springframework.http.converter.HttpMessageConverter;
//import org.springframework.web.servlet.handler.SimpleMappingExceptionResolver;
//import com.alibaba.fastjson.serializer.SerializerFeature;
//import com.alibaba.fastjson.support.config.FastJsonConfig;
//import com.alibaba.fastjson.support.spring.FastJsonHttpMessageConverter4;

@Configuration
public class WebAppConfig extends WebMvcConfigurerAdapter {

    private final Logger logger = LoggerFactory.getLogger(WebAppConfig.class);

    @Value(value = "${default.locale}")
    protected String defaultLocale;
    // 使用阿里 FastJson 作为JSON MessageConverter
    /*
     * @Override public void configureMessageConverters(List<HttpMessageConverter<?>> converters) {
     * FastJsonHttpMessageConverter4 converter = new FastJsonHttpMessageConverter4(); FastJsonConfig
     * config = new FastJsonConfig();
     * config.setSerializerFeatures(SerializerFeature.WriteMapNullValue,
     * SerializerFeature.WriteNullStringAsEmpty, SerializerFeature.WriteNullNumberAsZero);
     * converter.setFastJsonConfig(config); converter.setDefaultCharset(Charset.forName("UTF-8"));
     * converters.add(converter); }
     */

    @Override
    public void
           configureHandlerExceptionResolvers(List<HandlerExceptionResolver> exceptionResolvers) {
        exceptionResolvers.add(new HandlerExceptionResolver() {

            @Override
            public ModelAndView resolveException(HttpServletRequest request,
                                                 HttpServletResponse response,
                                                 Object handler, Exception e) {
                ModelAndView mv = new ModelAndView();
                Result result = new Result();
                HandlerMethod handlerMethod = (HandlerMethod) handler;
                if (null != handlerMethod.getBean().getClass()
                        .getAnnotation(RestController.class)
                        || null != handlerMethod.getMethodAnnotation(ResponseBody.class)
                        || ServletsUtils.isAjaxRequest(request)) {
                    if (e instanceof ServiceException) { // 业务失败的异常，如“账号或密码错误”
                        result.setCode(ResultCode.FAIL).setMessage(e.getMessage());
                        logger.info(e.getMessage());
                    } else if (e instanceof NoHandlerFoundException) {
                        result.setCode(ResultCode.NOT_FOUND).setMessage(
                                "url路径方法 [" + request.getRequestURI() + "] 不存在");
                        logger.error(e.getMessage());
                    } else if (e instanceof UnauthorizedException) {
                        result.setCode(ResultCode.FORBIDDEN).setMessage(
                                "方法 [" + request.getRequestURI() + "] 未进行授权，请联系管理员");
                        logger.error(e.getMessage());
                    } else if (e instanceof ServletException) {
                        result.setCode(ResultCode.FAIL).setMessage(e.getMessage());
                        logger.error(e.getMessage());
                    } else {
                        result.setCode(ResultCode.INTERNAL_SERVER_ERROR).setMessage(
                                "方法 [" + request.getRequestURI() + "] 内部错误，请联系统管理员");
                        String message;
                        if (handler instanceof HandlerMethod) {
                            message = String.format("方法 [%s] 出现异常，方法：%s.%s，异常摘要：%s",
                                    request.getRequestURI(),
                                    handlerMethod.getBean().getClass().getName(),
                                    handlerMethod.getMethod().getName(), e.getMessage());
                        } else {
                            message = e.getMessage();
                        }
                        logger.error(message, e);
                    }
                    responseResult(response, result);
                } else {
                    if (response.getStatus() == 404) {
                        mv.setViewName("error/404");
                    } else if (response.getStatus() == 403
                            || e instanceof UnauthorizedException) {
                        mv.setViewName("error/403");
                    } else if (response.getStatus() == 400) {
                        mv.setViewName("error/403");
                    } else {
                        mv.setViewName("error/500");
                    }
                    logger.error(e.getMessage(), e);
                }
                return mv;
            }
        });
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new LogInterceptor()).addPathPatterns("/**")
                .excludePathPatterns("/", "/login", "/sys/menu/tree",
                        "/sys/menu/treeData");
        registry.addInterceptor(new MobileInterceptor()).addPathPatterns("/**");
        registry.addInterceptor(new CSRFInterceptor()).addPathPatterns("/**")
                .excludePathPatterns("/adminlte/**", "/common/**", "/api/**", "/i18n/**");
        registry.addInterceptor(localeChangeInterceptor());
        super.addInterceptors(registry);
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/i18n/**").addResourceLocations("classpath:/i18n/");
    }

    /*
     * @Bean public SimpleMappingExceptionResolver simpleMappingExceptionResolver() {
     * SimpleMappingExceptionResolver resolver = new SimpleMappingExceptionResolver();
     *
     * Properties mappings = new Properties();
     * mappings.setProperty("org.apache.shiro.authz.UnauthorizedException", "error/403");
     * mappings.setProperty("java.lang.Throwable", "error/500");
     * resolver.setExceptionMappings(mappings); resolver.setOrder(-1); return resolver; }
     */

    private void responseResult(HttpServletResponse response, Result result) {
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Content-type", "application/json;charset=UTF-8");
        response.setStatus(result.getCode());
        try {
            response.getWriter().write(JSON.toJSONString(result));
        } catch (IOException ex) {
            logger.error(ex.getMessage());
        }
    }

   /* @Bean
    public LocaleResolver localeResolver() {
        CookieLocaleResolver localeResolver = new CookieLocaleResolver();
        // 设置默认区域,
        localeResolver.setDefaultLocale(new Locale(defaultLocale));
        // 设置cookie有效期.
        localeResolver.setCookieMaxAge(3600);
        return localeResolver;
    }*/

    @Bean
    public LocaleChangeInterceptor localeChangeInterceptor() {
        return new LocaleChangeInterceptor();
    }
    
   // 这是我配置的请求视图
    @Override 
    public void addViewControllers(ViewControllerRegistry registry) { 
    	registry.addViewController("/").setViewName("login");
    	registry.addViewController("/login").setViewName("login");
    	} 
    
    // 加载自定义的解析器 
    // 放入我们自定义的mvc组件当中
    @Bean 
    public LocaleResolver localeResolver(){ 
    	return new Resolver(); 
    }

}
