package com.jiewen.modules.app.entity;

import com.jiewen.jwp.base.entity.DataEntity;

public class ApprovalRecord extends DataEntity {

	private static final long serialVersionUID = 1L;

	private String appId;

	private String appName;

	private String organId;

	private String organGrade;

	private String approveRemarks;

	private String approveFlag;

	private String appDataScope;

	public String getAppId() {
		return appId;
	}

	public void setAppId(String appId) {
		this.appId = appId;
	}

	public String getAppName() {
		return appName;
	}

	public void setAppName(String appName) {
		this.appName = appName;
	}

	public String getOrganId() {
		return organId;
	}

	public void setOrganId(String organId) {
		this.organId = organId;
	}

	public String getOrganGrade() {
		return organGrade;
	}

	public void setOrganGrade(String organGrade) {
		this.organGrade = organGrade;
	}

	public String getApproveRemarks() {
		return approveRemarks;
	}

	public void setApproveRemarks(String approveRemarks) {
		this.approveRemarks = approveRemarks;
	}

	public String getApproveFlag() {
		return approveFlag;
	}

	public void setApproveFlag(String approveFlag) {
		this.approveFlag = approveFlag;
	}

	public String getAppDataScope() {
		return appDataScope;
	}

	public void setAppDataScope(String appDataScope) {
		this.appDataScope = appDataScope;
	}

}
