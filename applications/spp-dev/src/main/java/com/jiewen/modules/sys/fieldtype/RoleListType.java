package com.jiewen.modules.sys.fieldtype;

import java.util.List;

import org.apache.commons.lang3.StringUtils;

import com.google.common.collect.Lists;
import com.jiewen.jwp.common.Collections3;
import com.jiewen.jwp.common.SpringUtil;
import com.jiewen.modules.sys.entity.Role;
import com.jiewen.modules.sys.service.SystemService;

/**
 * 字段类型转换
 */
public class RoleListType {

    private static SystemService systemService = SpringUtil.getBean(SystemService.class);

    /**
     * 获取对象值（导入）
     */
    public static Object getValue(String val) {
        List<Role> roleList = Lists.newArrayList();
        List<Role> allRoleList = systemService.findAllRole();
        for (String s : StringUtils.split(val, ",")) {
            for (Role e : allRoleList) {
                if (StringUtils.trimToEmpty(s).equals(e.getName())) {
                    roleList.add(e);
                }
            }
        }
        return roleList.isEmpty() ? null : roleList;
    }

    /**
     * 设置对象值（导出）
     */
    public static String setValue(Object val) {
        if (val != null) {
            @SuppressWarnings("unchecked")
            List<Role> roleList = (List<Role>) val;
            return Collections3.extractToString(roleList, "name", ", ");
        }
        return "";
    }

    private RoleListType() {
        throw new IllegalStateException("Utility class");
    }

}
