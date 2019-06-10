
package com.jiewen.spp.modules.app.entity;

import com.jiewen.base.core.entity.DataEntity;

public class AppVersion extends DataEntity<AppVersion> {

	private static final long serialVersionUID = 1L;

	private String appName;

	private String appPackage;

	private String appVersion;
	
	private String appVersionNumber;

	private String appFile;

	private String appMd5;

	private String appDescription;

	private String upgradeMode;

	private String organId;

	private String manuJsonStr;

	private String releaseType;

	private String appVersionCompareVal;

	private String startHard;

	private String endHard;

	private String startHardShift;

	private String endHardShift;

	private String upgradeType;

	private String upgradeDesc;

	private String appFileSize;

	public String getAppFileSize() {
		return appFileSize;
	}

	public void setAppFileSize(String appFileSize) {
		this.appFileSize = appFileSize;
	}

	public String getUpgradeType() {
		return upgradeType;
	}

	public void setUpgradeType(String upgradeType) {
		this.upgradeType = upgradeType;
	}

	public String getUpgradeDesc() {
		return upgradeDesc;
	}

	public void setUpgradeDesc(String upgradeDesc) {
		this.upgradeDesc = upgradeDesc;
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

	public String getAppFile() {
		return appFile;
	}

	public void setAppFile(String appFile) {
		this.appFile = appFile;
	}

	public String getAppMd5() {
		return appMd5;
	}

	public void setAppMd5(String appMd5) {
		this.appMd5 = appMd5;
	}

	public String getAppDescription() {
		return appDescription;
	}

	public void setAppDescription(String appDescription) {
		this.appDescription = appDescription;
	}

	public String getUpgradeMode() {
		return upgradeMode;
	}

	public void setUpgradeMode(String upgradeMode) {
		this.upgradeMode = upgradeMode;
	}

	public String getOrganId() {
		return organId;
	}

	public void setOrganId(String organId) {
		this.organId = organId;
	}

	public String getManuJsonStr() {
		return manuJsonStr;
	}

	public void setManuJsonStr(String manuJsonStr) {
		this.manuJsonStr = manuJsonStr;
	}

	public String getReleaseType() {
		return releaseType;
	}

	public void setReleaseType(String releaseType) {
		this.releaseType = releaseType;
	}

	public String getAppVersionCompareVal() {
		return appVersionCompareVal;
	}

	public void setAppVersionCompareVal(String appVersionCompareVal) {
		this.appVersionCompareVal = appVersionCompareVal;
	}

	public String getStartHard() {
		return startHard;
	}

	public void setStartHard(String startHard) {
		this.startHard = startHard;
	}

	public String getEndHard() {
		return endHard;
	}

	public void setEndHard(String endHard) {
		this.endHard = endHard;
	}

	public String getStartHardShift() {
		return startHardShift;
	}

	public void setStartHardShift(String startHardShift) {
		this.startHardShift = startHardShift;
	}

	public String getEndHardShift() {
		return endHardShift;
	}

	public void setEndHardShift(String endHardShift) {
		this.endHardShift = endHardShift;
	}

	public String getAppVersionNumber() {
		return appVersionNumber;
	}

	public void setAppVersionNumber(String appVersionNumber) {
		this.appVersionNumber = appVersionNumber;
	}


}
