
package com.jiewen.base.config;

import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.Filter;

import org.apache.shiro.cache.ehcache.EhCacheManager;
import org.apache.shiro.mgt.SecurityManager;
import org.apache.shiro.session.mgt.eis.EnterpriseCacheSessionDAO;
import org.apache.shiro.session.mgt.eis.SessionIdGenerator;
import org.apache.shiro.spring.LifecycleBeanPostProcessor;
import org.apache.shiro.spring.security.interceptor.AuthorizationAttributeSourceAdvisor;
import org.apache.shiro.spring.web.ShiroFilterFactoryBean;
import org.apache.shiro.web.mgt.CookieRememberMeManager;
import org.apache.shiro.web.mgt.DefaultWebSecurityManager;
import org.apache.shiro.web.servlet.SimpleCookie;
import org.apache.shiro.web.session.mgt.DefaultWebSessionManager;
import org.springframework.aop.framework.autoproxy.DefaultAdvisorAutoProxyCreator;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.DependsOn;
import org.springframework.web.filter.DelegatingFilterProxy;

import com.jiewen.base.common.security.shiro.CacheSessionDAO;
import com.jiewen.base.common.security.shiro.SessionManager;
import com.jiewen.base.common.utils.IdGen;
import com.jiewen.base.filter.KickoutSessionFilter;
import com.jiewen.base.sys.security.FormAuthenticationFilter;
import com.jiewen.base.sys.security.SystemAuthorizingRealm;
import com.jiewen.commons.util.Base64;

/**
 **
 * Shiro 配置
 *
 * Apache Shiro 核心通过 Filter 来实现，就好像SpringMvc 通过DispachServlet 来主控制一样。 既然是使用 Filter
 * 一般也就能猜到，是通过URL规则来进行过滤和权限校验， 所以我们需要定义一系列关于URL的规则和访问权限。
 *
 */
@Configuration
public class ShiroConfig {

    @Bean
    public LifecycleBeanPostProcessor lifecycleBeanPostProcessor() {
        return new LifecycleBeanPostProcessor();
    }

    @Bean
    @DependsOn("lifecycleBeanPostProcessor")
    public EhCacheManager ehCacheManager() {
        EhCacheManager ehCacheManager = new EhCacheManager();
        ehCacheManager.setCacheManagerConfigFile("classpath:config/ehcache-shiro.xml");
        return ehCacheManager;
    }

    @Bean
    public SystemAuthorizingRealm systemAuthorizingRealm() {
        SystemAuthorizingRealm systemAuthorizingRealm = new SystemAuthorizingRealm();
        systemAuthorizingRealm.setAuthenticationCachingEnabled(false);
        systemAuthorizingRealm.setAuthorizationCachingEnabled(false);
        return systemAuthorizingRealm;
    }

    @Bean
    public FilterRegistrationBean delegatingFilterProxy() {
        FilterRegistrationBean filterRegistrationBean = new FilterRegistrationBean();
        DelegatingFilterProxy proxy = new DelegatingFilterProxy();
        proxy.setTargetFilterLifecycle(true);
        proxy.setTargetBeanName("shiroFilter");
        filterRegistrationBean.setFilter(proxy);
        return filterRegistrationBean;
    }

    /**
     * ShiroFilterFactoryBean 处理拦截资源文件问题。 注意：单独一个ShiroFilterFactoryBean配置是或报错的，以为在
     * 初始化ShiroFilterFactoryBean的时候需要注入：SecurityManager
     *
     * Filter Chain定义说明 1、一个URL可以配置多个Filter，使用逗号分隔 2、当设置多个过滤器时，全部验证通过，才视为通过
     * 3、部分过滤器可指定参数，如perms，roles
     *
     */
    @Bean
    public ShiroFilterFactoryBean shiroFilter(SecurityManager securityManager) {
        ShiroFilterFactoryBean shiroFilterFactoryBean = new ShiroFilterFactoryBean();

        shiroFilterFactoryBean.setSecurityManager(securityManager);
        Map<String, Filter> filters = shiroFilterFactoryBean.getFilters();

        filters.put("authc", formAuthenticationFilter());
        filters.put("customer", customerFormAuthenticationFilter());
        filters.put("kickout", kickoutSessionFilter());
        // 必须设置 SecurityManager

        // 拦截器.
        Map<String, String> filterChainDefinitionMap = new LinkedHashMap<>();

        // 配置退出过滤器,其中的具体的退出代码Shiro已经替我们实现了
        // 验证码可以匿名访问
        filterChainDefinitionMap.put("/static/**", "anon,kickout");
        filterChainDefinitionMap.put("/adminlte/**", "anon,kickout");
        filterChainDefinitionMap.put("/common/**", "anon,kickout");
        filterChainDefinitionMap.put("/validateCode", "anon,kickout");
        filterChainDefinitionMap.put("/api/**", "anon,kickout");
        filterChainDefinitionMap.put("/login", "authc,kickout");
        filterChainDefinitionMap.put("/customer/login", "customer");
        // <!-- 过滤链定义，从上向下顺序执行，一般将 /**放在最为下边 -->:这是一个坑呢，一不小心代码就不好使了
        // <!-- authc:所有url都必须认证通过才可以访问; anon:所有url都都可以匿名访问-->

        filterChainDefinitionMap.put("/**", "user,kickout");

        // 如果不设置默认会自动寻找Web工程根目录下的"/login.jsp"页面
        // shiroFilterFactoryBean.setLoginUrl("/login");
        // 登录成功后要跳转的链接
        // shiroFilterFactoryBean.setSuccessUrl("?login");
        // 未授权界面
        shiroFilterFactoryBean.setUnauthorizedUrl("/error/403");

        shiroFilterFactoryBean.setFilterChainDefinitionMap(filterChainDefinitionMap);
        return shiroFilterFactoryBean;
    }

    @Bean
    public DefaultWebSecurityManager securityManager() {
        DefaultWebSecurityManager securityManager = new DefaultWebSecurityManager();
        // 注入realm
        securityManager.setRealm(systemAuthorizingRealm());
        // 注入缓存管理器
        securityManager.setCacheManager(ehCacheManager());
        // 注入session管理器
        securityManager.setSessionManager(sessionManager());
        // 注入记住我管理器
        securityManager.setRememberMeManager(rememberMeManager());
        return securityManager;
    }

    @Bean
    public SimpleCookie rememberMeCookie() {

        // 这个参数是cookie的名称，对应前端的checkbox的name = rememberMe
        SimpleCookie simpleCookie = new SimpleCookie("rememberMe");
        // <!-- 记住我cookie生效时间30天 ,单位秒;-->
        simpleCookie.setMaxAge(259200);
        return simpleCookie;
    }

    /**
     * cookie管理对象;
     * 
     * @return
     */
    @Bean
    public CookieRememberMeManager rememberMeManager() {
        CookieRememberMeManager cookieRememberMeManager = new CookieRememberMeManager();
        cookieRememberMeManager.setCipherKey(Base64.decode("2AvVhdsgUs0FSA3SDFAder=="));
        cookieRememberMeManager.setCookie(rememberMeCookie());
        return cookieRememberMeManager;
    }

    /**
     * 创建代理
     *
     * @return
     */
    @Bean
    @DependsOn(value = "lifecycleBeanPostProcessor")
    public DefaultAdvisorAutoProxyCreator defaultAdvisorAutoProxyCreator() {
        DefaultAdvisorAutoProxyCreator creator = new DefaultAdvisorAutoProxyCreator();
        creator.setProxyTargetClass(true);
        return creator;
    }

    /**
     * 开启shiro aop注解支持. 使用代理方式;所以需要开启代码支持;
     * 
     * @param securityManager
     * @return
     */
    @Bean
    public AuthorizationAttributeSourceAdvisor
            authorizationAttributeSourceAdvisor(SecurityManager securityManager) {
        AuthorizationAttributeSourceAdvisor advisor = new AuthorizationAttributeSourceAdvisor();
        advisor.setSecurityManager(securityManager);
        return advisor;
    }

    /**
     * seesion管理器设置
     * 
     * @return
     */
    @Bean(name = "sessionManager")
    public DefaultWebSessionManager sessionManager() {
        DefaultWebSessionManager sessionManager = new SessionManager();
        sessionManager.setGlobalSessionTimeout(1800000);
        sessionManager.setSessionValidationInterval(120000);
        sessionManager.setSessionIdCookieEnabled(true);
        sessionManager.setSessionIdCookie(getSessionIdCookie());
        sessionManager.setSessionIdCookieEnabled(true);
        sessionManager.setSessionDAO(sessionDAO());
        return sessionManager;

    }

    @Bean(name = "sessionIdCookie")
    public SimpleCookie getSessionIdCookie() {
        SimpleCookie cookie = new SimpleCookie("otasys.session.id");
        cookie.setHttpOnly(true);
        cookie.setMaxAge(-1);
        return cookie;
    }

    @Bean
    public EnterpriseCacheSessionDAO sessionDAO() {
        EnterpriseCacheSessionDAO sessionDAO = new CacheSessionDAO();
        sessionDAO.setCacheManager(ehCacheManager());
        sessionDAO.setActiveSessionsCacheName("activeSessionsCache");
        SessionIdGenerator idGenerator = new IdGen();
        sessionDAO.setSessionIdGenerator(idGenerator);
        return sessionDAO;
    }

    /**
     * 管理员用登录过滤器
     */
    public FormAuthenticationFilter customerFormAuthenticationFilter() {
        FormAuthenticationFilter formAuthenticationFilter = new FormAuthenticationFilter();
        formAuthenticationFilter.setLoginUrl("/customer/login");
        formAuthenticationFilter.setSuccessUrl("?login");
        return formAuthenticationFilter;
    }

    /**
     * 管理员用登录过滤器
     */
    public FormAuthenticationFilter formAuthenticationFilter() {
        FormAuthenticationFilter formAuthenticationFilter = new FormAuthenticationFilter();
        formAuthenticationFilter.setLoginUrl("/login");
        formAuthenticationFilter.setSuccessUrl("?login");
        return formAuthenticationFilter;
    }

    /**
     * 限制同一账号登录同时登录人数控制
     * 
     * @return
     */
    public KickoutSessionFilter kickoutSessionFilter() {
        KickoutSessionFilter kickoutSessionFilter = new KickoutSessionFilter();
        // 使用cacheManager获取相应的cache来缓存用户登录的会话；用于保存用户—会话之间的关系的；
        // 这里我们还是用之前shiro使用的redisManager()实现的cacheManager()缓存管理
        // 也可以重新另写一个，重新配置缓存时间之类的自定义缓存属性
        kickoutSessionFilter.setCacheManager(ehCacheManager());
        // 用于根据会话ID，获取会话进行踢出操作的；
        kickoutSessionFilter.setSessionManager(sessionManager());
        // 是否踢出后来登录的，默认是false；即后者登录的用户踢出前者登录的用户；踢出顺序。
        kickoutSessionFilter.setKickoutAfter(false);
        // 同一个用户最大的会话数，默认1；比如2的意思是同一个用户允许最多同时两个人登录；
        kickoutSessionFilter.setMaxSession(1);
        // 被踢出后重定向到的地址；
        kickoutSessionFilter.setKickoutUrl("/login?kickout");
        return kickoutSessionFilter;
    }

}
