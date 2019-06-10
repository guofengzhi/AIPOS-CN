
package com.jiewen.spp.modules.rom.service;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.google.common.collect.Lists;
import com.jiewen.base.common.constant.Constant;
import com.jiewen.base.common.utils.CacheUtils;
import com.jiewen.base.core.service.CrudService;
import com.jiewen.base.sys.utils.UserUtils;
import com.jiewen.commons.util.DateTimeUtil;
import com.jiewen.constant.ControlCommand;
import com.jiewen.jwp.common.exception.ServiceException;
import com.jiewen.jwp.common.utils.StringUtils;
import com.jiewen.jwp.common.utils.mapper.JsonMapper;
import com.jiewen.spp.dto.DeviceOsInfoDto;
import com.jiewen.spp.modules.baseinfo.entity.Strategy;
import com.jiewen.spp.modules.baseinfo.entity.StrategyWarpper;
import com.jiewen.spp.modules.device.dao.DeviceDao;
import com.jiewen.spp.modules.device.entity.Device;
import com.jiewen.spp.modules.rom.dao.DeviceOsInfoDao;
import com.jiewen.spp.modules.rom.dao.OsRomInfoDao;
import com.jiewen.spp.modules.rom.dao.PushRecDao;
import com.jiewen.spp.modules.rom.dao.RecordRomInfoDao;
import com.jiewen.spp.modules.rom.dao.RomDeviceDao;
import com.jiewen.spp.modules.rom.entity.OsRomInfo;
import com.jiewen.spp.modules.rom.entity.PushRec;
import com.jiewen.spp.modules.rom.entity.RecordRomInfo;
import com.jiewen.spp.modules.rom.entity.RomDevice;
import com.jiewen.spp.utils.LocaleMessageSourceUtil;
import com.jiewen.spp.utils.RemotePushUtils;
import com.jiewen.utils.StringUtil;

@Service
@Transactional
public class RomDeviceService extends CrudService<RomDeviceDao, RomDevice> {

	@Resource
	private LocaleMessageSourceUtil messageSourceUtil;

	@Autowired
	private DeviceOsInfoDao deviceOsInfoDao;

	@Autowired
	private DeviceDao deviceDao;

	@Autowired
	private PushRecDao pushRecDao;

	@Autowired
	private RecordRomInfoDao recordRomInfoDao;

	@Autowired
	private RomDeviceDao romDeviceDao;

	@Autowired
	private OsRomInfoDao osRomInfoDao;

	@Override
	public List<RomDevice> findList(RomDevice romDevice) {
		return dao.findList(romDevice);
	}

	@Transactional(readOnly = false)
	public void deleteById(RomDevice romDevice) {
		dao.delete(romDevice);
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
	 * 保存
	 * 
	 * @param subList
	 */
	@Transactional(readOnly = false)
	public List<RomDevice> saveRomDeviceStrategy(List<RomDevice> totalRomDeviceList, List<RomDevice> subList,
			Date startDate, JSONObject json, double i) {
		for (RomDevice romDevice : subList) {

			romDevice.setStrategyDesc(getStrategyDesc(i, startDate, json));
			totalRomDeviceList.add(romDevice);
		}
		return totalRomDeviceList;
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

	/**
	 * 保存并使用策略
	 * 
	 * @param groupRomDeviceListMap
	 * @param startDate
	 * @param endDate
	 * @throws ParseException
	 */
	@Transactional(readOnly = false)
	public void saveRomDeviceListMap(List<RomDevice> romDeviceList, Strategy strategy, Integer avgMidHourDeviceCount) {

		List<RomDevice> totalRomDeviceList = new ArrayList<>();
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
			List<RomDevice> subList = new ArrayList<>();
			subList = romDeviceList.subList(avgMidHourDeviceCount * k, avgMidHourDeviceCount * (k + 1));

			if (romDeviceList.size() > avgMidHourDeviceCount * (k + 2)) {
				k++;
			}
			// 保存
			saveRomDeviceStrategy(totalRomDeviceList, subList, startDate, json, i);
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
				List<RomDevice> subList = new ArrayList<>();
				subList = romDeviceList.subList(avgMidHourDeviceCount * k, avgMidHourDeviceCount * (k + 1));

				if (romDeviceList.size() > avgMidHourDeviceCount * (k + 2)) {
					k++;
				} else {
					// k 到 最后一起保存
					subList = romDeviceList.subList(avgMidHourDeviceCount * k, romDeviceList.size());
					// 保存
					saveRomDeviceStrategy(totalRomDeviceList, subList, staDate, json, i);
					saveRomDevices(totalRomDeviceList);
					return;
				}
				// 保存
				saveRomDeviceStrategy(totalRomDeviceList, subList, staDate, json, i);
			}
		}
		saveRomDevices(totalRomDeviceList);
	}

	public void saveRomDevices(List<RomDevice> totalRomDeviceLists) {

		List<RomDevice> subRomDeviceList = Lists.newArrayList();
		for (int i = 0; i < totalRomDeviceLists.size(); i = i + 1000) {

			if (i + 1000 < totalRomDeviceLists.size()) {

				subRomDeviceList = totalRomDeviceLists.subList(i, i + 1000);
				saveRomDevice(subRomDeviceList);
			} else {
				subRomDeviceList = totalRomDeviceLists.subList(i, totalRomDeviceLists.size());
				saveRomDevice(subRomDeviceList);
				return;
			}
		}
	}

	@Transactional(readOnly = false)
	public void saveRomDevice(List<RomDevice> romDeviceList) {

		romDeviceDao.insertList(romDeviceList);
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
	 * 主动更新所有页的设备
	 * 
	 * @param device
	 * @throws ParseException
	 */
	@Transactional(readOnly = false)
	public Integer saveAllRomDevice(Device device, String isJPushMessage, Strategy strategy) throws Exception {
		String releaseTransfinite = messageSourceUtil.getMessage("modules.rom.release.transfinite");

		String cacheKey = Constant.DEVICE_SN_ROM + UserUtils.getUser().getId();
		Object deviceSnObj = CacheUtils.get(cacheKey);
		// 1: 按文件SN查找设备 2: 全部设备
		if (deviceSnObj != null) {
			device.setDeviceSnStr(deviceSnObj.toString());
		}

		OsRomInfo osRomInfo = osRomInfoDao.get(device.getId());
		device.setDeviceType(osRomInfo.getOsDeviceType());
		device.setStartHard(osRomInfo.getStartHardShift());
		device.setEndHard(osRomInfo.getEndHardShift());
		// device.setClientIdentification(osRomInfo.getClientIdentification());

		if (StringUtils.isEmpty(device.getDeviceType())) {
			device.setDeviceType(osRomInfo.getOsDeviceType());
		}
		/*
		 * if (StringUtils.isEmpty(device.getClientIdentification())) {
		 * device.setClientIdentification(osRomInfo.getClientIdentification());
		 * }
		 */

		// 查找设备
		List<Device> devices = deviceDao.findNormalNoRomDeviceList(device);
		// 如果发布数量大于1000 ，使用策略
		if (devices.size() >= 1000) {

			if (strategy.getBeginDate() == null || strategy.getEndDate() == null) {
				throw new ServiceException(releaseTransfinite);
			}
			// 总的半个小时数
			long midHourCount = getHourPoor(strategy.getEndDate(), strategy.getBeginDate()) * 2;

			// 每半个小时需要更新的设备数量
			int avgMidHourDeviceCount = devices.size() / (int) (midHourCount);

			useStrategy(devices, device, isJPushMessage, avgMidHourDeviceCount, strategy);
		} else {
			// 不使用策略
			noUseStrategy(devices, device, isJPushMessage, strategy);
		}
		return devices.size();
	}

	/**
	 * 获取DeviceSn缓存
	 * 
	 * @return
	 */
	private Object getCacheDeviceSn() {
		String cacheKey = Constant.DEVICE_SN_ROM + UserUtils.getUser().getId();
		return CacheUtils.get(cacheKey);
	}

	// 保存设置流水发布信息
	@Transactional(readOnly = false)
	public RecordRomInfo saveRecordRomInfo(String osRomInfoId, OsRomInfo romInfo) {
		RecordRomInfo recordRomInfo = new RecordRomInfo();
		recordRomInfo.preInsert(true);
		recordRomInfo.setOsId(new Integer(osRomInfoId));
		recordRomInfo.setOsVersion(romInfo.getOsVersion());
		recordRomInfo.setOsVersionShifter(StringUtil.formatVersion(romInfo.getOsVersion()));
		recordRomInfo.setOsDeviceType(romInfo.getOsDeviceType());
		recordRomInfo.setManufacturerNo(romInfo.getManufacturerNo());
		recordRomInfo.setOsDeviceType(romInfo.getOsDeviceType());
		if (getCacheDeviceSn() != null) {
			recordRomInfo.setRemarks("按照文件上传SN信息发布");
		} else {
			recordRomInfo.setRemarks("查找所有设备信息发布");
		}
		recordRomInfoDao.insert(recordRomInfo);
		return recordRomInfo;
	}

	// 获取推送内容
	private String getJPushDes(String isJPushMessage) {
		String jgPushDes = "";
		if ("1".equals(isJPushMessage)) {
			jgPushDes = "设备更新";
		}
		return jgPushDes;
	}

	// 设置RomDevice信息 // 1.版本设备发布记录
	private RomDevice getRomDevice(Device device, RomDevice romDevice) {

		romDevice.setDeviceId(new Integer(device.getId()));
		romDevice.setDeviceVersion(device.getDeviceOsVersion());
		return romDevice;
	}

	// 加入缓存和推送消息
	private void cacheAndPush(List<Device> devices, String jgPushDes, String isJPushMessage) {
		addCache(devices);
		// 0:被动发布 1:主动发布
		if ("1".equals(isJPushMessage)) {
			RemotePushUtils.batchPush(devices, ControlCommand.SYSTEM_UPGRADE, jgPushDes);
		}
	}

	/**
	 * 初始化RomDevie变量
	 * 
	 * @param osRomInfoId
	 * @param json
	 * @param recordRomInfoId
	 * @return
	 */
	private RomDevice initRomDevice(OsRomInfo romInfo, String recordRomInfoId, JSONObject json, String isJPushMessage) {
		RomDevice romDevice = new RomDevice();
		romDevice.preInsert(true);
		// device 的id就是OSRom的id存储的
		romDevice.setOsId(new Integer(romInfo.getId()));
		romDevice.setOsVersionShifter(StringUtil.formatVersion(romInfo.getOsVersion()));
		// 不使用策略的情况 保存策略
		if (json != null) {
			romDevice.setStrategyDesc(json.toString());
		}
		romDevice.setUpgradeType(isJPushMessage);
		romDevice.setRecordRomId(new Integer(recordRomInfoId));
		return romDevice;
	}

	/**
	 * 初始化
	 * 
	 * @param osRomInfoId
	 * @param jPushDes
	 * @return
	 */
	private PushRec initPushRec(String osRomInfoId, String jgPushDes) {
		PushRec pushRec = new PushRec();
		pushRec.preInsert(true);
		pushRec.setOsId(osRomInfoId);
		pushRec.setMessageContent(jgPushDes);
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
	@Transactional(readOnly = false)
	public void batchInsertPushRec(List<PushRec> pushRecs) {
		pushRecDao.insertList(pushRecs);
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
			Strategy strategy) {
		// device 的id就是OSRom的id
		String osRomInfoId = device.getId();
		if (devices != null && !devices.isEmpty()) {

			release(devices, osRomInfoId, strategy, isJPushMessage, avgMidHourDeviceCount);
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
	private void noUseStrategy(List<Device> devices, Device device, String isJPushMessage, Strategy strategy) {
		// device 的id就是OSRom的id
		String osRomInfoId = device.getId();
		if (devices != null && !devices.isEmpty()) {
			release(devices, osRomInfoId, strategy, isJPushMessage, 0);
		}
	}

	// 当前页和点选id
	public Integer saveRomDevice(String romId, String ids, String isJPushMessage, Strategy strategy) {

		List<Integer> idList = new ArrayList<>();
		List<Device> devices = new ArrayList<>();
		String[] idArray = ids.split(",");
		if (idArray != null && idArray.length > 0) {
			for (int i = 0; i < idArray.length; i++) {
				idList.add(new Integer(idArray[i]));
			}
			devices = deviceDao.findDeviceListByIds(idList);
			release(devices, romId, strategy, isJPushMessage, 0);
		}
		return devices.size();
	}

	/**
	 * 发布整理数据
	 * 
	 * @param devices
	 * @param romId
	 * @param strategy
	 * @param isJPushMessage
	 * @throws Exception
	 */
	private void release(List<Device> devices, String romId, Strategy strategy, String isJPushMessage,
			Integer avgMidHourDeviceCount) {

		String jgPushDes = getJPushDes(isJPushMessage);
		// 将字符串变成json对象

		JSONObject json = getJsonObject(strategy);

		OsRomInfo romInfo = osRomInfoDao.get(romId);
		// 保存流水发布信息
		RecordRomInfo recordRomInfo = saveRecordRomInfo(romId, romInfo);

		List<RomDevice> romDevices = new ArrayList<>();
		List<PushRec> pushRecs = new ArrayList<>();
		for (Device device : devices) {
			// 初始化
			RomDevice initRomDevice = initRomDevice(romInfo, recordRomInfo.getId(), json, isJPushMessage);
			// 保存发布设备记录
			romDevices.add(getRomDevice(device, initRomDevice));
			// 2.发送消息发布记录
			// 0:被动发布 1:主动发布
			if ("1".equals(isJPushMessage)) {
				PushRec pushRec = initPushRec(romId, jgPushDes);
				pushRec.setDeviceId(device.getId());
				pushRecs.add(pushRec);
			}
		}
		// 批量保存
		if (!"a".equals(strategy.getId()) && romDevices.size() > 1000) {
			saveRomDeviceListMap(romDevices, strategy, avgMidHourDeviceCount);
		} else {
			saveRomDevices(romDevices);
		}
		// 0:被动发布 1:主动发布
		if ("1".equals(isJPushMessage)) {
			batchInsertPushRec(pushRecs);
		}
		// 加入缓存和推送
		cacheAndPush(devices, jgPushDes, isJPushMessage);
	}

	/**
	 * 全量处理相关数据缓存
	 * 
	 * @param devices
	 */
	public void addCache(List<Device> devices) {
		if (devices != null) {
			for (Device device : devices) {
				getCheckVersion(device);
			}
		}
	}

	/**
	 * 获取需要缓存数据库版本
	 * 
	 * @param device
	 * @return
	 */
	private List<DeviceOsInfoDto> getCheckVersion(Device device) {
		DeviceOsInfoDto dto = new DeviceOsInfoDto();
		dto.setDeviceSn(device.getDeviceSn());
		String catchKey = device.getManufacturerNo() + device.getDeviceType() + device.getDeviceSn();
		List<DeviceOsInfoDto> result = deviceOsInfoDao.getCheckVersion(dto);
		cacheRemove(catchKey);
		cachePut(catchKey, result);
		return result;
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

}
