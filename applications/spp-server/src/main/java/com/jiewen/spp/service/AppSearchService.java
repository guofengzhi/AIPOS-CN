package com.jiewen.spp.service;

import java.util.List;

import com.jiewen.base.core.Service;
import com.jiewen.spp.model.AppInfo;
import com.jiewen.spp.model.DeviceInfo;
import com.jiewen.spp.wrapper.AppSearchWrapper;

public interface AppSearchService extends Service<AppInfo> {

	public List<AppInfo> getAppInfoList(AppSearchWrapper requestWrapper, DeviceInfo deviceInfo);
}
