package com.jiewen.spp.modules.advertisement.entity;

import java.util.Date;

import com.jiewen.base.core.entity.DataEntity;

/**
 * 广告Entity
 */

public class Advertisement extends DataEntity<Advertisement> {

	private static final long serialVersionUID = 1L;

	private String adId;

	private String organId;

	private String merId;

	private String adName;

	private String adTitle;

	private String adDesc;

	private String adType;

	private String adManufacturers;

	private String adStatus;

	private String adPlatform;

	private Date adStartTime;

	private Date adEndTime;

	private String releaseId;

	private String releaseUser;

	private Date releaseTime;

	private String approvalStatus;

	private String approvalUser;

	private String approvalOpinion;

	private Date approvalTime;

	private String creator;

	private Date createTime;

	private String updator;

	private Date updateTime;

	private String delFlag;

	private String adContent;

	private String adImg;

	private String merName;

	private String oldAdName;

	private String startTime;

	private String endTime;

	private String adImg1;

	private Date adStartTime1;

	private Date adEndTime1;

	private String adTypeName;

	private String adLinks;

	private String adAttribution;

	public String getAdLinks() {
		return adLinks;
	}

	public void setAdLinks(String adLinks) {
		this.adLinks = adLinks;
	}

	public String getAdAttribution() {
		return adAttribution;
	}

	public void setAdAttribution(String adAttribution) {
		this.adAttribution = adAttribution;
	}

	public String getAdTypeName() {
		return adTypeName;
	}

	public void setAdTypeName(String adTypeName) {
		this.adTypeName = adTypeName;
	}

	public Date getAdStartTime1() {
		return adStartTime1;
	}

	public void setAdStartTime1(Date adStartTime1) {
		this.adStartTime1 = adStartTime1;
	}

	public Date getAdEndTime1() {
		return adEndTime1;
	}

	public void setAdEndTime1(Date adEndTime1) {
		this.adEndTime1 = adEndTime1;
	}

	public String getAdImg1() {
		return adImg1;
	}

	public void setAdImg1(String adImg1) {
		this.adImg1 = adImg1;
	}

	public String getStartTime() {
		return startTime;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	public String getAdContent() {
		return adContent;
	}

	public void setAdContent(String adContent) {
		this.adContent = adContent;
	}

	public String getAdImg() {
		return adImg;
	}

	public void setAdImg(String adImg) {
		this.adImg = adImg;
	}

	public String getMerName() {
		return merName;
	}

	public void setMerName(String merName) {
		this.merName = merName;
	}

	public String getOldAdName() {
		return oldAdName;
	}

	public void setOldAdName(String oldAdName) {
		this.oldAdName = oldAdName;
	}

	public String getAdId() {
		return adId;
	}

	public void setAdId(String adId) {
		this.adId = adId;
	}

	public String getOrganId() {
		return organId;
	}

	public void setOrganId(String organId) {
		this.organId = organId;
	}

	public String getMerId() {
		return merId;
	}

	public void setMerId(String merId) {
		this.merId = merId;
	}

	public String getAdName() {
		return adName;
	}

	public void setAdName(String adName) {
		this.adName = adName;
	}

	public String getAdTitle() {
		return adTitle;
	}

	public void setAdTitle(String adTitle) {
		this.adTitle = adTitle;
	}

	public String getAdDesc() {
		return adDesc;
	}

	public void setAdDesc(String adDesc) {
		this.adDesc = adDesc;
	}

	public String getAdType() {
		return adType;
	}

	public void setAdType(String adType) {
		this.adType = adType;
	}

	public String getAdManufacturers() {
		return adManufacturers;
	}

	public void setAdManufacturers(String adManufacturers) {
		this.adManufacturers = adManufacturers;
	}

	public String getAdStatus() {
		return adStatus;
	}

	public void setAdStatus(String adStatus) {
		this.adStatus = adStatus;
	}

	public String getAdPlatform() {
		return adPlatform;
	}

	public void setAdPlatform(String adPlatform) {
		this.adPlatform = adPlatform;
	}

	public Date getAdStartTime() {
		return adStartTime;
	}

	public void setAdStartTime(Date adStartTime) {
		this.adStartTime = adStartTime;
	}

	public Date getAdEndTime() {
		return adEndTime;
	}

	public void setAdEndTime(Date adEndTime) {
		this.adEndTime = adEndTime;
	}

	public String getReleaseId() {
		return releaseId;
	}

	public void setReleaseId(String releaseId) {
		this.releaseId = releaseId;
	}

	public String getReleaseUser() {
		return releaseUser;
	}

	public void setReleaseUser(String releaseUser) {
		this.releaseUser = releaseUser;
	}

	public Date getReleaseTime() {
		return releaseTime;
	}

	public void setReleaseTime(Date releaseTime) {
		this.releaseTime = releaseTime;
	}

	public String getApprovalStatus() {
		return approvalStatus;
	}

	public void setApprovalStatus(String approvalStatus) {
		this.approvalStatus = approvalStatus;
	}

	public String getApprovalUser() {
		return approvalUser;
	}

	public void setApprovalUser(String approvalUser) {
		this.approvalUser = approvalUser;
	}

	public String getApprovalOpinion() {
		return approvalOpinion;
	}

	public void setApprovalOpinion(String approvalOpinion) {
		this.approvalOpinion = approvalOpinion;
	}

	public Date getApprovalTime() {
		return approvalTime;
	}

	public void setApprovalTime(Date approvalTime) {
		this.approvalTime = approvalTime;
	}

	public String getCreator() {
		return creator;
	}

	public void setCreator(String creator) {
		this.creator = creator;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public String getUpdator() {
		return updator;
	}

	public void setUpdator(String updator) {
		this.updator = updator;
	}

	public Date getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}

	public String getDelFlag() {
		return delFlag;
	}

	public void setDelFlag(String delFlag) {
		this.delFlag = delFlag;
	}
}