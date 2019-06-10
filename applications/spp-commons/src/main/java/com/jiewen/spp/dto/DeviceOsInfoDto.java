package com.jiewen.spp.dto;

import java.io.Serializable;

import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Transient;

import com.jiewen.utils.StringUtil;

public class DeviceOsInfoDto implements Serializable, Comparable<DeviceOsInfoDto> {

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
    private String osVersion;
    @Transient
    private String osPacketType;
    @Transient
    private String romPath;
    @Transient
    private String romHash;
    @Transient
    private String deviceStatus;
    @Transient
    private String osStatus;
    @Transient
    private String osUpgradeType;
    @Transient
    private String osMsg;
    @Transient
    private String deviceOsVersion;
    @Transient
    private String deviceType;
    @Transient
    private String deviceSn;
    @Transient
    private String osStart;
    @Transient
    private String osEnd;

    @Transient
    private String description;

    @Transient
    private String manufacturerNo;

    @Transient
    private String strategy;

    @Transient
    private String startHardShift;

    @Transient
    private String endHardShift;

    @Transient
    private String hardWare;

    @Transient
    private String clientIdentification;

    public String getDeviceSn() {
        return deviceSn;
    }

    public void setDeviceSn(String deviceSn) {
        this.deviceSn = deviceSn;
    }

    public String getOsVersion() {
        return osVersion;
    }

    public void setOsVersion(String osVersion) {
        this.osVersion = osVersion;
    }

    public String getOsPacketType() {
        return osPacketType;
    }

    public void setOsPacketType(String osPacketType) {
        this.osPacketType = osPacketType;
    }

    public String getRomPath() {
        return romPath;
    }

    public void setRomPath(String romPath) {
        this.romPath = romPath;
    }

    public String getRomHash() {
        return romHash;
    }

    public void setRomHash(String romHash) {
        this.romHash = romHash;
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

    public String getDeviceOsVersion() {
        return deviceOsVersion;
    }

    public void setDeviceOsVersion(String deviceOsVersion) {
        this.deviceOsVersion = deviceOsVersion;
    }

    public String getDeviceType() {
        return deviceType;
    }

    public void setDeviceType(String deviceType) {
        this.deviceType = deviceType;
    }

    @Override
    public int compareTo(DeviceOsInfoDto o) {
        return StringUtil.compareVersion(this.getOsVersion(), o.getOsVersion());
    }

    public String getManufacturerNo() {
        return manufacturerNo;
    }

    public void setManufacturerNo(String manufacturerNo) {
        this.manufacturerNo = manufacturerNo;
    }

    public String getOsStart() {
        return osStart;
    }

    public void setOsStart(String osStart) {
        this.osStart = osStart;
    }

    public String getOsEnd() {
        return osEnd;
    }

    public void setOsEnd(String osEnd) {
        this.osEnd = osEnd;
    }

    public String getStrategy() {
        return strategy;
    }

    public void setStrategy(String strategy) {
        this.strategy = strategy;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getClientIdentification() {
        return clientIdentification;
    }

    public void setClientIdentification(String clientIdentification) {
        this.clientIdentification = clientIdentification;
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

    public String getHardWare() {
        return hardWare;
    }

    public void setHardWare(String hardWare) {
        this.hardWare = hardWare;
    }

}
