package com.jiewen.spp.dao;

import com.jiewen.base.core.Mapper;
import com.jiewen.spp.model.DeviceLogin;

public interface DeviceLoginMapper extends Mapper<DeviceLogin> {

	public DeviceLogin getDeviceLoginBySession(DeviceLogin deviceLogin);
}
