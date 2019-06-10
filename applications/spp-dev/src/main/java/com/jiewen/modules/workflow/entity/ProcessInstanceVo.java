package com.jiewen.modules.workflow.entity;

import java.util.Date;

import com.jiewen.jwp.base.entity.DataEntity;

public class ProcessInstanceVo extends DataEntity {

	private static final long serialVersionUID = 1L;

	private Integer rev;

	private String procInstId;

	private String businessKey;

	private String parentId;

	private String procDefId;

	private String superExec;

	private String actId;

	private Short isActive;

	private Short isConcurrent;

	private Short isScope;

	private Short isEventScope;

	private Integer suspensionState;

	private Integer cachedEntState;

	private String tenantId;

	private String name;

	private Date lockTime;

	private String processDefinitionKey;

	private String processDefinitionId;

	private String processDefinitionName;

	private String processDefinitionVersion;

	private String deploymentId;

	private String category;

	private String startUserId;

	private String startUserName;

	private String activityId;

	private String instanceId;

	public String getInstanceId() {
		return instanceId;
	}

	public void setInstanceId(String instanceId) {
		this.instanceId = instanceId;
	}

	public String getActivityId() {
		return activityId;
	}

	public void setActivityId(String activityId) {
		this.activityId = activityId;
	}

	public String getStartUserId() {
		return startUserId;
	}

	public void setStartUserId(String startUserId) {
		this.startUserId = startUserId;
	}

	public String getStartUserName() {
		return startUserName;
	}

	public void setStartUserName(String startUserName) {
		this.startUserName = startUserName;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getProcessDefinitionKey() {
		return processDefinitionKey;
	}

	public void setProcessDefinitionKey(String processDefinitionKey) {
		this.processDefinitionKey = processDefinitionKey;
	}

	public String getProcessDefinitionId() {
		return processDefinitionId;
	}

	public void setProcessDefinitionId(String processDefinitionId) {
		this.processDefinitionId = processDefinitionId;
	}

	public String getProcessDefinitionName() {
		return processDefinitionName;
	}

	public void setProcessDefinitionName(String processDefinitionName) {
		this.processDefinitionName = processDefinitionName;
	}

	public String getProcessDefinitionVersion() {
		return processDefinitionVersion;
	}

	public void setProcessDefinitionVersion(String processDefinitionVersion) {
		this.processDefinitionVersion = processDefinitionVersion;
	}

	public String getDeploymentId() {
		return deploymentId;
	}

	public void setDeploymentId(String deploymentId) {
		this.deploymentId = deploymentId;
	}

	public Integer getRev() {
		return rev;
	}

	public void setRev(Integer rev) {
		this.rev = rev;
	}

	public String getProcInstId() {
		return procInstId;
	}

	public void setProcInstId(String procInstId) {
		this.procInstId = procInstId;
	}

	public String getBusinessKey() {
		return businessKey;
	}

	public void setBusinessKey(String businessKey) {
		this.businessKey = businessKey;
	}

	public String getParentId() {
		return parentId;
	}

	public void setParentId(String parentId) {
		this.parentId = parentId;
	}

	public String getProcDefId() {
		return procDefId;
	}

	public void setProcDefId(String procDefId) {
		this.procDefId = procDefId;
	}

	public String getSuperExec() {
		return superExec;
	}

	public void setSuperExec(String superExec) {
		this.superExec = superExec;
	}

	public String getActId() {
		return actId;
	}

	public void setActId(String actId) {
		this.actId = actId;
	}

	public Short getIsActive() {
		return isActive;
	}

	public void setIsActive(Short isActive) {
		this.isActive = isActive;
	}

	public Short getIsConcurrent() {
		return isConcurrent;
	}

	public void setIsConcurrent(Short isConcurrent) {
		this.isConcurrent = isConcurrent;
	}

	public Short getIsScope() {
		return isScope;
	}

	public void setIsScope(Short isScope) {
		this.isScope = isScope;
	}

	public Short getIsEventScope() {
		return isEventScope;
	}

	public void setIsEventScope(Short isEventScope) {
		this.isEventScope = isEventScope;
	}

	public Integer getSuspensionState() {
		return suspensionState;
	}

	public void setSuspensionState(Integer suspensionState) {
		this.suspensionState = suspensionState;
	}

	public Integer getCachedEntState() {
		return cachedEntState;
	}

	public void setCachedEntState(Integer cachedEntState) {
		this.cachedEntState = cachedEntState;
	}

	public String getTenantId() {
		return tenantId;
	}

	public void setTenantId(String tenantId) {
		this.tenantId = tenantId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Date getLockTime() {
		return lockTime;
	}

	public void setLockTime(Date lockTime) {
		this.lockTime = lockTime;
	}

}
