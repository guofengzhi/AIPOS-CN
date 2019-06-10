package com.jiewen.modules.baseinfo.entity;

import javax.persistence.Transient;

import com.jiewen.jwp.base.entity.DataEntity;

public class DeviceType extends DataEntity {

    private static final long serialVersionUID = 1L;

    private String manufacturerNo;

    private String deviceType;

    @Transient
    private String checked;

    @Transient
    private String apkId;

    public String getManufacturerNo() {
        return manufacturerNo;
    }

    public void setManufacturerNo(String manufacturerNo) {
        this.manufacturerNo = manufacturerNo;
    }

    public String getDeviceType() {
        return deviceType;
    }

    public void setDeviceType(String deviceType) {
        this.deviceType = deviceType;
    }

    public String getChecked() {
        return checked;
    }

    public void setChecked(String checked) {
        this.checked = checked;
    }

    public String getApkId() {
        return apkId;
    }

    public void setApkId(String apkId) {
        this.apkId = apkId;
    }
}
