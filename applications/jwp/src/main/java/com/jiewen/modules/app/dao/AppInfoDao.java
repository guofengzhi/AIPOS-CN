package com.jiewen.modules.app.dao;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.modules.app.entity.AppInfo;

/**
 * APPDao
 * 
 * @author Administrator
 *
 */
@Transactional
public interface AppInfoDao extends CrudDao<AppInfo> {

	public AppInfo findAppInfoByName(String appName);

	public AppInfo findAppInfoByPackage(String packageName, String clientIdentification);

	public List<AppInfo> findAppInfoListByPackage(String packageName);

	public AppInfo findAppInfoByPAndOID(AppInfo appInfo);

	public Integer getDeviceCount(AppInfo appInfo);

	public AppInfo getByPackageName(AppInfo appInfoParam);

	public AppInfo getAppInfoById(AppInfo appInfoParam);
}
