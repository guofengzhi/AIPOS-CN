package com.jiewen.spp.dao;

import java.util.List;

import com.jiewen.base.core.Mapper;
import com.jiewen.spp.model.AppInfo;

public interface AppInfoMapper extends Mapper<AppInfo> {

	public List<AppInfo> getAppInfoList(AppInfo appInfo);

	public List<AppInfo> getAppListByUpgradeCounts(AppInfo appInfo);
}
