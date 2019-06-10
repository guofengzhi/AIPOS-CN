package com.jiewen.spp.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

@Table(name = "t_app_upgrade_record")
public class AppUpgradeRecord {

	/**
	 * ID
	 */
	@Id
	private Long id;

	@Column(name = "device_sn")
	private String deviceSn;

	@Column(name = "app_id")
	private Long appId;

	@Column(name = "app_name")
	private String appName;

	@Column(name = "app_package")
	private String appPackage;

	@Column(name = "app_version")
	private String appVersion;

	@Column(name = "app_file_path")
	private String appFilePath;

	@Column(name = "app_file_name")
	private String appFileName;

	@Column(name = "app_file_size")
	private String appFileSize;

	@Column(name = "upgrade_date")
	private Date upgradeDate;

	@Column(name = "remarks")
	private String remarks;

	@Column(name = "organ_id")
	private String organId;

	@Column(name = "del_flag")
	private String delFlag;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getDeviceSn() {
		return deviceSn;
	}

	public void setDeviceSn(String deviceSn) {
		this.deviceSn = deviceSn;
	}

	public Long getAppId() {
		return appId;
	}

	public void setAppId(Long appId) {
		this.appId = appId;
	}

	public String getAppName() {
		return appName;
	}

	public void setAppName(String appName) {
		this.appName = appName;
	}

	public String getAppPackage() {
		return appPackage;
	}

	public void setAppPackage(String appPackage) {
		this.appPackage = appPackage;
	}

	public String getAppVersion() {
		return appVersion;
	}

	public void setAppVersion(String appVersion) {
		this.appVersion = appVersion;
	}

	public String getAppFilePath() {
		return appFilePath;
	}

	public void setAppFilePath(String appFilePath) {
		this.appFilePath = appFilePath;
	}

	public String getAppFileName() {
		return appFileName;
	}

	public void setAppFileName(String appFileName) {
		this.appFileName = appFileName;
	}

	public String getAppFileSize() {
		return appFileSize;
	}

	public void setAppFileSize(String appFileSize) {
		this.appFileSize = appFileSize;
	}

	public Date getUpgradeDate() {
		return upgradeDate;
	}

	public void setUpgradeDate(Date upgradeDate) {
		this.upgradeDate = upgradeDate;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getOrganId() {
		return organId;
	}

	public void setOrganId(String organId) {
		this.organId = organId;
	}

	public String getDelFlag() {
		return delFlag;
	}

	public void setDelFlag(String delFlag) {
		this.delFlag = delFlag;
	}

}
