package com.jiewen.spp.modules.tms.entity;

import java.util.Date;

import com.jiewen.base.core.entity.DataEntity;

/**
 * 设备信息表
 * 
 * @author Pang.M
 */
public class TmsDeviceInfo extends DataEntity<TmsDeviceInfo> {

	private static final long serialVersionUID = -9024717637870914377L;

	private String strategyId; // 策略ID

	private String deviceSn;

	private Date createDate;

	private String deviceType;

	private String manuNo;

	private String merId;

	private String termId; // SN

	public String getManuNo() {
		return manuNo;
	}

	public void setManuNo(String manuNo) {
		this.manuNo = manuNo;
	}

	public String getStrategyId() {
		return strategyId;
	}

	public void setStrategyId(String strategyId) {
		this.strategyId = strategyId;
	}

	public String getDeviceSn() {
		return deviceSn;
	}

	public void setDeviceSn(String deviceSn) {
		this.deviceSn = deviceSn;
	}

	public Date getCreateDate() {
		return createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	public String getDeviceType() {
		return deviceType;
	}

	public void setDeviceType(String deviceType) {
		this.deviceType = deviceType;
	}

	public String getMerId() {
		return merId;
	}

	public void setMerId(String merId) {
		this.merId = merId;
	}

	public String getTermId() {
		return termId;
	}

	public void setTermId(String termId) {
		this.termId = termId;
	}

}
