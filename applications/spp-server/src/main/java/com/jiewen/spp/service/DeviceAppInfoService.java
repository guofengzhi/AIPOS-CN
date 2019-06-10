package com.jiewen.spp.service;

import java.util.List;

import com.alibaba.fastjson.JSONObject;
import com.jiewen.base.core.Service;
import com.jiewen.spp.dto.DeviceAppInfoDto;
import com.jiewen.spp.model.DeviceInfo;
import com.jiewen.spp.wrapper.AppListParamsWrapper;
import com.jiewen.spp.wrapper.AppParamsWrapper;

/**
 * Created by CodeGenerator on 2017/08/18.
 */
public interface DeviceAppInfoService extends Service<DeviceInfo> {

	public DeviceAppInfoDto getCheckAppVersion(AppParamsWrapper appParamsWrapper);

	public List<JSONObject> getCheckAppVersionList(AppListParamsWrapper appListParamsWrapper);

}
