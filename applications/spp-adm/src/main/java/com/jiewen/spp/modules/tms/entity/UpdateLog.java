package com.jiewen.spp.modules.tms.entity;

import java.util.Date;

import com.jiewen.base.core.entity.DataEntity;

/**
 * 更新日志
 * @author guofengzhi
 *
 */
public class UpdateLog extends DataEntity<UpdateLog> {

	private static final long serialVersionUID = -16582814959997879L;

	private Integer fileId; //文件ID
	
	private String fileName; //更新物名称
	
	private String fileType; //文件类型
	
	private String fileSize; //文件大小
	
	private String fileVersion;	//版本
	
	private String filePath; //文件路径
	
	private Integer StrategyId; //策略ID
	
	private String strategyName; //策略名称
		
	private Date beginDate; //开始时间
	
	private Date endDate;	//结束时间
	
	private String manufactureNo; //厂商编号
	
	private String updateTime; //升级次数 
	
	private String deviceType; //机型
	
	private String deviceSn; //SN
	
	private String termNo; //终端号
	
	private String merNo; //商户ID
	
	private Date operateDate; //更新时间
	
	private String organId; //机构号

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

	public String getManufactureNo() {
		return manufactureNo;
	}

	public void setManufactureNo(String manufactureNo) {
		this.manufactureNo = manufactureNo;
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

	public String getTermNo() {
		return termNo;
	}

	public void setTermNo(String termNo) {
		this.termNo = termNo;
	}

	public String getMerNo() {
		return merNo;
	}

	public void setMerNo(String merNo) {
		this.merNo = merNo;
	}

	public Date getOperateDate() {
		return operateDate;
	}

	public void setOperateDate(Date operateDate) {
		this.operateDate = operateDate;
	}

	public String getOrganId() {
		return organId;
	}

	public void setOrganId(String organId) {
		this.organId = organId;
	}

	public String getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(String updateTime) {
		this.updateTime = updateTime;
	}

}
