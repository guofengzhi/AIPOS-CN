package com.jiewen.modules.workflow.entity;

import com.jiewen.jwp.base.entity.DataEntity;

public class ProcDefVo extends DataEntity {

	private static final long serialVersionUID = 1L;

	private Integer rev;

	private String name;

	private String key;

	private String category;

	private Integer version;

	private String deploymentId;

	private String resouceName;

	private String dgrmSourceName;

	private String description;

	private Short hasStartFormKey;

	private Short hasGraphicalNotation;

	private Integer suspensionState;

	private String tenantId;

	public Integer getRev() {
		return rev;
	}

	public void setRev(Integer rev) {
		this.rev = rev;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public String getDeploymentId() {
		return deploymentId;
	}

	public void setDeploymentId(String deploymentId) {
		this.deploymentId = deploymentId;
	}

	public String getResouceName() {
		return resouceName;
	}

	public void setResouceName(String resouceName) {
		this.resouceName = resouceName;
	}

	public String getDgrmSourceName() {
		return dgrmSourceName;
	}

	public void setDgrmSourceName(String dgrmSourceName) {
		this.dgrmSourceName = dgrmSourceName;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Short getHasStartFormKey() {
		return hasStartFormKey;
	}

	public void setHasStartFormKey(Short hasStartFormKey) {
		this.hasStartFormKey = hasStartFormKey;
	}

	public Short getHasGraphicalNotation() {
		return hasGraphicalNotation;
	}

	public void setHasGraphicalNotation(Short hasGraphicalNotation) {
		this.hasGraphicalNotation = hasGraphicalNotation;
	}

	public Integer getSuspensionState() {
		return suspensionState;
	}

	public void setSuspensionState(Integer suspensionState) {
		this.suspensionState = suspensionState;
	}

	public String getTenantId() {
		return tenantId;
	}

	public void setTenantId(String tenantId) {
		this.tenantId = tenantId;
	}

}
