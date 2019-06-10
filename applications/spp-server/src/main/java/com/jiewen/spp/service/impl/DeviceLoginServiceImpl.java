package com.jiewen.spp.service.impl;

import java.util.Date;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.jiewen.base.core.AbstractService;
import com.jiewen.commons.util.DateTimeUtil;
import com.jiewen.spp.dao.DeviceLoginMapper;
import com.jiewen.spp.model.DeviceLogin;
import com.jiewen.spp.service.DeviceLoginService;

@Service
public class DeviceLoginServiceImpl extends AbstractService<DeviceLogin> implements DeviceLoginService {

	@Resource
	private DeviceLoginMapper deviceLoginMapper;

	@Override
	public DeviceLogin getDeviceLoginBySession(DeviceLogin record) {
		if (record != null) {
			return deviceLoginMapper.getDeviceLoginBySession(record);
		}
		return null;
	}

	@Override
	public void RecordDevicelogonInfo(DeviceLogin deviceLogin, String token) {
		Date currentDate = new Date();
		deviceLogin.setLastLoginAttempt(currentDate);
		deviceLogin.setLastLoginSuccess(currentDate);
		deviceLogin.setPasswordErrNum(0);
		deviceLogin.setLastOperateTime(DateTimeUtil.getSystemDateTime("yyyyMMddHHmss"));
		deviceLogin.setSessionId(token);
		deviceLoginMapper.insertSelective(deviceLogin);
	}

}
