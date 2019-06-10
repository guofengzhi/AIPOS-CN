package com.jiewen.modules.app.service;

import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.jiewen.jwp.base.service.CrudService;
import com.jiewen.modules.app.dao.AppDeviceDao;
import com.jiewen.modules.app.dao.AppDeviceTypeDao;
import com.jiewen.modules.app.dao.AppRecordDao;
import com.jiewen.modules.app.dao.AppVersionDao;
import com.jiewen.modules.app.entity.AppDeviceType;
import com.jiewen.modules.app.entity.AppVersion;
import com.jiewen.modules.rom.dao.PushRecDao;
import com.jiewen.utils.StringUtil;

@Service
@Transactional(readOnly = true)
public class AppVersionService extends CrudService<AppVersionDao, AppVersion> {

	@Autowired
	private AppVersionDao appVersionDao;

	@Autowired
	private AppDeviceTypeDao appDeviceTypeDao;

	@Autowired
	private AppDeviceDao appDeviceDao;

	@Autowired
	private PushRecDao pushRecDao;

	@Autowired
	private AppRecordDao appRecordDao;

	@Transactional(readOnly = false)
	public void deleteById(AppVersion appVersion) {
		dao.delete(appVersion);
		appDeviceDao.deleteAppDeviceByApkId(appVersion.getId());
		pushRecDao.deletePushRecByOsId(appVersion.getId());
		appRecordDao.deleteAppRecordByApkId(appVersion.getId());
	}

	public AppVersion getAppVersionById(AppVersion appVersion) {
		return appVersionDao.get(appVersion.getId());
	}

	@Transactional(readOnly = false)
	public void saveAppVersion(AppVersion appVersion) {

		formatVersion(appVersion);

		// 保存apk信息
		appVersion.preInsert(true);
		dao.insert(appVersion);
		saveMaunFactoryDeviceType(appVersion.getManuJsonStr(), appVersion.getId());

	}

	@Transactional(readOnly = false)
	public void update(AppVersion appVersion) {
		formatVersion(appVersion);
		appVersion.preUpdate();
		dao.update(appVersion);
		saveMaunFactoryDeviceType(appVersion.getManuJsonStr(), appVersion.getId());
	}

	/**
	 * 保存数据前格式化处理特殊版本号
	 * 
	 * @param appVersion
	 */
	public void formatVersion(AppVersion appVersion) {
		appVersion.setAppVersionCompareVal(StringUtil.formatVersion(appVersion.getAppVersion()));
		if (StringUtil.isEmpty(appVersion.getStartHard())) {
			appVersion.setStartHardShift(StringUtil.formatVersion("0"));
		} else {
			appVersion.setStartHardShift(StringUtil.formatVersion(appVersion.getStartHard()));
		}
		appVersion.setEndHardShift(StringUtil.formatVersion(appVersion.getEndHard()));
	}

	/**
	 * 保存厂商与设备类型 关联 apk文件.
	 * 
	 * @param maunFactoryType
	 * @param apkId
	 */
	public void saveMaunFactoryDeviceType(String maunFactoryType, String apkId) {
		// 保存对应多个厂商 设备类型
		String jsonHtml4 = StringEscapeUtils.unescapeHtml4(maunFactoryType);
		JSONObject json = JSONObject.parseObject(jsonHtml4);
		if (json != null && !json.isEmpty()) {
			AppDeviceType appDeviceType = new AppDeviceType();
			if (StringUtils.isNotBlank(apkId)) {
				appDeviceType.setApkId(Long.parseLong(apkId));
				appDeviceTypeDao.deleteByApkId(appDeviceType);
			}
			Set<String> keySet = json.keySet();
			Iterator<String> it = keySet.iterator();
			while (it.hasNext()) {
				String manuNo = it.next();
				String deviceTypeStr = json.getString(manuNo);
				String[] deviceTypes = deviceTypeStr.split(",");
				for (String deviceType : deviceTypes) {
					appDeviceType.setManuNo(manuNo);
					appDeviceType.setDeviceType(deviceType);
					appDeviceType.preInsert(true);
					appDeviceTypeDao.insert(appDeviceType);
				}
			}
		}
	}

	public List<AppVersion> findAppVerListByParams(AppVersion appVersion) {
		return appVersionDao.findAppVerListByParams(appVersion);
	}

	public PageInfo<AppVersion> findAppVersionByDeviceSn(AppVersion appVersion) {
		PageHelper.startPage(appVersion);
		return new PageInfo<>(appVersionDao.findAppVersionByDeviceSn(appVersion));
	}

	public List<AppVersion> findAppVerByVersion(String appPackage) {
		AppVersion appVersion = new AppVersion();
		appVersion.setAppPackage(appPackage);
		return appVersionDao.findAppVerByVersion(appVersion);
	}

}
