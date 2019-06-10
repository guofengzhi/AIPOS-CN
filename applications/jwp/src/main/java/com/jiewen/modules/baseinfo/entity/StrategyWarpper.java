package com.jiewen.modules.baseinfo.entity;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnore;

public class StrategyWarpper {

    @JsonIgnore
    private String id;

    @JsonIgnore
    private String strategyName;

    private String upgradeType;

    @JsonIgnore
    protected Date beginDate;

    @JsonIgnore
    protected Date endDate;

    @JsonIgnore
    private String strategyDesc;

    public String getStrategyName() {
        return strategyName;
    }

    public void setStrategyName(String strategyName) {
        this.strategyName = strategyName;
    }

    public String getUpgradeType() {
        return upgradeType;
    }

    public void setUpgradeType(String upgradeType) {
        this.upgradeType = upgradeType;
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

    public String getStrategyDesc() {
        return strategyDesc;
    }

    public void setStrategyDesc(String strategyDesc) {
        this.strategyDesc = strategyDesc;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    @Override
    public String toString() {
        return "StrategyWarpper [strategyName=" + strategyName + ", upgradeType=" + upgradeType
                + ", beginDate=" + beginDate + ", endDate=" + endDate + ", strategyDesc="
                + strategyDesc + "]";
    }
}
