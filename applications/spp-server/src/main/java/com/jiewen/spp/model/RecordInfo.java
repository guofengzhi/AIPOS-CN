package com.jiewen.spp.model;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

@Table(name = "t_record_info")
public class RecordInfo {
	/**
	 * 记录ID
	 */
	@Id
	private String id;

	/**
	 * 上一级记录ID
	 */
	@Column(name = "parent_id")
	private String parentId;

	/**
	 * 状态
	 */
	@Column(name = "status")
	private String status;

	/**
	 * 本级包内信息
	 */
	@Column(name = "package_info")
	private String packageInfo;

	/**
	 * 记录时间
	 */
	@Column(name = "record_datetime")
	private String recordDateTime;

	/**
	 * 本级包路径
	 */
	@Column(name = "package_path")
	private String packagePath;

	/**
	 * 包名称
	 */
	@Column(name = "package_name")
	private String packageName;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getParentId() {
		return parentId;
	}

	public void setParentId(String parentId) {
		this.parentId = parentId;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getPackageInfo() {
		return packageInfo;
	}

	public void setPackageInfo(String packageInfo) {
		this.packageInfo = packageInfo;
	}

	public String getRecordDateTime() {
		return recordDateTime;
	}

	public void setRecordDateTime(String recordDateTime) {
		this.recordDateTime = recordDateTime;
	}

	public String getPackagePath() {
		return packagePath;
	}

	public void setPackagePath(String packagePath) {
		this.packagePath = packagePath;
	}

	public String getPackageName() {
		return packageName;
	}

	public void setPackageName(String packageName) {
		this.packageName = packageName;
	}

}