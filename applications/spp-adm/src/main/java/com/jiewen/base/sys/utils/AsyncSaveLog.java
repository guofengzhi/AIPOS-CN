
package com.jiewen.base.sys.utils;

import java.lang.reflect.Method;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;
import org.springframework.web.method.HandlerMethod;

import com.jiewen.base.common.utils.Exceptions;
import com.jiewen.base.sys.dao.LogDao;
import com.jiewen.base.sys.entity.Log;
import com.jiewen.jwp.common.utils.StringUtils;

@Component
public class AsyncSaveLog {

    @Async
    public void ayncSaveLog(Log log, Object handler, Exception ex, LogDao logDao) {
        // 获取日志标题
        if (StringUtils.isBlank(log.getTitle())) {
            String permission = "";
            if (handler instanceof HandlerMethod) {
                Method m = ((HandlerMethod) handler).getMethod();
                RequiresPermissions rp = m.getAnnotation(RequiresPermissions.class);
                permission = (rp != null ? StringUtils.join(rp.value(), ",") : "");
            }
            log.setTitle(LogUtils.getMenuNamePath(log.getRequestUri(), permission));
        }
        // 如果有异常，设置异常信息
        log.setException(Exceptions.getStackTraceAsString(ex));
        // 如果无标题并无异常日志，则不保存信息
        if (StringUtils.isBlank(log.getTitle()) && StringUtils.isBlank(log.getException())) {
            return;
        }
        // 保存日志信息
        log.preInsert();
        logDao.insert(log);
    }

}