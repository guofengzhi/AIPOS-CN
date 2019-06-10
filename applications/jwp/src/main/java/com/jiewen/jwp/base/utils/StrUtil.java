
package com.jiewen.jwp.base.utils;

import org.apache.commons.lang3.StringUtils;

public class StrUtil {

    /**
     * 1,2,3转化为'1','2','3'
     *
     * @param str
     * @return
     */
    public static String getInStr(String str) {
        String[] strArr = StringUtils.split(str, ',');
        String[] retArr = new String[strArr.length];
        for (int i = 0; i < strArr.length; i++) {
            retArr[i] = "'" + strArr[i].trim() + "'";
        }
        return StringUtils.join(retArr, ",");
    }
    
    /**
     * 字符串是否为空
     *
     * @param str 字符串
     * @return 返回类型 boolean 为空则为true，否则为false
     */
    public static boolean isEmpty(String str) {
        if (str == null || "".equals(str) 
        		|| "".equals(str.trim()) 
        		|| str.equals("null")
        		|| str.equals("undefined")){
            return true;
        }
        return false;
    }
}
