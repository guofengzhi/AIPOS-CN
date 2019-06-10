package com.jiewen.jwp.base.config;


import com.google.common.base.Strings;
import org.springframework.context.EnvironmentAware;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;



/**
 * 全局配置类
 */
@Configuration
public class Global implements EnvironmentAware{

    /**
     * 当前对象实例
     */
    private static Global global = new Global();



    /**
     * 属性文件加载对象
     */
    private static Environment environment;


    /**
     * 显示/隐藏
     */
    public static final String SHOW = "1";
    
    public static final String HIDE = "0";

    /**
     * 是/否
     */
    public static final String YES = "1";
    
    public static final String NO = "0";

    /**
     * 对/错
     */
    public static final String TRUE = "true";
    
    public static final String FALSE = "false";



    /**
     * 获取当前对象实例
     */
    public static Global getInstance() {
        return global;
    }

    /**
     * 获取配置
     */
    public static String getConfig(String key) {
        return Strings.nullToEmpty(environment.getProperty(key));
    }

    /**
     * 获取URL后缀
     */
    public static String getUrlSuffix() {
        return getConfig("urlSuffix");
    }

    /**
     * 页面获取常量
     * 
     * @see {fns:getConst('YES')}
     */
    public static Object getConst(String field) {
        try {
            return Global.class.getField(field).get(null);
        } catch (Exception e) {
            // 异常代表无配置，这里什么也不做
        }
        return null;
    }

    @Override
    public void setEnvironment(Environment environment) {
        Global.environment = environment;
    }

}
