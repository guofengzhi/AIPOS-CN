package com.jiewen.spp.model;

import javax.persistence.Id;

public class Merchant {

    private static final long serialVersionUID = 1L;
    
	@Id
    private String id;
    
    private String longitude;
    
    private String latitude;
    
    private long radius;

    private String merId;
    
    private String merName;
    
    private String orgId;
    
    private String orgName;
    
    private String linkMan;
    
    private String linkPhone;
    
    private String address;
    
    private long countTerm;
    
    private String reverse1;
    
    private String reverse2;
    
    private String reverse3;
    
    private String reverse4;
    
    private String reverse5;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getLongitude() {
		return longitude;
	}

	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}

	public String getLatitude() {
		return latitude;
	}

	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}

	public long getRadius() {
		return radius;
	}

	public void setRadius(long radius) {
		this.radius = radius;
	}

	public String getMerId() {
		return merId;
	}

	public void setMerId(String merId) {
		this.merId = merId;
	}

	public String getMerName() {
		return merName;
	}

	public void setMerName(String merName) {
		this.merName = merName;
	}

	public String getOrgId() {
		return orgId;
	}

	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}

	public String getOrgName() {
		return orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}

	public String getLinkMan() {
		return linkMan;
	}

	public void setLinkMan(String linkMan) {
		this.linkMan = linkMan;
	}

	public String getLinkPhone() {
		return linkPhone;
	}

	public void setLinkPhone(String linkPhone) {
		this.linkPhone = linkPhone;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public long getCountTerm() {
		return countTerm;
	}

	public void setCountTerm(long countTerm) {
		this.countTerm = countTerm;
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
}
