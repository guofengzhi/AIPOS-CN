package com.jiewen.spp.dto;

import java.io.Serializable;

import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Transient;

import com.jiewen.utils.StringUtil;

public class DeviceAppInfoDto implements Serializable, Comparable<DeviceAppInfoDto> {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * ID
	 */
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private long id;

	@Transient
	private String version;

	@Transient
	private String manufacturer;

	@Transient
	private String deviceType;

	@Transient
	private String deviceSn;

	@Transient
	private String appName;

	@Transient
	private String appPackage;

	@Transient
	private String appVersion;

	@Transient
	private String appFile;

	@Transient
	private String appMd5;

	@Transient
	private String appDescription;

	@Transient
	private String manufacturerNo;

	@Transient
	private String strategy;

	@Transient
	private String organId;

	@Transient
	private String hardware;

	@Transient
	private String startHardShift;

	@Transient
	private String deviceOsVersion;

	@Transient
	private String endHardShift;

	@Transient
	private String upgradeMode;

	@Transient
	private String deviceStatus;

	@Transient
	private String osStatus;
	
	@Transient
	private Long appVersionNumber;

	@Transient
	private String osUpgradeType;

	@Transient
	private String sourceId;

	@Transient
	private String category;

	@Transient
	private String platform;

	@Transient
	private String appFileSize;

	@Transient
	private String appImg;

	@Transient
	private String appLogo;

	@Transient
	private String strategyDesc;

	@Transient
	private String upgradeDesc;

	public String getStrategyDesc() {
		return strategyDesc;
	}

	public void setStrategyDesc(String strategyDesc) {
		this.strategyDesc = strategyDesc;
	}

	public String getUpgradeDesc() {
		return upgradeDesc;
	}

	public void setUpgradeDesc(String upgradeDesc) {
		this.upgradeDesc = upgradeDesc;
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

	public String getAppFileSize() {
		return appFileSize;
	}

	public void setAppFileSize(String appFileSize) {
		this.appFileSize = appFileSize;
	}

	public String getAppImg() {
		return appImg;
	}

	public void setAppImg(String appImg) {
		this.appImg = appImg;
	}

	public String getAppLogo() {
		return appLogo;
	}

	public void setAppLogo(String appLogo) {
		this.appLogo = appLogo;
	}

	public long getId() {
		return id;
	}

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	public String getManufacturer() {
		return manufacturer;
	}

	public void setManufacturer(String manufacturer) {
		this.manufacturer = manufacturer;
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

	public void setId(long id) {
		this.id = id;
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

	public String getManufacturerNo() {
		return manufacturerNo;
	}

	public void setManufacturerNo(String manufacturerNo) {
		this.manufacturerNo = manufacturerNo;
	}

	public String getStrategy() {
		return strategy;
	}

	public void setStrategy(String strategy) {
		this.strategy = strategy;
	}

	@Override
	public int compareTo(DeviceAppInfoDto o) {
		return StringUtil.compareVersion(this.getAppVersion(), o.getAppVersion());
	}

	public String getOrganId() {
		return organId;
	}

	public void setOrganId(String organId) {
		this.organId = organId;
	}

	public String getHardware() {
		return hardware;
	}

	public void setHardware(String hardware) {
		this.hardware = hardware;
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

	public String getUpgradeMode() {
		return upgradeMode;
	}

	public void setUpgradeMode(String upgradeMode) {
		this.upgradeMode = upgradeMode;
	}

	public String getDeviceOsVersion() {
		return deviceOsVersion;
	}

	public void setDeviceOsVersion(String deviceOsVersion) {
		this.deviceOsVersion = deviceOsVersion;
	}

	public String getDeviceStatus() {
		return deviceStatus;
	}

	public void setDeviceStatus(String deviceStatus) {
		this.deviceStatus = deviceStatus;
	}

	public String getOsStatus() {
		return osStatus;
	}

	public void setOsStatus(String osStatus) {
		this.osStatus = osStatus;
	}

	public String getOsUpgradeType() {
		return osUpgradeType;
	}

	public void setOsUpgradeType(String osUpgradeType) {
		this.osUpgradeType = osUpgradeType;
	}

	public String getSourceId() {
		return sourceId;
	}

	public void setSourceId(String sourceId) {
		this.sourceId = sourceId;
	}

	public Long getAppVersionNumber() {
		return appVersionNumber;
	}

	public void setAppVersionNumber(Long appVersionNumber) {
		this.appVersionNumber = appVersionNumber;
	}

}
