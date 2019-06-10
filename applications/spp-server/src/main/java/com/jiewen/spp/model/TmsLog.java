package com.jiewen.spp.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

@Table(name = "t_tms_log")
public class TmsLog {

	/**
	 * ID
	 */
	@Id
	private String id;
	
	/**
	 * 文件ID
	 */
	@Column(name = "file_id")
	private Integer fileId;
	
	/**
	 * 更新物名称
	 */
	@Column(name = "file_name")
	private String fileName;
	
	/**
	 * 文件类型
	 */
	@Column(name = "file_type")
	private String fileType;
	
	/**
	 * 文件大小
	 */
	@Column(name = "file_size")
	private String fileSize;
	
	/**
	 * 版本
	 */
	@Column(name = "file_version")
	private String fileVersion;
	
	/**
	 * 文件路径
	 */
	@Column(name = "file_path")
	private String filePath;
	
	/**
	 * 策略ID
	 */
	@Column(name = "strategy_id")
	private Integer StrategyId;
	
	/**
	 * 策略名称
	 */
	@Column(name = "strategy_name")
	private String strategyName;
		
	/**
	 * 开始时间
	 */
	@Column(name = "begin_date")
	private Date beginDate;
	
	/**
	 * 结束时间
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
	 * sn号
	 */
	@Column(name = "device_sn")
	private String deviceSn;
	
	/**
	 * 厂商
	 */
	@Column(name = "manufacture_no")
	private String manufacture;
	
	/**
	 * 商户ID
	 */
	@Column(name = "mer_no")
	private String merNo;
	
	/**
	 * 终端号
	 */
	@Column(name = "term_no")
	private String termNo;
	
	/**
	 * 更新时间
	 */
	@Column(name = "operate_date")
	private Date operateDate;

	/**
	 * 备注
	 */
	@Column(name = "remarks")
	private String remarks;

	/**
	 * 机构ID
	 */
	@Column(name = "organ_id")
	private String organId;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public Integer getFileId() {
		return fileId;
	}

	public void setFileId(Integer fileId) {
		this.fileId = fileId;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getFileType() {
		return fileType;
	}

	public void setFileType(String fileType) {
		this.fileType = fileType;
	}

	public String getFileSize() {
		return fileSize;
	}

	public void setFileSize(String fileSize) {
		this.fileSize = fileSize;
	}

	public String getFileVersion() {
		return fileVersion;
	}

	public void setFileVersion(String fileVersion) {
		this.fileVersion = fileVersion;
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public Integer getStrategyId() {
		return StrategyId;
	}

	public void setStrategyId(Integer strategyId) {
		StrategyId = strategyId;
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

	public String getDeviceSn() {
		return deviceSn;
	}

	public void setDeviceSn(String deviceSn) {
		this.deviceSn = deviceSn;
	}

	public String getManufacture() {
		return manufacture;
	}

	public void setManufacture(String manufacture) {
		this.manufacture = manufacture;
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

	public Date getOperateDate() {
		return operateDate;
	}

	public void setOperateDate(Date operateDate) {
		this.operateDate = operateDate;
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

}
