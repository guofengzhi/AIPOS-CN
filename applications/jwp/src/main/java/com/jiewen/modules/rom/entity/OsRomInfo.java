package com.jiewen.modules.rom.entity;

import com.jiewen.jwp.base.entity.DataEntity;

public class OsRomInfo extends DataEntity {

    private static final long serialVersionUID = 1L;

    private String osVersion;

    private String osDeviceType;

    private String romHash;

    private String romPath;

    private Long romFileSize;

    private String osStart;

    private String osEnd;

    private String manufacturerNo;

    private String osPacketType;

    private String description;

    private String md5FileValue;

    private String clientIdentification;

    private String startHard;

    private String endHard;

    private String startHardShift;

    private String endHardShift;

    public String getOsVersion() {
        return osVersion;
    }

    public String getOsDeviceType() {
        return osDeviceType;
    }

    public void setOsDeviceType(String osDeviceType) {
        this.osDeviceType = osDeviceType;
    }

    public void setOsVersion(String osVersion) {
        this.osVersion = osVersion;
    }

    public String getRomHash() {
        return romHash;
    }

    public void setRomHash(String romHash) {
        this.romHash = romHash;
    }

    public String getRomPath() {
        return romPath;
    }

    public void setRomPath(String romPath) {
        this.romPath = romPath;
    }

    public Long getRomFileSize() {
        return romFileSize;
    }

    public void setRomFileSize(Long romFileSize) {
        this.romFileSize = romFileSize;
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

    public String getManufacturerNo() {
        return manufacturerNo;
    }

    public void setManufacturerNo(String manufacturerNo) {
        this.manufacturerNo = manufacturerNo;
    }

    public String getOsPacketType() {
        return osPacketType;
    }

    public void setOsPacketType(String osPacketType) {
        this.osPacketType = osPacketType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getMd5FileValue() {
        return md5FileValue;
    }

    public void setMd5FileValue(String md5FileValue) {
        this.md5FileValue = md5FileValue;
    }

    public String getClientIdentification() {
        return clientIdentification;
    }

    public void setClientIdentification(String clientIdentification) {
        this.clientIdentification = clientIdentification;
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

}
