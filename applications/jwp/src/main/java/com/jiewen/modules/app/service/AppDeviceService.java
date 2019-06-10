package com.jiewen.modules.app.service;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.http.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.google.common.collect.Lists;
import com.jiewen.commons.util.DateTimeUtil;
import com.jiewen.constant.ControlCommand;
import com.jiewen.jwp.base.constant.Constant;
import com.jiewen.jwp.base.constant.JSONConstant;
import com.jiewen.jwp.base.core.exception.ServiceException;
import com.jiewen.jwp.base.service.CrudService;
import com.jiewen.jwp.base.utils.CacheUtils;
import com.jiewen.jwp.base.utils.LocaleMessageSourceUtil;
import com.jiewen.jwp.base.utils.RemotePushUtils;
import com.jiewen.jwp.common.JsonMapper;
import com.jiewen.modules.app.dao.AppDeviceDao;
import com.jiewen.modules.app.dao.AppDeviceTypeDao;
import com.jiewen.modules.app.dao.AppRecordDao;
import com.jiewen.modules.app.dao.AppVersionDao;
import com.jiewen.modules.app.dao.DeviceAppInfoDao;
import com.jiewen.modules.app.entity.AppDevice;
import com.jiewen.modules.app.entity.AppDeviceType;
import com.jiewen.modules.app.entity.AppRecord;
import com.jiewen.modules.app.entity.AppVersion;
import com.jiewen.modules.baseinfo.entity.Strategy;
import com.jiewen.modules.baseinfo.entity.StrategyWarpper;
import com.jiewen.modules.device.dao.DeviceDao;
import com.jiewen.modules.device.entity.Device;
import com.jiewen.modules.rom.dao.PushRecDao;
import com.jiewen.modules.rom.entity.PushRec;
import com.jiewen.modules.sys.utils.UserUtils;
import com.jiewen.spp.dto.DeviceAppInfoDto;
import com.jiewen.utils.StringUtil;

@Service
@Transactional(readOnly = true)
public class AppDeviceService extends CrudService<AppDeviceDao, AppDevice> {

	@Autowired
	private AppDeviceTypeService appDeviceTypeService;

	@Autowired
	private DeviceDao deviceDao;

	@Autowired
	private AppVersionDao appVersionDao;

	@Autowired
	private AppDeviceTypeDao appDeviceTypeDao;

	@Autowired
	private AppRecordDao appRecordDao;

	@Autowired
	private DeviceAppInfoDao deviceAppInfoDao;

	@Autowired
	private PushRecDao pushRecDao;

	@Autowired
	private AppDeviceDao appDeviceDao;

	@Resource
	protected LocaleMessageSourceUtil messageSourceUtil;

	public List<AppDevice> findList(AppDevice appDevice) {
		return dao.findList(appDevice);
	}

	// 获取推送内容
	private String getJPushDes(String isJPushMessage) {
		String jgPushDes = "";
		if ("0".equals(isJPushMessage) || "".equals(jgPushDes)) {
			jgPushDes = "应用文件的更新";
		} else if ("1".equals(isJPushMessage) || "".equals(jgPushDes)) {
			jgPushDes = "应用文件的卸载";
		}
		return jgPushDes;
	}

	/**
	 * 设置appDevice的值
	 * 
	 * @param appVersionId
	 * @param recordAppInfoId
	 * @return
	 */
	private AppDevice initAppDevice(AppVersion appVersion, String recordAppInfoId, String isJPushMessage,
			JSONObject json) {
		AppDevice appDevice = new AppDevice();
		appDevice.preInsert(true);
		appDevice.setApkId(new Long(appVersion.getId()));
		appDevice.setApkVersionShifter(StringUtil.formatVersion(appVersion.getAppVersion()));
		// 不使用策略的情况 保存策略
		if (json != null) {
			appDevice.setStrategyDesc(json.toString());
		}
		appDevice.setAppRecordId(recordAppInfoId);
		appDevice.setUpgradeType(isJPushMessage);
		return appDevice;
	}

	/**
	 * 设置流水发布信息
	 * 
	 * @param appVersion
	 * @return
	 */
	private AppRecord initAppRecord(AppVersion appVersion) {
		AppRecord appRecord = new AppRecord();
		appRecord.preInsert(true);
		appRecord.setAppName(appVersion.getAppName());
		appRecord.setAppPackage(appVersion.getAppPackage());
		appRecord.setApkId(new Long(appVersion.getId()));
		appRecord.setAppVersion(appVersion.getAppVersion());
		String cacheKey = Constant.DEVICE_SN_APP + UserUtils.getUser().getId();
		Object deviceSnObj = CacheUtils.get(cacheKey);
		if (deviceSnObj != null) {
			String message = messageSourceUtil.getMessage("modules.app.sn.release");
			appRecord.setRemarks(message);
		} else {
			String message = messageSourceUtil.getMessage("modules.app.search.release");
			appRecord.setRemarks(message);
		}
		appRecord.setOrganId(UserUtils.getUser().getOfficeId());
		return appRecord;
	}

	/**
	 * 初始化
	 * 
	 * @param appVersionId
	 * @param jPushDes
	 * @param isJPushMessage
	 * @return
	 */
	private PushRec initPushRec(String appVersionId, String isJPushMessage) {
		String jpPushDes = getJPushDes(isJPushMessage);
		PushRec pushRec = new PushRec();
		pushRec.preInsert(true);
		pushRec.setOsId(appVersionId);
		pushRec.setMessageContent(jpPushDes);
		return pushRec;
	}

	/**
	 * 保存
	 * 
	 * @param pushRecs
	 */
	public void savePushRecs(List<PushRec> pushRecs) {

		List<PushRec> subPushRecList = Lists.newArrayList();
		for (int i = 0; i < pushRecs.size(); i = i + 1000) {
			if (i + 1000 < pushRecs.size()) {
				subPushRecList = pushRecs.subList(i, i + 1000);
				batchInsertPushRec(subPushRecList);
			} else {
				subPushRecList = pushRecs.subList(i, pushRecs.size());
				batchInsertPushRec(subPushRecList);
				return;
			}
		}
	}

	/**
	 * 批量保存
	 * 
	 * @param pushRecs
	 */
	public void batchInsertPushRec(List<PushRec> pushRecs) {
		pushRecDao.insertList(pushRecs);
	}

	// 设置AppDevice信息
	private AppDevice getAppDevice(Device device, AppDevice appDevice, String appPackage) {
		appDevice.setDeviceSn(device.getDeviceSn());
		appDevice.setMaunNo(device.getManufacturerNo());
		appDevice.setDeviceType(device.getDeviceType());
		if (device.getAppInfo() != null) {
			JSONArray ja = JSONArray.parseArray(device.getAppInfo().toString());
			Iterator<Object> it = ja.iterator();
			while (it.hasNext()) {
				JSONObject ob = (JSONObject) it.next();
				if (ob.getString(JSONConstant.AppInfo.APP_PACKAGE).equals(appPackage)) {
					appDevice.setDeviceApkVersion(ob.getString(JSONConstant.AppInfo.APP_VERSION));
				}
			}
		}
		return appDevice;
	}

	/**
	 * 发布设备
	 * 
	 * @param devices
	 * @param appVersion
	 * @param appRecord
	 * @param isJPushMessage
	 */
	private void release(List<Device> devices, String appVersionId, Strategy strategy, String isJPushMessage,
			Integer avgMidHourDeviceCount, String upType) {

		String jgPushDes = getJPushDes(isJPushMessage);
		// 将字符串变成json对象
		JSONObject json = getJsonObject(strategy);

		AppVersion appVersion = appVersionDao.get(appVersionId);
		// 1.保存流水记录
		AppRecord appRecord = initAppRecord(appVersion);
		appRecord.setUpgradeType(isJPushMessage);
		appRecord.setUpgradeDesc(upType);
		appRecordDao.insert(appRecord);

		List<AppDevice> appDevices = new ArrayList<>();
		List<PushRec> pushRecs = new ArrayList<>();

		for (Device device : devices) {

			// 2.版本设备发布记录
			AppDevice appDevice = initAppDevice(appVersion, appRecord.getId(), isJPushMessage, json);
			appDevice.setUpgradeDesc(upType);
			appDevices.add(getAppDevice(device, appDevice, appVersion.getAppPackage()));

			// 3.发送消息发布记录
			// 0-应用安装，1-应用卸载
			PushRec pushRec = initPushRec(appVersion.getId(), jgPushDes);
			pushRec.setDeviceId(device.getId());
			pushRecs.add(pushRec);
		}

		// 批量保存
		if (appDevices.size() > 1000) {
			saveAppDeviceListMap(appDevices, strategy, avgMidHourDeviceCount);
		} else {
			batchSaveAppDevice(appDevices);
		}

		// 加入缓存和推送、
		// 保存发送消息
		savePushRecs(pushRecs);
		JSONObject message = new JSONObject();
		message.put("appPackage", appVersion.getAppPackage());
		message.put("des", getJPushDes(isJPushMessage));
		// 0-应用更新，1-应用卸载
		if ("0".equals(isJPushMessage)) {
			RemotePushUtils.batchPush(devices, ControlCommand.APP_UPGRADE, message.toJSONString());
		} else if ("1".equals(isJPushMessage)) {
			RemotePushUtils.batchPush(devices, ControlCommand.APP_UNINSTALL, message.toJSONString());
		}
		addCache(devices, appVersion);
	}

	// 当前页和点选id
	@Transactional(readOnly = false)
	public long saveAppDevice(String appVersionId, String ids, Strategy strategy, String isJPushMessage,
			String upType) {

		List<Integer> idList = new ArrayList<>();
		List<Device> devices = new ArrayList<>();
		String[] idArray = ids.split(",");
		if (idArray != null && idArray.length > 0) {
			for (int i = 0; i < idArray.length; i++) {
				idList.add(new Integer(idArray[i]));
			}
			devices = deviceDao.findDeviceListByIds(idList);
			release(devices, appVersionId, strategy, isJPushMessage, 0, upType);
		}
		return devices.size();
	}

	/**
	 * 获取设备型号
	 * 
	 * @param device
	 * @return
	 */
	private List<AppDeviceType> getAppDeviceTypeList(Device device) {
		AppDeviceType appDeviceType = new AppDeviceType();
		// device.getId() 对应的是apk版本的id,根据apkId查找出所有属于这个版本能够发布的厂商以及设备类型
		appDeviceType.setApkId(new Long(device.getId()));
		appDeviceType.setDeviceType(device.getDeviceType());
		appDeviceType.setManuNo(device.getManufacturerNo());

		List<AppDeviceType> appDeviceTypeList = appDeviceTypeDao.getAppDeviceTypeByApkId(appDeviceType);
		if (appDeviceTypeList == null || appDeviceTypeList.isEmpty()) {
			try {
				String message = messageSourceUtil.getMessage("modules.app.not.require.release");
				throw new ServiceException(message);
			} catch (Exception e) {
				String message = messageSourceUtil.getMessage("modules.app.release.failure");
				logger.error(message);
			}
		}
		return appDeviceTypeList;
	}

	/**
	 * 批量保存
	 * 
	 * @param appDeviceList
	 */
	private void batchSaveAppDevice(List<AppDevice> appDeviceList) {

		for (int i = 0; i < appDeviceList.size(); i = i + 1000) {
			List<AppDevice> subRomDeviceList;
			if (i + 1000 < appDeviceList.size()) {

				subRomDeviceList = appDeviceList.subList(i, i + 1000);
				appDeviceDao.insertList(subRomDeviceList);
			} else {
				subRomDeviceList = appDeviceList.subList(i, appDeviceList.size());
				appDeviceDao.insertList(subRomDeviceList);
				return;
			}
		}
	}

	/**
	 * 发布所有页的设备
	 * 
	 * @param device
	 * @throws Exception
	 */
	@Transactional(readOnly = false)
	public long saveAllAppDevice(Device device, String isJPushMessage, String appVersionId, Strategy strategy,
			String upType) {
		// apk版本id
		AppVersion appVersion = appVersionDao.get(appVersionId);
		device.setId(appVersionId);
		device.setOrganId(appVersion.getOrganId());
		List<AppDeviceType> appDeviceTypeList = getAppDeviceTypeList(device);
		device.setAppDeviceTypeList(appDeviceTypeList);
		String cacheKey = Constant.DEVICE_SN_APP + UserUtils.getUser().getId();
		Object deviceSnObj = CacheUtils.get(cacheKey);

		if (deviceSnObj != null) {
			device.setDeviceSnStr(deviceSnObj.toString());
		}
		List<Device> devices = deviceDao.findDeviceListByParams(device);
		// 如果发布数量大于1000 ，使用策略
		if (devices.size() >= 1000) {

			if (strategy.getBeginDate() == null || strategy.getEndDate() == null) {
				throw new ServiceException("发布设备数量已经大于等于1000台，请添加策略!");
			}
			// 总的半个小时数
			long midHourCount = getHourPoor(strategy.getEndDate(), strategy.getBeginDate()) * 2;

			// 每半个小时需要更新的设备数量
			int avgMidHourDeviceCount = devices.size() / (int) (midHourCount);

			useStrategy(devices, device, isJPushMessage, avgMidHourDeviceCount, strategy, upType);
		} else {
			// 不使用策略
			noUseStrategy(devices, device, isJPushMessage, strategy, upType);
		}

		return devices.size();
	}

	/**
	 * 全量处理相关数据缓存
	 * 
	 * @param devices
	 */
	public void addCache(List<Device> devices, AppVersion appVersion) {
		if (devices != null) {
			for (Device device : devices) {
				getCheckVersion(device, appVersion);
			}
		}
	}

	private List<DeviceAppInfoDto> getCheckVersion(Device device, AppVersion appVersion) {
		DeviceAppInfoDto dto = new DeviceAppInfoDto();
		dto.setDeviceSn(device.getDeviceSn());
		dto.setAppPackage(appVersion.getAppPackage());
		dto.setStartHardShift(appVersion.getStartHardShift());
		dto.setEndHardShift(appVersion.getEndHardShift());
		dto.setOrganId(appVersion.getOrganId());

		String organId = appVersion.getOrganId();
		List<DeviceAppInfoDto> result = deviceAppInfoDao.getCheckAppVersion(dto);
		String catchKey = "APP" + device.getManufacturerNo() + device.getDeviceType() + device.getDeviceSn() + organId
				+ appVersion.getAppPackage();
		cacheRemove(catchKey);
		cachePut(catchKey, result);

		return result;
	}

	/**
	 * 解析参数的厂商和设备类型
	 * 
	 * @param appId
	 * @param manuNosAndTypes
	 * @return
	 */
	private List<AppDeviceType> getAppDeviceType(String appId, String manuNosAndTypes) {

		// 保存对应多个厂商 设备类型
		String jsonHtml4 = StringEscapeUtils.unescapeHtml4(manuNosAndTypes);
		List<AppDeviceType> appDeviceTypes = new ArrayList<>();

		String[] fields = jsonHtml4.split(",");
		for (String field : fields) {
			JSONObject json = JSON.parseObject(field);

			AppDeviceType appDeviceType = new AppDeviceType();
			appDeviceType.setApkId(new Long(appId));

			if (json instanceof JSONObject) {
				Set<String> keySet = json.keySet();
				Iterator<String> it = keySet.iterator();
				while (it.hasNext()) {
					String manuNo = it.next();
					String deviceTypeStr = (String) json.get(manuNo);
					appDeviceType.setManuNo(manuNo);
					appDeviceType.setDeviceType(deviceTypeStr);
					appDeviceTypes.add(appDeviceType);
				}
			}
		}
		return appDeviceTypes;
	}

	/**
	 * 点选按照设备类型发布
	 * 
	 * @param appId
	 * @param deviceParams
	 * @param manuNosAndTypes
	 * @param isJPushMessage
	 */
	@Transactional(readOnly = false)
	public int saveAppDeviceByType(String appId, Device deviceParams, String manuNosAndTypes, String isJPushMessage) {

		// 获取对应多个厂商 设备类型
		List<AppDeviceType> appDeviceTypes = getAppDeviceType(appId, manuNosAndTypes);
		List<Device> devices = new ArrayList<>();
		if (!appDeviceTypes.isEmpty()) {

			AppVersion appVersion = appVersionDao.get(appId);

			// 设置流水发布信息
			AppRecord appRecord = initAppRecord(appVersion);
			appRecordDao.insert(appRecord);

			deviceParams.setId(appId);
			deviceParams.setAppDeviceTypeList(appDeviceTypes);
			devices = deviceDao.findDeviceListByParams(deviceParams);
			// release(devices, appVersion, appRecord, isJPushMessage);
		}
		return devices.size();
	}

	/**
	 * 按照设备类型全部发布
	 * 
	 * @param appId
	 * @param device
	 * @param isJPushMessage
	 */
	@Transactional(readOnly = false)
	public int saveAppAllDeviceByType(Device device, String isJPushMessage) {

		String appId = device.getId();
		List<AppDeviceType> appDeviceTypeList = appDeviceTypeService.getAppDeviceTypeByApkId(appId);
		device.setAppDeviceTypeList(appDeviceTypeList);
		List<Device> devices = deviceDao.findDeviceListByParams(device);

		if (devices != null && !devices.isEmpty()) {

			AppVersion appVersion = appVersionDao.get(appId);
			// 设置流水发布信息
			AppRecord appRecord = initAppRecord(appVersion);
			appRecordDao.insert(appRecord);

			// release(devices, appVersion, appRecord, isJPushMessage);
			return devices.size();
		}
		return 0;
	}

	/**
	 * 保存并使用策略
	 * 
	 * @param groupRomDeviceListMap
	 * @param startDate
	 * @param endDate
	 * @throws ParseException
	 */
	@Transactional(readOnly = false)
	public void saveAppDeviceListMap(List<AppDevice> appDeviceList, Strategy strategy, Integer avgMidHourDeviceCount) {

		List<AppDevice> totalAppDeviceList = new ArrayList<>();
		Date startDate = strategy.getBeginDate();
		Date endDate = strategy.getEndDate();
		// 将字符串变成json对象
		JSONObject json = getJsonObject(strategy);

		Calendar calendar = Calendar.getInstance();
		calendar.setTime(startDate);
		// 开始时间的小时开始
		int hour24 = calendar.get(Calendar.HOUR_OF_DAY);
		// 从早上九点开始
		if (hour24 < 9) {
			hour24 = 9;
		}
		int k = 0;
		for (double i = hour24; i < 18; i += 0.5) {
			List<AppDevice> subList = new ArrayList<>();
			subList = appDeviceList.subList(avgMidHourDeviceCount * k, avgMidHourDeviceCount * (k + 1));

			if (appDeviceList.size() > avgMidHourDeviceCount * (k + 2)) {
				k++;
			}
			// 保存
			saveAppDeviceStrategy(totalAppDeviceList, subList, startDate, json, i);
		}
		// 时间转换， 去掉小时分钟秒
		String startDateStr = DateTimeUtil.toExtendedDateFormat(startDate);
		String endDateStr = DateTimeUtil.toExtendedDateFormat(endDate);

		Date staDate = DateTimeUtil.toDateTime(startDateStr, "yyyy-MM-dd");
		Date enDate = DateTimeUtil.toDateTime(endDateStr, "yyyy-MM-dd");

		calendar.setTime(staDate);

		while (!staDate.equals(enDate)) {

			calendar.add(Calendar.DATE, 1); // 日期加1天
			staDate = calendar.getTime();
			calendar.setTime(staDate);

			for (double i = 9; i < 18; i += 0.5) {
				List<AppDevice> subList = new ArrayList<>();
				subList = appDeviceList.subList(avgMidHourDeviceCount * k, avgMidHourDeviceCount * (k + 1));

				if (appDeviceList.size() > avgMidHourDeviceCount * (k + 2)) {
					k++;
				} else {
					// k 到 最后一起保存
					subList = appDeviceList.subList(avgMidHourDeviceCount * k, appDeviceList.size());
					// 保存
					saveAppDeviceStrategy(totalAppDeviceList, subList, staDate, json, i);
					batchSaveAppDevice(totalAppDeviceList);
					return;
				}
				// 保存
				saveAppDeviceStrategy(totalAppDeviceList, subList, staDate, json, i);
			}
		}
		batchSaveAppDevice(totalAppDeviceList);
	}

	/**
	 * 转换关于json对象
	 * 
	 * @param strategy
	 * @return
	 */
	private JSONObject getJsonObject(Strategy strategy) {
		StrategyWarpper strategyWarpper = new StrategyWarpper();
		try {
			BeanUtils.copyProperties(strategyWarpper, strategy);
		} catch (IllegalAccessException | InvocationTargetException e) {
			logger.error(e.getMessage());
		}
		return (JSONObject) JSON.parse(JsonMapper.toJsonString(strategyWarpper));
	}

	/**
	 * 保存
	 * 
	 * @param subList
	 */
	@Transactional(readOnly = false)
	public List<AppDevice> saveAppDeviceStrategy(List<AppDevice> totalAppDeviceList, List<AppDevice> subList,
			Date startDate, JSONObject json, double i) {
		for (AppDevice appDevice : subList) {

			appDevice.setStrategyDesc(getStrategyDesc(i, startDate, json));
			totalAppDeviceList.add(appDevice);
		}
		return totalAppDeviceList;
	}

	/**
	 * 获取策略
	 * 
	 * @param i
	 * @param startDate
	 * @return
	 */
	private String getStrategyDesc(double i, Date startDate, JSONObject json) {

		// 开始时间的年月日 时分秒
		String year = getDateStrByType("year", startDate);
		String month = getDateStrByType("mouth", startDate);
		String today = getDateStrByType("day", startDate);

		String downDate = year + "-" + month + "-" + today;
		String downStartTime = "";
		String downEndTime = "";

		if ((i / 0.5) % 2 == 0) {

			downStartTime = getOddDownStartTimeStr(i);
			downEndTime = getOddDownEndTimeStr(i);

		} else {

			downStartTime = getOddDownEndTimeStr(i);
			downEndTime = getEvenDownEndTimeStr(i);
		}

		if (!json.isEmpty()) {
			json.put("downDate", downDate);
			json.put("downStartTime", downStartTime);
			json.put("downEndTime", downEndTime);
		}

		return json.toString();
	}

	private String getDateStrByType(String type, Date date) {

		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		// 开始时间的年月日 时分秒
		switch (type) {
		case "year":
			return String.valueOf(calendar.get(Calendar.YEAR));
		case "mouth":
			int mouth = calendar.get(Calendar.MONTH) + 1;
			if (mouth <= 9) {
				return "0" + mouth;
			}
			return String.valueOf(mouth);
		case "day":
			int day = calendar.get(Calendar.DAY_OF_MONTH);
			if (day <= 9) {
				return "0" + day;
			}
			return String.valueOf(day);
		default:
			break;
		}
		return "";
	}

	/**
	 * 获取偶数时间段开始时间
	 * 
	 * @param i
	 * @return
	 */
	private String getOddDownStartTimeStr(double i) {
		String downStartTime = "";
		if (i <= 9) {
			downStartTime = "0" + (int) i + ":00";
		} else {
			downStartTime = (int) i + ":00";
		}
		return downStartTime;
	}

	/**
	 * 获取偶数时间段结束时间
	 * 
	 * @param i
	 * @return
	 */
	private String getOddDownEndTimeStr(double i) {
		String downEndTime = "";
		if (i <= 9) {
			downEndTime = "0" + (int) i + ":30";
		} else {
			downEndTime = (int) i + ":30";
		}
		return downEndTime;
	}

	private String getEvenDownEndTimeStr(double i) {
		String downEndTime = "";
		if (i <= 9) {
			downEndTime = "0" + (int) (i + 0.5) + ":00";
		} else {
			downEndTime = (int) (i + 0.5) + ":00";
		}
		return downEndTime;
	}

	/**
	 * 获取时间间隔 小时为基准
	 * 
	 * @param endDate
	 * @param startDate
	 * @return
	 */
	private long getHourPoor(Date endDate, Date startDate) {

		long nd = (long) 1000 * 24 * 60 * 60;
		long nh = (long) 1000 * 60 * 60;
		long nm = (long) 1000 * 60;
		// 获得两个时间的毫秒时间差异
		long diff = endDate.getTime() - startDate.getTime();
		// 计算差多少天
		long day = diff / nd;
		// 计算差多少小时
		long hour = diff % nd / nh;
		// 计算差多少分钟
		long min = diff % nd % nh / nm;

		if (min < 30) {
			hour += 1;
		} else {
			hour += 0.5;
		}
		// 一天9个小时
		long deHour = day * 9 + hour;

		// 开始时间的年月日 时分秒
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(startDate);
		int hour24 = calendar.get(Calendar.HOUR_OF_DAY);

		if (hour24 >= 18) {
			deHour -= (24 - hour24);
		} else {
			deHour -= 6;
		}

		return deHour;
	}

	/**
	 * 使用策略
	 * 
	 * @param devices
	 * @param device
	 * @param jPushDes
	 * @param avgDayDeviceCount
	 * @param startDate
	 * @param endDate
	 * @throws Exception
	 */
	private void useStrategy(List<Device> devices, Device device, String isJPushMessage, Integer avgMidHourDeviceCount,
			Strategy strategy, String upType) {
		// device 的id就是OSRom的id
		String apkId = device.getId();
		if (devices != null && !devices.isEmpty()) {
			release(devices, apkId, strategy, isJPushMessage, avgMidHourDeviceCount, upType);
		}
	}

	/**
	 * 不使用策略 正常发布
	 * 
	 * @param devices
	 * @param device
	 * @param jPushDes
	 * @throws Exception
	 */
	private void noUseStrategy(List<Device> devices, Device device, String isJPushMessage, Strategy strategy,
			String upType) {
		// device 的id就是OSRom的id
		String apkId = device.getId();
		if (devices != null && !devices.isEmpty()) {
			release(devices, apkId, strategy, isJPushMessage, 0, upType);
		}
	}

}
