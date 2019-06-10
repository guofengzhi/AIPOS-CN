package com.jiewen.spp.wrapper;

import org.apache.commons.lang3.StringUtils;

import com.alibaba.fastjson.JSON;

public class OsParamsWrapper {

    // 接口版本
    private String version;

    // 设备类型
    private String deviceType;

    // 设备序列号
    private String sn;

    // 系统版本号
    private String osVersion;

    // 厂商编号
    private String manufacturer;

    private DeviceInfoWrapper deviceInfo;

    private String bankName;

    private String hardware;

    private String packet;

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

    public String getOsVersion() {
        return osVersion;
    }

    public void setOsVersion(String osVersion) {
        this.osVersion = osVersion;
    }

    public DeviceInfoWrapper getDeviceInfo() {
        return deviceInfo;
    }

    public void setDeviceInfo(DeviceInfoWrapper deviceInfo) {
        this.deviceInfo = deviceInfo;
    }

    public String getManufacturer() {
        return manufacturer;
    }

    public void setManufacturer(String manufacturer) {
        this.manufacturer = manufacturer;
    }

    @Override
    public String toString() {
        return JSON.toJSONString(this);
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
        String newHarWare=hardware;
        if (StringUtils.endsWithIgnoreCase(hardware, ".")) {
            newHarWare = StringUtils.appendIfMissingIgnoreCase(hardware, "3");
        }
        this.hardware = newHarWare;
    }

    public String getPacket() {
        return packet;
    }

    public void setPacket(String packet) {
        this.packet = packet;
    }

}
