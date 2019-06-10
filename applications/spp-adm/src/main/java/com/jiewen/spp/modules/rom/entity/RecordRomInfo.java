
package com.jiewen.spp.modules.rom.entity;

import java.util.Date;

import com.jiewen.base.core.entity.DataEntity;

public class RecordRomInfo extends DataEntity<RecordRomInfo> {

    private static final long serialVersionUID = 1L;

    private Integer osId;

    private String osVersion;

    private String osVersionShifter;

    private String osDeviceType;

    private String manufacturerNo;

    private String createPerson;

    private Integer deviceCount;

    private Date beginDate;

    private Date endDate;

    public Integer getOsId() {
        return osId;
    }

    public void setOsId(Integer osId) {
        this.osId = osId;
    }

    public String getOsVersion() {
        return osVersion;
    }

    public void setOsVersion(String osVersion) {
        this.osVersion = osVersion;
    }

    public String getOsDeviceType() {
        return osDeviceType;
    }

    public void setOsDeviceType(String osDeviceType) {
        this.osDeviceType = osDeviceType;
    }

    public String getManufacturerNo() {
        return manufacturerNo;
    }

    public void setManufacturerNo(String manufacturerNo) {
        this.manufacturerNo = manufacturerNo;
    }

    public String getCreatePerson() {
        return createPerson;
    }

    public void setCreatePerson(String createPerson) {
        this.createPerson = createPerson;
    }

    public Integer getDeviceCount() {
        return deviceCount;
    }

    public void setDeviceCount(Integer deviceCount) {
        this.deviceCount = deviceCount;
    }

    public Date getBeginDate() {
        return beginDate;
    }

    public void setBeginDate(Date beginDate) {
        this.beginDate = beginDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getOsVersionShifter() {
        return osVersionShifter;
    }

    public void setOsVersionShifter(String osVersionShifter) {
        this.osVersionShifter = osVersionShifter;
    }

}
