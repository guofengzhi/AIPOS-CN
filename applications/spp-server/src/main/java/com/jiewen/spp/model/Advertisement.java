package com.jiewen.spp.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

@Table(name = "t_advertisement")
public class Advertisement {

	/**
	 * ID
	 */
	@Id
	private String adId;

	/**
	 * 广告名称
	 */
	@Column(name = "ad_name")
	private String adName;

	/**
	 * 广告标题
	 */
	@Column(name = "ad_title")
	private String adTitle;

	/**
	 * 广告描述
	 */
	@Column(name = "ad_desc")
	private String adDesc;

	/**
	 * 广告类型
	 */
	@Column(name = "ad_type")
	private String adType;

	/**
	 * 广告内容
	 */
	@Column(name = "ad_content")
	private String adContent;

	/**
	 * 广告图片
	 */
	@Column(name = "ad_img")
	private String adImg;

	/**
	 * 广告内容
	 */
	@Column(name = "ad_manufacturers")
	private String adManufacturers;

	/**
	 * 广告开始时间
	 */
	@Column(name = "ad_start_time")
	private Date adStartTime;

	/**
	 * 广告结束时间
	 */
	@Column(name = "ad_end_time")
	private Date adEndTime;

	/**
	 * 机构号
	 */
	@Column(name = "organ_id")
	private String organId;

	private int startPageNum;

	private int pageSize;

	private String dbName;

	private String ids;

	public String getIds() {
		return ids;
	}

	public void setIds(String ids) {
		this.ids = ids;
	}

	public String getDbName() {
		return dbName;
	}

	public void setDbName(String dbName) {
		this.dbName = dbName;
	}

	public int getStartPageNum() {
		return startPageNum;
	}

	public void setStartPageNum(int startPageNum) {
		this.startPageNum = startPageNum;
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public String getOrganId() {
		return organId;
	}

	public void setOrganId(String organId) {
		this.organId = organId;
	}

	public String getAdId() {
		return adId;
	}

	public void setAdId(String adId) {
		this.adId = adId;
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

	public String getAdManufacturers() {
		return adManufacturers;
	}

	public void setAdManufacturers(String adManufacturers) {
		this.adManufacturers = adManufacturers;
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

}