package com.jiewen.modules.sys.fieldtype;

import org.apache.commons.lang3.StringUtils;

import com.jiewen.modules.sys.entity.Area;
import com.jiewen.modules.sys.utils.UserUtils;

/**
 * 字段类型转换
 */
public class AreaType {

    /**
     * 获取对象值（导入）
     */
    public static Object getValue(String val) {
        for (Area e : UserUtils.getAreaList()) {
            if (StringUtils.trimToEmpty(val).equals(e.getName())) {
                return e;
            }
        }
        return null;
    }

    /**
     * 获取对象值（导出）
     */
    public static String setValue(Object val) {
        if (val != null && ((Area) val).getName() != null) {
            return ((Area) val).getName();
        }
        return "";
    }

    private AreaType() {
        throw new IllegalStateException("Utility class");
    }
}
