
package com.jiewen.spp.modules.app.entity;

import com.jiewen.base.core.entity.DataEntity;

public class AppDeviceType extends DataEntity<AppDeviceType> {

    private static final long serialVersionUID = 1L;

    private Long apkId;

    private String manuNo;
    
    private String manufacturerName;

    private String deviceType;

    public Long getApkId() {
        return apkId;
    }

    public void setApkId(Long apkId) {
        this.apkId = apkId;
    }

    public String getManuNo() {
        return manuNo;
    }

    public void setManuNo(String manuNo) {
        this.manuNo = manuNo;
    }

    public String getDeviceType() {
        return deviceType;
    }

    public void setDeviceType(String deviceType) {
        this.deviceType = deviceType;
    }

	public String getManufacturerName() {
		return manufacturerName;
	}

	public void setManufacturerName(String manufacturerName) {
		this.manufacturerName = manufacturerName;
	}

}
