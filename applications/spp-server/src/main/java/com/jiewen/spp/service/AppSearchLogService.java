package com.jiewen.spp.service;

import java.util.List;

import com.jiewen.base.core.Service;
import com.jiewen.spp.model.AppSearchLog;
import com.jiewen.spp.model.DeviceInfo;
import com.jiewen.spp.wrapper.TopSearchWrapper;

public interface AppSearchLogService extends Service<AppSearchLog> {

	public List<AppSearchLog> getTopSearchList(TopSearchWrapper requestWrapper, DeviceInfo deviceInfo);
}
