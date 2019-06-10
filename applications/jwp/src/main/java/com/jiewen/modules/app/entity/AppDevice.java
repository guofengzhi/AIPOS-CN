package com.jiewen.modules.app.entity;


import com.jiewen.jwp.base.entity.DataEntity;

public class AppDevice extends DataEntity {

	private static final long serialVersionUID = 1L;

	private Long apkId;

	private String maunNo;

	private String deviceType;

	private String deviceSn;

	private String appRecordId;

	private String deviceApkVersion;

	private String apkVersionShifter;

	private String strategyDesc;

	private String upgradeType;

	private String upgradeDesc;

	public String getUpgradeDesc() {
		return upgradeDesc;
	}

	public void setUpgradeDesc(String upgradeDesc) {
		this.upgradeDesc = upgradeDesc;
	}

	public String getDeviceApkVersion() {
		return deviceApkVersion;
	}

	public void setDeviceApkVersion(String deviceApkVersion) {
		this.deviceApkVersion = deviceApkVersion;
	}

	public String getApkVersionShifter() {
		return apkVersionShifter;
	}

	public void setApkVersionShifter(String apkVersionShifter) {
		this.apkVersionShifter = apkVersionShifter;
	}

	public String getStrategyDesc() {
		return strategyDesc;
	}

	public void setStrategyDesc(String strategyDesc) {
		this.strategyDesc = strategyDesc;
	}

	public String getUpgradeType() {
		return upgradeType;
	}

	public void setUpgradeType(String upgradeType) {
		this.upgradeType = upgradeType;
	}

	public Long getApkId() {
		return apkId;
	}

	public void setApkId(Long apkId) {
		this.apkId = apkId;
	}

	public String getMaunNo() {
		return maunNo;
	}

	public void setMaunNo(String maunNo) {
		this.maunNo = maunNo;
	}

	public String getDeviceType() {
		return deviceType;
	}

	public void setDeviceType(String deviceType) {
		this.deviceType = deviceType;
	}

	public String getDeviceSn() {
		return deviceSn;
	}

	public void setDeviceSn(String deviceSn) {
		this.deviceSn = deviceSn;
	}

	public String getAppRecordId() {
		return appRecordId;
	}

	public void setAppRecordId(String appRecordId) {
		this.appRecordId = appRecordId;
	}

}
