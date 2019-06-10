
package com.jiewen.base.sys.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.jiewen.base.core.service.BaseService;

/**
 * 手机端视图拦截器
 */
public class MobileInterceptor extends BaseService implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response,
            Object handler) throws Exception {
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
            ModelAndView modelAndView) throws Exception {
        if (modelAndView != null) {
            // 如果是手机或平板访问的话，则跳转到手机视图页面。
            /*
             * if(UserAgentUtils.isMobileOrTablet(request) &&
             * !StringUtils.startsWithIgnoreCase(modelAndView.getViewName(), "redirect:")){
             * modelAndView.setViewName("mobile/" + modelAndView.getViewName()); }
             */
        }
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response,
            Object handler, Exception ex) throws Exception {

    }

}
