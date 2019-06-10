package com.jiewen.modules.app.entity;

import com.jiewen.jwp.base.entity.DataEntity;

public class AppOfficeInfo extends DataEntity{

	private static final long serialVersionUID = 1L;

	private String appId;

	private String organId;

	private String organGrade;

	public String getAppId() {
		return appId;
	}

	public void setAppId(String appId) {
		this.appId = appId;
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

}
