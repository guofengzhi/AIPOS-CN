
package com.jiewen.base.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.SecurityUtils;

import com.jiewen.base.config.Global;

/**
 *
 *
 */
@WebFilter(filterName = "systemFilter", urlPatterns = "/*")
public class SystemFilter implements Filter {

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse,
            FilterChain filterChain) throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        String basePath = request.getContextPath();
        request.setAttribute("basePath", basePath);
        request.setAttribute("productName", Global.getConfig("productName"));
        request.setAttribute("miniLogo", Global.getConfig("miniLogo"));

        if (!SecurityUtils.getSubject().isAuthenticated()) {
            // 判断session里是否有用户信息
            if (request.getHeader("x-requested-with") != null
                    && request.getHeader("x-requested-with").equalsIgnoreCase("XMLHttpRequest")) {

                // 如果是ajax请求响应头会有，x-requested-with
                response.setHeader("session-status", "timeout"); // 在响应头设置session状态
                return;
            }
        }

        filterChain.doFilter(request, servletResponse);

    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Auto-generated method stub

    }

    @Override
    public void destroy() {
        // Auto-generated method stub

    }

}
