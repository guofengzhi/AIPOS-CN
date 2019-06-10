package com.jiewen.spp.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Table(name = "t_device_info")
public class DeviceInfo {

	/**
	 * ID
	 */
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;

	@Column(name = "device_sn")
	private String deviceSn;

	@Column(name = "device_pn")
	private String devicePn;

	@Column(name = "device_type")
	private String deviceType;

	@Column(name = "device_os_version")
	private String deviceOsVersion;

	@Column(name = "os_version_shifter")
	private String osVersionShifter;

	@Column(name = "device_version")
	private String deviceVersion;

	@Column(name = "tusn")
	private String tusn;

	@Column(name = "product_type_code")
	private String productTypeCode;

	@Column(name = "device_info")
	private String deviceInfo;

	@Column(name = "device_bank")
	private String deviceBank;

	@Column(name = "client_no")
	private String clientNo;

	@Column(name = "manufacturer_no")
	private String manufacturerNo;

	@Column(name = "organ_id")
	private String organId;

	@Column(name = "hardware_version")
	private String hardwareVersion;

	@Column(name = "hardware_shifter")
	private String hardwareShifter;

	@Column(name = "device_status")
	private String deviceStatus;

	@Column(name = "os_status")
	private String osStatus;

	@Column(name = "os_upgrade_type")
	private String osUpgradeType;

	@Column(name = "os_msg")
	private String osMsg;

	@Column(name = "app_info")
	private String appInfo;

	@Column(name = "create_by")
	private String createBy;

	@Column(name = "create_date")
	private Date createDate;

	@Column(name = "update_by")
	private String updateBy;

	@Column(name = "update_date")
	private Date updateDate;

	@Column(name = "remarks")
	private String remarks;

	@Column(name = "del_flag")
	private String delFlag;

	@Column(name = "mer_id")
	private String merId;

	@Column(name = "shop_id")
	private String shopId;

	@Column(name = "device_bund_state")
	private String deviceBundState;

	@Column(name = "apply_date")
	private Date applyDate;

	@Column(name = "install_location")
	private String installLocation;

	@Column(name = "install_date")
	private Date installDate;

	@Column(name = "device_sort")
	private String deviceSort;

	@Column(name = "mac_no")
	private String macNo;

	@Column(name = "scope_mode")
	private String scopeMode;

	@Column(name = "labels")
	private String labels;

	@Column(name = "location")
	private String location;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
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

	public String getDeviceOsVersion() {
		return deviceOsVersion;
	}

	public void setDeviceOsVersion(String deviceOsVersion) {
		this.deviceOsVersion = deviceOsVersion;
	}

	public String getOsVersionShifter() {
		return osVersionShifter;
	}

	public void setOsVersionShifter(String osVersionShifter) {
		this.osVersionShifter = osVersionShifter;
	}

	public String getDeviceVersion() {
		return deviceVersion;
	}

	public void setDeviceVersion(String deviceVersion) {
		this.deviceVersion = deviceVersion;
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

	public String getDeviceInfo() {
		return deviceInfo;
	}

	public void setDeviceInfo(String deviceInfo) {
		this.deviceInfo = deviceInfo;
	}

	public String getDeviceBank() {
		return deviceBank;
	}

	public void setDeviceBank(String deviceBank) {
		this.deviceBank = deviceBank;
	}

	public String getClientNo() {
		return clientNo;
	}

	public void setClientNo(String clientNo) {
		this.clientNo = clientNo;
	}

	public String getManufacturerNo() {
		return manufacturerNo;
	}

	public void setManufacturerNo(String manufacturerNo) {
		this.manufacturerNo = manufacturerNo;
	}

	public String getOrganId() {
		return organId;
	}

	public void setOrganId(String organId) {
		this.organId = organId;
	}

	public String getHardwareVersion() {
		return hardwareVersion;
	}

	public void setHardwareVersion(String hardwareVersion) {
		this.hardwareVersion = hardwareVersion;
	}

	public String getHardwareShifter() {
		return hardwareShifter;
	}

	public void setHardwareShifter(String hardwareShifter) {
		this.hardwareShifter = hardwareShifter;
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

	public String getAppInfo() {
		return appInfo;
	}

	public void setAppInfo(String appInfo) {
		this.appInfo = appInfo;
	}

	public String getCreateBy() {
		return createBy;
	}

	public void setCreateBy(String createBy) {
		this.createBy = createBy;
	}

	public Date getCreateDate() {
		return createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	public String getUpdateBy() {
		return updateBy;
	}

	public void setUpdateBy(String updateBy) {
		this.updateBy = updateBy;
	}

	public Date getUpdateDate() {
		return updateDate;
	}

	public void setUpdateDate(Date updateDate) {
		this.updateDate = updateDate;
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

	public String getDeviceBundState() {
		return deviceBundState;
	}

	public void setDeviceBundState(String deviceBundState) {
		this.deviceBundState = deviceBundState;
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

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

}