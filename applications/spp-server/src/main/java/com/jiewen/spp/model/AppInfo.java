package com.jiewen.spp.model;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Table(name = "t_app_info")
public class AppInfo {

	/**
	 * ID
	 */
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;

	@Column(name = "app_name")
	private String appName;

	@Column(name = "app_logo")
	private String appLogo;

	@Column(name = "app_img")
	private String appImg;

	@Column(name = "app_package")
	private String appPackage;
	
	@Column(name = "app_version_number")
	private String appVersionNumber;
	
	public String getAppVersionNumber() {
		return appVersionNumber;
	}

	public void setAppVersionNumber(String appVersionNumber) {
		this.appVersionNumber = appVersionNumber;
	}

	private String appPackageName;

	@Column(name = "app_developer")
	private String appDeveloper;

	@Column(name = "organ_id")
	private String organId;

	@Column(name = "approve_flag")
	private String approveFlag;

	@Column(name = "category")
	private String category;

	@Column(name = "platform")
	private String platform;

	private String versionId;

	private String appVersion;

	private String appFile;

	private String appDescription;

	private String appImg1;

	private String appImg2;

	private String appImg3;

	private String appFileSize;

	private String versionCode;

	private String versionNumber;

	private String counts;

	private String dbName;

	private int startPageNum;

	private int pageSize;

	private String ids;

	public String getIds() {
		return ids;
	}

	public void setIds(String ids) {
		this.ids = ids;
	}

	public int getStartPageNum() {
		return startPageNum;
	}

	public void setStartPageNum(int startPageNum) {
		this.startPageNum = startPageNum;
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public String getDbName() {
		return dbName;
	}

	public void setDbName(String dbName) {
		this.dbName = dbName;
	}

	public String getCounts() {
		return counts;
	}

	public void setCounts(String counts) {
		this.counts = counts;
	}

	public String getVersionCode() {
		return versionCode;
	}

	public void setVersionCode(String versionCode) {
		this.versionCode = versionCode;
	}

	public String getVersionNumber() {
		return versionNumber;
	}

	public void setVersionNumber(String versionNumber) {
		this.versionNumber = versionNumber;
	}

	public String getAppPackageName() {
		return appPackageName;
	}

	public void setAppPackageName(String appPackageName) {
		this.appPackageName = appPackageName;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getAppFileSize() {
		return appFileSize;
	}

	public void setAppFileSize(String appFileSize) {
		this.appFileSize = appFileSize;
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

	public String getOrganId() {
		return organId;
	}

	public void setOrganId(String organId) {
		this.organId = organId;
	}

	public String getApproveFlag() {
		return approveFlag;
	}

	public void setApproveFlag(String approveFlag) {
		this.approveFlag = approveFlag;
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

	public String getVersionId() {
		return versionId;
	}

	public void setVersionId(String versionId) {
		this.versionId = versionId;
	}

	public String getAppVersion() {
		return appVersion;
	}

	public void setAppVersion(String appVersion) {
		this.appVersion = appVersion;
	}

	public String getAppFile() {
		return appFile;
	}

	public void setAppFile(String appFile) {
		this.appFile = appFile;
	}

	public String getAppDescription() {
		return appDescription;
	}

	public void setAppDescription(String appDescription) {
		this.appDescription = appDescription;
	}

	public String getAppImg1() {
		return appImg1;
	}

	public void setAppImg1(String appImg1) {
		this.appImg1 = appImg1;
	}

	public String getAppImg2() {
		return appImg2;
	}

	public void setAppImg2(String appImg2) {
		this.appImg2 = appImg2;
	}

	public String getAppImg3() {
		return appImg3;
	}

	public void setAppImg3(String appImg3) {
		this.appImg3 = appImg3;
	}

}
