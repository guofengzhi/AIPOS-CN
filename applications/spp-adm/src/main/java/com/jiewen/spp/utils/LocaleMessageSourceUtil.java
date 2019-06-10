
package com.jiewen.spp.utils;

import java.util.Locale;

import javax.annotation.Resource;

import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Component;

import com.jiewen.jwp.common.utils.StringUtils;

@Component
public class LocaleMessageSourceUtil {

    @Resource
    private MessageSource messageSource;

    public String getMessage(String code) {
        return getMessage(code, null);
    }

    /**
     *
     * @param code
     *            ：对应messages配置的key.
     * @param args
     *            : 数组参数.
     * @return
     */
    public String getMessage(String code, Object[] args) {
        return getMessage(code, "", args);
    }

    /**
     *
     * @param code
     *            ：对应messages配置的key.
     * @param args
     *            : 数组参数.
     * @param defaultMessage
     *            : 没有设置key的时候的默认值.
     * @return
     */
    public String getMessage(String code, String defaultMessage, Object[] args) {
        // 这里使用比较方便的方法，不依赖request.
        Locale locale = LocaleContextHolder.getLocale();
        if (StringUtils.equalsAny("en", locale.toString())) {
            locale = Locale.US;
        }
        return messageSource.getMessage(code, args, defaultMessage, locale);
    }

    /**
     * 获取使用带有默认值message
     * 
     * @param code
     * @param defaultMessage
     * @return
     */
    public String getDefaultMessage(String code, String defaultMessage) {
        return getMessage(code, defaultMessage, null);
    }
}