
package com.jiewen.base.core.entity;

import org.hibernate.validator.constraints.Length;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.jiewen.jwp.common.utils.Reflections;
import com.jiewen.jwp.common.utils.StringUtils;

/**
 * 数据Entity类 Created by Administrator on 2017/1/22.
 */
public abstract class TreeEntity<T> extends DataEntity<T> {

    private static final long serialVersionUID = -5324084380620177782L;

    protected T parent; // 父级编号

    protected String parentIds; // 所有父级编号

    protected String name; // 机构名称

    protected Integer sort; // 排序

    protected String parentName; // 父级机构名称

    protected String parentId;

    protected String action; // 页面操作显示

    public TreeEntity() {
        super();
        this.sort = 30;
    }

    public TreeEntity(String id) {
        super(id);
    }

    /**
     * 父对象，只能通过子类实现，父类实现mybatis无法读取
     * 
     * @return
     */
    @JsonBackReference
    public abstract T getParent();

    /**
     * 父对象，只能通过子类实现，父类实现mybatis无法读取
     * 
     * @return
     */
    public abstract void setParent(T parent);

    @Length(min = 1, max = 2000)
    public String getParentIds() {
        return parentIds;
    }

    public void setParentIds(String parentIds) {
        this.parentIds = parentIds;
    }

    @Length(min = 1, max = 100)
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getParentName() {
        return parentName;
    }

    public void setParentName(String parentName) {
        this.parentName = parentName;
    }

    public Integer getSort() {
        return sort;
    }

    public void setSort(Integer sort) {
        this.sort = sort;
    }

    public String getParentId() {
        String id = this.parentId;
        if (parent != null) {
            id = (String) Reflections.getFieldValue(parent, "id");
        }
        return StringUtils.isNotBlank(id) ? id : "0";
    }

    public void setParentId(String parentId) {
        this.parentId = parentId;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

}
