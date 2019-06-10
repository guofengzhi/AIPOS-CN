package com.jiewen.modules.device.entity;

import com.jiewen.jwp.base.entity.DataEntity;

public class Product extends DataEntity {

    private static final long serialVersionUID = 1L;

    private String sn;

    private String pn;

    private String customerId;

    private String productId;

    private String version;

    private String vendorCode;

    private String productTypeCode;

    private String unionPayTermId;

    private String status;

    public String getSn() {
        return sn;
    }

    public void setSn(String sn) {
        this.sn = sn;
    }

    public String getPn() {
        return pn;
    }

    public void setPn(String pn) {
        this.pn = pn;
    }

    public String getCustomerId() {
        return customerId;
    }

    public void setCustomerId(String customerId) {
        this.customerId = customerId;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public String getVendorCode() {
        return vendorCode;
    }

    public void setVendorCode(String vendorCode) {
        this.vendorCode = vendorCode;
    }

    public String getProductTypeCode() {
        return productTypeCode;
    }

    public void setProductTypeCode(String productTypeCode) {
        this.productTypeCode = productTypeCode;
    }

    public String getUnionPayTermId() {
        return unionPayTermId;
    }

    public void setUnionPayTermId(String unionPayTermId) {
        this.unionPayTermId = unionPayTermId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

}
