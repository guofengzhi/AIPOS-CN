
package com.jiewen.base.config;

import java.io.File;
import java.io.IOException;

import org.springframework.context.EnvironmentAware;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;
import org.springframework.core.io.DefaultResourceLoader;

import com.jiewen.commons.MyRuntimeException;
import com.jiewen.jwp.common.utils.StringUtils;

/**
 * 全局配置类 Created by Administrator on 2017/1/22.
 */
@Configuration
public class Global implements EnvironmentAware {

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
     * 支付平台
     */
    public static final String WX = "0";

    public static final String AL = "1";

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
     * 上传文件基础虚拟路径
     */
    public static final String USERFILES_BASE_URL = "/userfiles/";

    /**
     * 获取当前对象实例
     */
    public static Global getInstance() {
        return global;
    }

    /**
     * 获取配置
     * 
     * @see {fns:getConfig('adminPath')}
     */
    public static String getConfig(String key) {
        return environment.getProperty(key);
    }

    /**
     * 获取管理端根路径
     */
    public static String getAdminPath() {
        return getConfig("adminPath");
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

    /**
     * 获取工程路径
     * 
     * @return
     */
    public static String getProjectPath() {
        // 如果配置了工程路径，则直接返回，否则自动获取。
        String projectPath = Global.getConfig("projectPath");
        if (StringUtils.isNotBlank(projectPath)) {
            return projectPath;
        }
        try {
            File file = new DefaultResourceLoader().getResource("").getFile();
            if (file != null) {
                while (true) {
                    File f = new File(
                            file.getPath() + File.separator + "src" + File.separator + "main");
                    if (f.exists()) {
                        break;
                    }
                    if (file.getParentFile() != null) {
                        file = file.getParentFile();
                    }
                }
                projectPath = file.toString();
            }
        } catch (IOException e) {
            throw new MyRuntimeException();
        }
        return projectPath;
    }

    @Override
    public void setEnvironment(Environment environment) {
        Global.environment = environment;
    }

}
