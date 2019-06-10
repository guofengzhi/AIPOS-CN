
package com.jiewen.base.sys.entity;

import javax.validation.constraints.NotNull;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.jiewen.base.core.entity.DataEntity;
import com.jiewen.jwp.common.utils.StringUtils;

/**
 * 菜单Entity
 * 
 */
public class Menu extends DataEntity<Menu> {

    private static final long serialVersionUID = 1L;

    private String name;

    private Menu parent;

    private String code;

    private String url;

    private String parentId;

    private String parentIds;

    private String levelCode;

    private String icon;

    // 0=目录 1=功能 2=按钮
    private String functype;

    private String isShow;

    private String parentName;

    private String enParentName;

    private String twParentName;

    private String permission; // 权限标识

    private User user;

    private String enName;

    private String tcName;

    private String showName;

    public Menu() {
        super();
    }

    public Menu(String id) {
        super(id);
    }

    public Menu(User user) {
        this();
        this.user = user;
    }

    @NotNull
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @NotNull
    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getParentId() {
        return parentId;
    }

    public void setParentId(String parentId) {
        this.parentId = parentId;
    }

    @NotNull
    public String getLevelCode() {
        return levelCode;
    }

    public void setLevelCode(String levelCode) {
        this.levelCode = levelCode;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public String getFunctype() {
        return functype;
    }

    public void setFunctype(String functype) {
        this.functype = functype;
    }

    public String getParentName() {
        return parentName;
    }

    public void setParentName(String parentName) {
        this.parentName = parentName;
    }

    public String getPermission() {
        return permission;
    }

    public void setPermission(String permission) {
        this.permission = permission;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getParentIds() {
        return parentIds;
    }

    public void setParentIds(String parentIds) {
        this.parentIds = parentIds;
    }

    public Menu getParent() {
        return parent;
    }

    public void setParent(Menu parent) {
        this.parent = parent;
    }

    @JsonIgnore
    public static String getRootId() {
        return "0";
    }

    public String getIsShow() {
        return isShow;
    }

    public void setIsShow(String isShow) {
        this.isShow = StringUtils.isEmpty(StringUtils.trimToEmpty(isShow)) ? IS_SHOW_ENABLE
                : isShow;
    }

    public String getEnName() {
        return enName;
    }

    public void setEnName(String enName) {
        this.enName = enName;
    }

    public String getTcName() {
        return tcName;
    }

    public void setTcName(String tcName) {
        this.tcName = tcName;
    }

    public String getShowName() {
        return showName;
    }

    public void setShowName(String showName) {
        this.showName = showName;
    }

    public String getEnParentName() {
        return enParentName;
    }

    public void setEnParentName(String enParentName) {
        this.enParentName = enParentName;
    }

    public String getTwParentName() {
        return twParentName;
    }

    public void setTwParentName(String twParentName) {
        this.twParentName = twParentName;
    }

}