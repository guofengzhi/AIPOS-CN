
package com.jiewen.base.sys.entity;


import com.jiewen.base.core.entity.DataEntity;

public class DeviceMerchant extends DataEntity<DeviceMerchant> {
	
	private static final long serialVersionUID = 1L;

	private String merId;
	
	private String deviceSn;
	
	private String storeId;
	
	private String storeName;

	private String orgId;
	
	private String merName;
	
	private String boundState;
	
	private String operator;
	
	private String reverse1;
	
	private String reverse2;
	
	private String reverse3;
	
	private String reverse4;
	
	private String reverse5;

	public String getMerId() {
		return merId;
	}

	public void setMerId(String merId) {
		this.merId = merId;
	}

	public String getDeviceSn() {
		return deviceSn;
	}

	public void setDeviceSn(String deviceSn) {
		this.deviceSn = deviceSn;
	}

	public String getReverse1() {
		return reverse1;
	}

	public void setReverse1(String reverse1) {
		this.reverse1 = reverse1;
	}

	public String getReverse2() {
		return reverse2;
	}

	public void setReverse2(String reverse2) {
		this.reverse2 = reverse2;
	}

	public String getReverse3() {
		return reverse3;
	}

	public void setReverse3(String reverse3) {
		this.reverse3 = reverse3;
	}

	public String getReverse4() {
		return reverse4;
	}

	public void setReverse4(String reverse4) {
		this.reverse4 = reverse4;
	}

	public String getReverse5() {
		return reverse5;
	}

	public void setReverse5(String reverse5) {
		this.reverse5 = reverse5;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getOrgId() {
		return orgId;
	}

	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}

	public String getMerName() {
		return merName;
	}

	public void setMerName(String merName) {
		this.merName = merName;
	}

	public String getBoundState() {
		return boundState;
	}

	public void setBoundState(String boundState) {
		this.boundState = boundState;
	}

	public String getOperator() {
		return operator;
	}

	public void setOperator(String operator) {
		this.operator = operator;
	}

	public String getStoreId() {
		return storeId;
	}

	public void setStoreId(String storeId) {
		this.storeId = storeId;
	}

	public String getStoreName() {
		return storeName;
	}

	public void setStoreName(String storeName) {
		this.storeName = storeName;
	}

}
