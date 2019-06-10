package com.jiewen.modules.device.entity;

import java.util.Date;
import java.util.List;

import com.jiewen.jwp.base.entity.DataEntity;
import com.jiewen.modules.app.entity.AppDeviceType;
import com.jiewen.modules.baseinfo.entity.ClientEntity;
import com.jiewen.modules.entity.Store;

public class Device extends DataEntity {

	private static final long serialVersionUID = 1L;

	private String deviceSn;

	private String devicePn;
    
    /**
     * 商戶表id
     */
    private String mId;
    
    /**
     * 门店表id
     */
    private String sId;
    
	private String deviceType;

	private String deviceVersion;

	private String deviceOsVersion;

	private String tusn;
	
	private String deviceBundState;

	private String productTypeCode;

	private Object deviceInfo;

	private String deviceBank;

	private String manufacturerNo;

	private String manufacturerName;

	private String clientNo;

	private String deviceStatus;

	private String osStatus;

	private String osUpgradeType;

	private String osMsg;

	private String osVersionShifter;

	private String osVersion;

	private String organId;
	
	private String organName;

	private String hardwareVersion;

	private String versionCompareValue;

	private String startHard;

	private String endHard;

	private List<AppDeviceType> appDeviceTypeList;

	private Object appInfo;

	private String industry;

	private ClientEntity client;

	private String deviceSnStr;

	private String beginDateStr; // 开始日期
    
    private String hardwareShifter;

	private String endDateStr; // 结束日期

	private String deviceCount;
	
	private String appName;

	private String appVersion;

	private String upgradeType;

	private String upgradeDesc;

	private String currentAppVersion;

	private String appPackage;

	private String merId;

	private String shopId;

	private String merName;

	private String shopName;
	    
	private Date applyDate;
  
	private String installLocation;
  
	private Date installDate;
  
	private String deviceSort;
  
	private String macNo;
  
	private String scopeMode;
  
	private String labels;
	
	private Object Location;
	
	
	private List<Store>  listStore;
	
	public List<Store> getListStore() {
		return listStore;
	}

	public void setListStore(List<Store> listStore) {
		this.listStore = listStore;
	}

	private String locationString;

	public String getAppName() {
		return appName;
	}

	public void setAppName(String appName) {
		this.appName = appName;
	}

	public String getAppVersion() {
		return appVersion;
	}

	public void setAppVersion(String appVersion) {
		this.appVersion = appVersion;
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

	public String getCurrentAppVersion() {
		return currentAppVersion;
	}

	public void setCurrentAppVersion(String currentAppVersion) {
		this.currentAppVersion = currentAppVersion;
	}

	public String getAppPackage() {
		return appPackage;
	}

	public void setAppPackage(String appPackage) {
		this.appPackage = appPackage;
	}

	public String getMerId() {
		return merId;
	}

	public void setMerId(String merId) {
		this.merId = merId;
	}

	public String getShopId() {
		return shopId;
	}

	public void setShopId(String shopId) {
		this.shopId = shopId;
	}

	public String getMerName() {
		return merName;
	}

	public void setMerName(String merName) {
		this.merName = merName;
	}

	public String getShopName() {
		return shopName;
	}

	public void setShopName(String shopName) {
		this.shopName = shopName;
	}

	public Date getApplyDate() {
		return applyDate;
	}

	public void setApplyDate(Date applyDate) {
		this.applyDate = applyDate;
	}

	public String getInstallLocation() {
		return installLocation;
	}

	public void setInstallLocation(String installLocation) {
		this.installLocation = installLocation;
	}

	public Date getInstallDate() {
		return installDate;
	}

	public void setInstallDate(Date installDate) {
		this.installDate = installDate;
	}

	public String getDeviceSort() {
		return deviceSort;
	}

	public void setDeviceSort(String deviceSort) {
		this.deviceSort = deviceSort;
	}

	public String getMacNo() {
		return macNo;
	}

	public void setMacNo(String macNo) {
		this.macNo = macNo;
	}

	public String getScopeMode() {
		return scopeMode;
	}

	public void setScopeMode(String scopeMode) {
		this.scopeMode = scopeMode;
	}

	public String getLabels() {
		return labels;
	}

	public void setLabels(String labels) {
		this.labels = labels;
	}

	public String getOsVersionShifter() {
		return osVersionShifter;
	}

	public void setOsVersionShifter(String osVersionShifter) {
		this.osVersionShifter = osVersionShifter;
	}

	public String getVersionCompareValue() {
		return versionCompareValue;
	}

	public void setVersionCompareValue(String versionCompareValue) {
		this.versionCompareValue = versionCompareValue;
	}

	public String getHardwareVersion() {
		return hardwareVersion;
	}

	public void setHardwareVersion(String hardwareVersion) {
		this.hardwareVersion = hardwareVersion;
	}

	public Object getAppInfo() {
		return appInfo;
	}

	public void setAppInfo(Object appInfo) {
		this.appInfo = appInfo;
	}

	public String getDeviceSn() {
		return deviceSn;
	}

	public void setDeviceSn(String deviceSn) {
		this.deviceSn = deviceSn;
	}

	public String getDevicePn() {
		return devicePn;
	}

	public void setDevicePn(String devicePn) {
		this.devicePn = devicePn;
	}

	public String getDeviceType() {
		return deviceType;
	}

	public void setDeviceType(String deviceType) {
		this.deviceType = deviceType;
	}

	public String getDeviceVersion() {
		return deviceVersion;
	}

	public void setDeviceVersion(String deviceVersion) {
		this.deviceVersion = deviceVersion;
	}

	public String getDeviceOsVersion() {
		return deviceOsVersion;
	}

	public void setDeviceOsVersion(String deviceOsVersion) {
		this.deviceOsVersion = deviceOsVersion;
	}

	public String getTusn() {
		return tusn;
	}

	public void setTusn(String tusn) {
		this.tusn = tusn;
	}

	public String getProductTypeCode() {
		return productTypeCode;
	}

	public void setProductTypeCode(String productTypeCode) {
		this.productTypeCode = productTypeCode;
	}

	public Object getDeviceInfo() {
		return deviceInfo;
	}

	public void setDeviceInfo(Object deviceInfo) {
		this.deviceInfo = deviceInfo;
	}

	public String getDeviceBank() {
		return deviceBank;
	}

	public void setDeviceBank(String deviceBank) {
		this.deviceBank = deviceBank;
	}

	public String getManufacturerNo() {
		return manufacturerNo;
	}

	public void setManufacturerNo(String manufacturerNo) {
		this.manufacturerNo = manufacturerNo;
	}

	public String getManufacturerName() {
		return manufacturerName;
	}

	public void setManufacturerName(String manufacturerName) {
		this.manufacturerName = manufacturerName;
	}

	public String getClientNo() {
		return clientNo;
	}

	public void setClientNo(String clientNo) {
		this.clientNo = clientNo;
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

	public String getOsMsg() {
		return osMsg;
	}

	public void setOsMsg(String osMsg) {
		this.osMsg = osMsg;
	}

	public List<AppDeviceType> getAppDeviceTypeList() {
		return appDeviceTypeList;
	}

	public void setAppDeviceTypeList(List<AppDeviceType> appDeviceTypeList) {
		this.appDeviceTypeList = appDeviceTypeList;
	}

	public String getOrganId() {
		return organId;
	}

	public void setOrganId(String organId) {
		this.organId = organId;
	}

	public String getIndustry() {
		return industry;
	}

	public void setIndustry(String industry) {
		this.industry = industry;
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

	public ClientEntity getClient() {
		return client;
	}

	public void setClient(ClientEntity client) {
		this.client = client;
	}

	public String getOsVersion() {
		return osVersion;
	}

	public void setOsVersion(String osVersion) {
		this.osVersion = osVersion;
	}

	public String getDeviceSnStr() {
		return deviceSnStr;
	}

	public void setDeviceSnStr(String deviceSnStr) {
		this.deviceSnStr = deviceSnStr;
	}

	public String getBeginDateStr() {
		return beginDateStr;
	}

	public void setBeginDateStr(String beginDateStr) {
		this.beginDateStr = beginDateStr;
	}

	public String getEndDateStr() {
		return endDateStr;
	}

	public void setEndDateStr(String endDateStr) {
		this.endDateStr = endDateStr;
	}

	public String getDeviceCount() {
		return deviceCount;
	}

	public void setDeviceCount(String deviceCount) {
		this.deviceCount = deviceCount;
	}

	public String getmId() {
		return mId;
	}

	public void setmId(String mId) {
		this.mId = mId;
	}


	public String getHardwareShifter() {
		return hardwareShifter;
	}

	public void setHardwareShifter(String hardwareShifter) {
		this.hardwareShifter = hardwareShifter;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getDeviceBundState() {
		return deviceBundState;
	}

	public void setDeviceBundState(String deviceBundState) {
		this.deviceBundState = deviceBundState;
	}

	public String getOrganName() {
		return organName;
	}

	public void setOrganName(String organName) {
		this.organName = organName;
	}

	public String getsId() {
		return sId;
	}

	public void setsId(String sId) {
		this.sId = sId;
	}

	public Object getLocation() {
		return Location;
	}

	public void setLocation(Object location) {
		Location = location;
	}

	public String getLocationString() {
		return locationString;
	}

	public void setLocationString(String locationString) {
		this.locationString = locationString;
	}

}
