package com.jiewen.spp.service;

import com.jiewen.base.core.Service;
import com.jiewen.spp.model.DeviceLogin;

public interface DeviceLoginService extends Service<DeviceLogin> {

	public DeviceLogin getDeviceLoginBySession(DeviceLogin deviceLogin);

	public void RecordDevicelogonInfo(DeviceLogin deviceLogin, String token);
}
