package com.jiewen.modules.baseinfo.entity;

import com.jiewen.jwp.base.entity.DataEntity;

public class ClientEntity extends DataEntity {

    private static final long serialVersionUID = 1L;

    private String customerId;

    private String parentId;

    private String customerName;

    private String customerClass;

    private String level;

    private String customerCredits;

    private String accountPeriod;

    private String remark;

    private String customerIdPath;

    private String province;

    private String city;

    private String industry;

    /*
     * private String authUserId; private String authOrGId; private String reateDate; private String
     * MODIFY_DATE; private String MODIFY_TIME; private String MODIFY_USER_ID; private String
     * CREATE_TIME;
     * 
     */
    public String getCustomerId() {
        return customerId;
    }

    public void setCustomerId(String customerId) {
        this.customerId = customerId;
    }

    public String getParentId() {
        return parentId;
    }

    public void setParentId(String parentId) {
        this.parentId = parentId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerClass() {
        return customerClass;
    }

    public void setCustomerClass(String customerClass) {
        this.customerClass = customerClass;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public String getCustomerCredits() {
        return customerCredits;
    }

    public void setCustomerCredits(String customerCredits) {
        this.customerCredits = customerCredits;
    }

    public String getAccountPeriod() {
        return accountPeriod;
    }

    public void setAccountPeriod(String accountPeriod) {
        this.accountPeriod = accountPeriod;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getCustomerIdPath() {
        return customerIdPath;
    }

    public void setCustomerIdPath(String customerIdPath) {
        this.customerIdPath = customerIdPath;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getIndustry() {
        return industry;
    }

    public void setIndustry(String industry) {
        this.industry = industry;
    }

    @Override
    public String toString() {
        return "ClientEntity [customerId=" + customerId + ", parentId=" + parentId
                + ", customerName=" + customerName + ", customerClass=" + customerClass + ", level="
                + level + ", customerCredits=" + customerCredits + ", accountPeriod="
                + accountPeriod + ", remark=" + remark + ", customerIdPath=" + customerIdPath
                + ", province=" + province + ", city=" + city + ", industry=" + industry + "]";
    }

}
