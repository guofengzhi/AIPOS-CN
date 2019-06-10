package com.jiewen.modules.sys.entity;

import com.jiewen.jwp.base.entity.DataEntity;

public class App extends DataEntity {

	private static final long serialVersionUID = 1L;
	private String id;
	private String appName;
	private String appLogo;
	private String appImg;
	private String appPackage;
	private String appFile;
	private String appDeveloper;
	private String organId;
	private String remarks;
	private String delFlag;
	private String currentApproveFlag;
	private String currentApproveGrade;
	private String category;
	private String platform;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getAppName() {
		return appName;
	}
	public void setAppName(String appName) {
		this.appName = appName;
	}
	public String getAppLogo() {
		return appLogo;
	}
	public void setAppLogo(String appLogo) {
		this.appLogo = appLogo;
	}
	public String getAppImg() {
		return appImg;
	}
	public void setAppImg(String appImg) {
		this.appImg = appImg;
	}
	public String getAppPackage() {
		return appPackage;
	}
	public void setAppPackage(String appPackage) {
		this.appPackage = appPackage;
	}
	public String getAppDeveloper() {
		return appDeveloper;
	}
	public void setAppDeveloper(String appDeveloper) {
		this.appDeveloper = appDeveloper;
	}
	public User getCreateBy() {
		return createBy;
	}
	public void setCreateBy(User createBy) {
		this.createBy = createBy;
	}
	public User getUpdateBy() {
		return updateBy;
	}
	public void setUpdateBy(User updateBy) {
		this.updateBy = updateBy;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public String getDelFlag() {
		return delFlag;
	}
	public void setDelFlag(String delFlag) {
		this.delFlag = delFlag;
	}
	public String getCurrentApproveFlag() {
		return currentApproveFlag;
	}
	public void setCurrentApproveFlag(String currentApproveFlag) {
		this.currentApproveFlag = currentApproveFlag;
	}
	public String getCurrentApproveGrade() {
		return currentApproveGrade;
	}
	public void setCurrentApproveGrade(String currentApproveGrade) {
		this.currentApproveGrade = currentApproveGrade;
	}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public String getPlatform() {
		return platform;
	}
	public void setPlatform(String platform) {
		this.platform = platform;
	}
	public String getAppFile() {
		return appFile;
	}
	public void setAppFile(String appFile) {
		this.appFile = appFile;
	}
	public String getOrganId() {
		return organId;
	}
	public void setOrganId(String organId) {
		this.organId = organId;
	}
	
}
