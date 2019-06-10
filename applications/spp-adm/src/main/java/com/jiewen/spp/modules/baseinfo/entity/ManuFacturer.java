
package com.jiewen.spp.modules.baseinfo.entity;

import com.jiewen.base.core.entity.DataEntity;

public class ManuFacturer extends DataEntity<ManuFacturer> {

    private static final long serialVersionUID = 1L;

    private String manufacturerName;

    private String manufacturerNo;

    private String manufacturerAddr;

    public String getManufacturerName() {
        return manufacturerName;
    }

    public void setManufacturerName(String manufacturerName) {
        this.manufacturerName = manufacturerName;
    }

    public String getManufacturerNo() {
        return manufacturerNo;
    }

    public void setManufacturerNo(String manufacturerNo) {
        this.manufacturerNo = manufacturerNo;
    }

    public String getManufacturerAddr() {
        return manufacturerAddr;
    }

    public void setManufacturerAddr(String manufacturerAddr) {
        this.manufacturerAddr = manufacturerAddr;
    }

}
