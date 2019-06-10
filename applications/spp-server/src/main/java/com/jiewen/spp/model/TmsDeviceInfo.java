package com.jiewen.spp.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * 设备信息表
 * 
 * @author Pang.M
 */
@Table(name = "t_tms_device_info")
public class TmsDeviceInfo {

	@Id
	private String strategyId; // 策略ID

	@Column(name="device_sn")
	private String deviceSn;

	@Column(name="create_date")
	private Date createDate;

	@Column(name="device_type")
	private String deviceType;

	@Column(name="mer_id")
	private String merId;

	@Column(name="ter_id")
	private String termId; // SN

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

	public Date getCrateDate() {
		return createDate;
	}

	public void setCrateDate(Date createDate) {
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
