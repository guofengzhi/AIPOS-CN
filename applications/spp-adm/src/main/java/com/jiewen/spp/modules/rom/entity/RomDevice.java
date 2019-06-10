
package com.jiewen.spp.modules.rom.entity;

import com.jiewen.base.core.entity.DataEntity;

public class RomDevice extends DataEntity<RomDevice> {

    private static final long serialVersionUID = 1L;

    private Integer osId;

    private Integer deviceId;

    private Integer recordRomId;

    private String deviceVersion;

    private String osVersionShifter;

    private String upgradeType;

    private String strategyDesc;

    public Integer getOsId() {
        return osId;
    }

    public void setOsId(Integer osId) {
        this.osId = osId;
    }

    public Integer getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(Integer deviceId) {
        this.deviceId = deviceId;
    }

    public Integer getRecordRomId() {
        return recordRomId;
    }

    public void setRecordRomId(Integer recordRomId) {
        this.recordRomId = recordRomId;
    }

    public String getUpgradeType() {
        return upgradeType;
    }

    public void setUpgradeType(String upgradeType) {
        this.upgradeType = upgradeType;
    }

    public String getStrategyDesc() {
        return strategyDesc;
    }

    public void setStrategyDesc(String strategyDesc) {
        this.strategyDesc = strategyDesc;
    }

    @Override
    public String toString() {
        return "RomDevice [osId=" + osId + ", deviceId=" + deviceId + ", upgradeType=" + upgradeType
                + ", strategyDesc=" + strategyDesc + "]";
    }

    public String getDeviceVersion() {
        return deviceVersion;
    }

    public void setDeviceVersion(String deviceVersion) {
        this.deviceVersion = deviceVersion;
    }

    public String getOsVersionShifter() {
        return osVersionShifter;
    }

    public void setOsVersionShifter(String osVersionShifter) {
        this.osVersionShifter = osVersionShifter;
    }
}
