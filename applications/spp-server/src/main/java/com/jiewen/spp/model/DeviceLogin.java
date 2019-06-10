package com.jiewen.spp.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

@Table(name = "t_device_login")
public class DeviceLogin {

	/**
	 * ID
	 */
	@Id
	private Integer id;

	/**
	 * 设备sn
	 */
	@Column(name = "device_sn")
	private String deviceSn;

	/**
	 * 密码错误次数
	 */
	@Column(name = "password_err_num")
	private Integer passwordErrNum;

	/**
	 * 最后登录成功时间
	 */
	@Column(name = "last_login_success")
	private Date lastLoginSuccess;

	/**
	 * 最后尝试登录时间
	 */
	@Column(name = "last_login_attempt")
	private Date lastLoginAttempt;

	/**
	 * session
	 */
	@Column(name = "session_id")
	private String sessionId;

	/**
	 * 最后操作时间
	 */
	@Column(name = "last_operate_time")
	private String lastOperateTime;

	public String getDeviceSn() {
		return deviceSn;
	}

	public void setDeviceSn(String deviceSn) {
		this.deviceSn = deviceSn;
	}

	public Integer getPasswordErrNum() {
		return passwordErrNum;
	}

	public void setPasswordErrNum(Integer passwordErrNum) {
		this.passwordErrNum = passwordErrNum;
	}

	public Date getLastLoginSuccess() {
		return lastLoginSuccess;
	}

	public void setLastLoginSuccess(Date lastLoginSuccess) {
		this.lastLoginSuccess = lastLoginSuccess;
	}

	public Date getLastLoginAttempt() {
		return lastLoginAttempt;
	}

	public void setLastLoginAttempt(Date lastLoginAttempt) {
		this.lastLoginAttempt = lastLoginAttempt;
	}

	public String getSessionId() {
		return sessionId;
	}

	public void setSessionId(String sessionId) {
		this.sessionId = sessionId;
	}

	public String getLastOperateTime() {
		return lastOperateTime;
	}

	public void setLastOperateTime(String lastOperateTime) {
		this.lastOperateTime = lastOperateTime;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

}