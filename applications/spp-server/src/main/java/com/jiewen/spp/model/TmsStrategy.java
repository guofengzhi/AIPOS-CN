package com.jiewen.spp.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * 更新策略
 * @author guofengzhi
 */
@Table(name = "t_tms_strategy")
public class TmsStrategy {

	/**
	 * ID
	 */
	@Id
	private String id;

	/**
	 * 策略名称
	 */
	@Column(name = "strategy_name")
	private String strategyName;
	
	/**
	 * 策略开始时间
	 */
	@Column(name = "begin_date")
	private Date beginDate;
	
	/**
	 * 策略结束时间
	 */
	@Column(name = "end_date")
	private Date endDate;
	
	/**
	 * 升级次数
	 */
	@Column(name = "update_time")
	private String updateTime;
	
	/**
	 * 机型
	 */
	@Column(name = "device_type")
	private String deviceType;
	
	/**
	 * 终端号
	 */
	@Column(name = "device_sn_str")
	private String deviceSnStr;
	
	/**
	 * 厂商
	 */
	@Column(name = "manufacturer_no")
	private String manufacturerNo;
	
	/**
	 * 文件ID
	 */
	@Column(name = "file_id")
	private String fileId;
	
	/**
	 * 厂商编号
	 */
	@Column(name = "mer_no")
	private String merNo;
	
	/**
	 * 终端号
	 */
	@Column(name = "term_no")
	private String termNo;
	
	/**
	 * 创建人
	 */
	@Column(name = "create_by")
	private String createBy;
	
	/**
	 * 创建时间
	 */
	@Column(name = "create_date")
	private Date createDate;
	
	/**
	 * 编辑人
	 */
	@Column(name = "update_by")
	private String updateBy;
	
	/**
	 * 编辑时间
	 */
	@Column(name = "update_date")
	private Date updateDate;
	
	/**
	 * 备注
	 */
	@Column(name = "remarks")
	private String remarks;
	
	/**
	 * 机构
	 */
	@Column(name = "organ_id")
	private String organId;
	
	/**
	 * 设备数量
	 */
	@Column(name = "device_count")
	private String deviceCount;
	
	/**
	 * 有效标识
	 */
	@Column(name = "del_flag")
	private String delFlag;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getStrategyName() {
		return strategyName;
	}

	public void setStrategyName(String strategyName) {
		this.strategyName = strategyName;
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

	public String getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(String updateTime) {
		this.updateTime = updateTime;
	}

	public String getDeviceType() {
		return deviceType;
	}

	public void setDeviceType(String deviceType) {
		this.deviceType = deviceType;
	}

	public String getDeviceSnStr() {
		return deviceSnStr;
	}

	public void setDeviceSnStr(String deviceSnStr) {
		this.deviceSnStr = deviceSnStr;
	}

	public String getManufacturerNo() {
		return manufacturerNo;
	}

	public void setManufacturerNo(String manufacturerNo) {
		this.manufacturerNo = manufacturerNo;
	}

	public String getFileId() {
		return fileId;
	}

	public void setFileId(String fileId) {
		this.fileId = fileId;
	}

	public String getMerNo() {
		return merNo;
	}

	public void setMerNo(String merNo) {
		this.merNo = merNo;
	}

	public String getTermNo() {
		return termNo;
	}

	public void setTermNo(String termNo) {
		this.termNo = termNo;
	}

	public String getCreateBy() {
		return createBy;
	}

	public void setCreateBy(String createBy) {
		this.createBy = createBy;
	}

	public Date getCreateDate() {
		return createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	public String getUpdateBy() {
		return updateBy;
	}

	public void setUpdateBy(String updateBy) {
		this.updateBy = updateBy;
	}

	public Date getUpdateDate() {
		return updateDate;
	}

	public void setUpdateDate(Date updateDate) {
		this.updateDate = updateDate;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getOrganId() {
		return organId;
	}

	public void setOrganId(String organId) {
		this.organId = organId;
	}

	public String getDeviceCount() {
		return deviceCount;
	}

	public void setDeviceCount(String deviceCount) {
		this.deviceCount = deviceCount;
	}

	public String getDelFlag() {
		return delFlag;
	}

	public void setDelFlag(String delFlag) {
		this.delFlag = delFlag;
	}

}
