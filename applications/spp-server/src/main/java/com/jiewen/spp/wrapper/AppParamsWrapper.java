package com.jiewen.spp.wrapper;

import org.apache.commons.lang3.StringUtils;

public class AppParamsWrapper {

    // 接口版本
    private String version;

    // 设备类型
    private String deviceType;

    // 设备序列号
    private String sn;

    // app版本号
    private String appVersion;

    // 厂商编号
    private String manufacturer;

    // 应用包路径 如 com.canpay.test等
    private String appPackage;

    private String bankName;

    private String hardware;

    /**
     * 系统来源Id
     */
    private String sourceId;

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public String getDeviceType() {
        return deviceType;
    }

    public void setDeviceType(String deviceType) {
        this.deviceType = deviceType;
    }

    public String getSn() {
        return sn;
    }

    public void setSn(String sn) {
        this.sn = sn;
    }

    public String getAppVersion() {
        return appVersion;
    }

    public void setAppVersion(String appVersion) {
        this.appVersion = appVersion;
    }

    public String getManufacturer() {
        return manufacturer;
    }

    public void setManufacturer(String manufacturer) {
        this.manufacturer = manufacturer;
    }

    public String getAppPackage() {
        return appPackage;
    }

    public void setAppPackage(String appPackage) {
        this.appPackage = appPackage;
    }

    public String getBankName() {
        return bankName;
    }

    public void setBankName(String bankName) {
        this.bankName = bankName;
    }

    public String getHardware() {
        return hardware;
    }

    public void setHardware(String hardware) {
        String newHarWare = hardware;
        if (StringUtils.endsWithIgnoreCase(hardware, ".")) {
            newHarWare = StringUtils.appendIfMissingIgnoreCase(hardware, "3");
        }
        this.hardware = newHarWare;
    }

    public String getSourceId() {
        return sourceId;
    }

    public void setSourceId(String sourceId) {
        this.sourceId = sourceId;
    }

    @Override
    public String toString() {
        return "AppParamsWrapper [version=" + version + ", deviceType=" + deviceType + ", sn=" + sn
                + ", appVersion=" + appVersion + ", manufacturer=" + manufacturer + ", appPackage="
                + appPackage + ", bankName=" + bankName + ", hardware=" + hardware + "]";
    }

}
