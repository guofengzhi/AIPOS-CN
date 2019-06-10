package com.jiewen.modules.app.service;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.jiewen.jwp.base.constant.JSONConstant;
import com.jiewen.jwp.base.service.CrudService;
import com.jiewen.jwp.common.StringUtils;
import com.jiewen.modules.app.dao.AppDeveloperDao;
import com.jiewen.modules.app.dao.AppInfoDao;
import com.jiewen.modules.app.entity.AppDeveloper;
import com.jiewen.modules.app.entity.AppInfo;

@Service
@Transactional(readOnly = true)
public class AppInfoService extends CrudService<AppInfoDao, AppInfo> {

	@Autowired
	private AppInfoDao appInfoDao;

	@Autowired
	private AppDeveloperDao appDeveloperDao;

	@Transactional(readOnly = false)
	public void deleteById(AppInfo appInfo) {
		dao.delete(appInfo);
	}

	@Transactional(readOnly = false)
	public void saveAppInfo(AppInfo appInfo) {

		appInfo.preInsert(true);
		if (StringUtils.isBlank(appInfo.getAppDeveloper())) {
			appInfo.setAppDeveloper("0");
		}
		dao.insert(appInfo);
	}

	@Transactional(readOnly = false)
	public void update(AppInfo appInfo) {
		if (StringUtils.isBlank(appInfo.getAppDeveloper())) {
			appInfo.setAppDeveloper("0");
		}
		appInfo.preUpdate();
		dao.update(appInfo);
	}

	public PageInfo<AppInfo> findApprovalPage(AppInfo appInfo) {
		PageHelper.startPage(appInfo);
		return new PageInfo<>(findList(appInfo));
	}

	public AppInfo findAppInfoByName(String appName) {
		return appInfoDao.findAppInfoByName(appName);
	}

	public List<AppInfo> findAppInfoListByPackage(String packageName) {
		return appInfoDao.findAppInfoListByPackage(packageName);
	}

	public AppInfo findAppInfoByPAndOID(AppInfo appInfo) {
		return appInfoDao.findAppInfoByPAndOID(appInfo);
	}

	/**
	 * 查询APP信息列表 转换APP开发者
	 * 
	 * @param appInfoString
	 * @return
	 */
	public List<AppInfo> findAppInfoListConverDevolper(String appInfoString, String organId) {
		List<AppInfo> appInfolist = new ArrayList<>();
		JSONArray appInfoArray = null;
		appInfoArray = JSONArray.parseArray(appInfoString);
		Iterator<Object> it = appInfoArray.iterator();
		while (it.hasNext()) {
			JSONObject ob = (JSONObject) it.next();
			AppInfo appInfo = null;
			if (ob.getString(JSONConstant.AppInfo.APP_PACKAGE) != null) {
				appInfo = appInfoDao.findAppInfoByPackage(ob.getString(JSONConstant.AppInfo.APP_PACKAGE), organId);
				if (appInfo == null) {
					appInfo = new AppInfo();
					appInfo.setAppName(ob.getString(JSONConstant.AppInfo.APP_NAME));
					appInfo.setAppPackage(ob.getString(JSONConstant.AppInfo.APP_PACKAGE));
					appInfo.setInstallDate(ob.getString(JSONConstant.AppInfo.APP_INSTALL_DATE));
					appInfo.setAppVersion(ob.getString(JSONConstant.AppInfo.APP_VERSION));
				} else {
					List<AppDeveloper> appDeveloperList = appDeveloperDao.findList(new AppDeveloper());
					for (int i = 0; i < appDeveloperList.size(); i++) {
						AppDeveloper appDeveLoper = appDeveloperList.get(i);
						if (appInfo.getAppDeveloper().equals(appDeveLoper.getId())) {
							appInfo.setAppDeveloper(appDeveLoper.getName());
							appInfo.setAppVersion(ob.getString(JSONConstant.AppInfo.APP_VERSION));
							appInfo.setInstallDate(ob.getString(JSONConstant.AppInfo.APP_INSTALL_DATE));
						}
					}

				}
			}
			appInfolist.add(appInfo);
		}

		return appInfolist;
	}

	@Transactional(readOnly = false)
	public Integer getDeviceCount(AppInfo appInfoParam) {
		return appInfoDao.getDeviceCount(appInfoParam);
	}

	public AppInfo getByPackageName(AppInfo appInfoParam) {
		return appInfoDao.getByPackageName(appInfoParam);
	}

	public AppInfo getAppInfoById(String id) {
		AppInfo appInfoParam = new AppInfo();
		appInfoParam.setId(id);
		return appInfoDao.getAppInfoById(appInfoParam);
	}

}
