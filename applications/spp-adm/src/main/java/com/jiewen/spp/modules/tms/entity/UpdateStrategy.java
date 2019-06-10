package com.jiewen.spp.modules.tms.entity;

import java.util.Date;

import com.jiewen.base.core.entity.DataEntity;

/**
 * 更新策略
 * 
 * @author guofengzhi
 */
public class UpdateStrategy extends DataEntity<UpdateStrategy> {

	private static final long serialVersionUID = -9024717637870914377L;

	private String strategyName; // 策略名称

	private Date beginDate; // 开始时间

	private Date endDate; // 结束时间

	private String updateTime; // 升级次数 O:一次，M:多次

	private String deviceType; // 机型

	private String deviceSnStr; // SN

	private String termNo; // 终端号

	private Integer fileId; // 文件ID

	private String merNo; // 商户号

	private String manufactureNo; // 厂商编号

	private String organId; // 机构号

	private int count;

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

	public int getCount() {
		return count;
	}

	public void setCount(int count) {
		this.count = count;
	}

	public String getTermNo() {
		return termNo;
	}

	public void setTermNo(String termNo) {
		this.termNo = termNo;
	}

	public Integer getFileId() {
		return fileId;
	}

	public void setFileId(Integer fileId) {
		this.fileId = fileId;
	}

	public String getMerNo() {
		return merNo;
	}

	public void setMerNo(String merNo) {
		this.merNo = merNo;
	}

	public String getManufactureNo() {
		return manufactureNo;
	}

	public void setManufactureNo(String manufactureNo) {
		this.manufactureNo = manufactureNo;
	}

	public String getOrganId() {
		return organId;
	}

	public void setOrganId(String organId) {
		this.organId = organId;
	}
}
