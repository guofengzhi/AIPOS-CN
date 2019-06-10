package com.jiewen.spp.model;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

@Table(name = "t_sys_dict")
public class SysDict {

	/**
	 * ID
	 */
	@Id
	private String id;

	@Column(name = "value")
	private String value; // 数据值

	@Column(name = "label")
	private String label; // 标签名

	@Column(name = "type")
	private String type; // 类型

	@Column(name = "description")
	private String description; // 描述

	@Column(name = "sort")
	private Integer sort; // 排序

	@Column(name = "parent_id")
	private String parentId; // 父Id

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label = label;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Integer getSort() {
		return sort;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
	}

	public String getParentId() {
		return parentId;
	}

	public void setParentId(String parentId) {
		this.parentId = parentId;
	}

}
