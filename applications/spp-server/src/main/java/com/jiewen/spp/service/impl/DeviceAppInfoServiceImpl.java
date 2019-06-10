
package com.jiewen.spp.service.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang3.ObjectUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSONObject;
import com.jiewen.base.core.AbstractService;
import com.jiewen.base.excetion.OTAExcetion;
import com.jiewen.commons.util.DateTimeUtil;
import com.jiewen.spp.dao.AppUpgradeRecordMapper;
import com.jiewen.spp.dao.DeviceAppInfoMapper;
import com.jiewen.spp.dto.DeviceAppInfoDto;
import com.jiewen.spp.model.AppUpgradeRecord;
import com.jiewen.spp.model.DeviceInfo;
import com.jiewen.spp.service.DeviceAppInfoService;
import com.jiewen.spp.wrapper.AppListParamsWrapper;
import com.jiewen.spp.wrapper.AppParamsWrapper;
import com.jiewen.utils.RspCode;
import com.jiewen.utils.RspJsonNode;
import com.jiewen.utils.StringUtil;

/**
 * 单个设备app升级Controller
 * 
 * @author Administrator
 *
 */
@Service
public class DeviceAppInfoServiceImpl extends AbstractService<DeviceInfo> implements DeviceAppInfoService {

	@Value("${http.download.path}")
	protected String prefxiDownloadPath;

	@Autowired
	private DeviceAppInfoMapper deviceAppInfoMapper;

	@Autowired
	private DeviceInfoServiceImpl deviceInfoService;

	@Resource
	private AppUpgradeRecordMapper appUpgradeRecordMapper;

	/**
	 * 批量检查app版本信息
	 */
	@Override
	public List<JSONObject> getCheckAppVersionList(AppListParamsWrapper appListParamsWrapper) {

		List<JSONObject> appJsonList = new ArrayList<>();
		List<AppParamsWrapper> appList = appListParamsWrapper.getAppList();
		for (int i = 0; i < appList.size(); i++) {
			AppParamsWrapper appParamsWrapper = appList.get(i);
			appParamsWrapper.setManufacturer(appListParamsWrapper.getManufacturer());
			appParamsWrapper.setSn(appListParamsWrapper.getSn());
			appParamsWrapper.setVersion(appListParamsWrapper.getVersion());
			appParamsWrapper.setDeviceType(appListParamsWrapper.getDeviceType());

			DeviceAppInfoDto deviceAppInfoDto = getCheckAppVersion(appParamsWrapper);
			JSONObject respJson = new JSONObject();
			if (deviceAppInfoDto == null) {
				/*
				 * respJson.put(RspJsonNode.IS_UPGRADE, "0");
				 * respJson.put(RspJsonNode.APP_PACKAGE,
				 * appParamsWrapper.getAppPackage());
				 */
			} else {
				// 插入更新交易流水
				recordUpgradeInfo(deviceAppInfoDto);

				respJson.put(RspJsonNode.IS_UPGRADE, "1");
				respJson.put(RspJsonNode.CHECK_HASH, deviceAppInfoDto.getAppMd5());
				respJson.put(RspJsonNode.NEW_VERSION, deviceAppInfoDto.getAppVersion());
				respJson.put(RspJsonNode.APP_PACKAGE, deviceAppInfoDto.getAppPackage());
				respJson.put(RspJsonNode.DES, deviceAppInfoDto.getAppDescription());
				respJson.put(RspJsonNode.UPGRADEMODE, deviceAppInfoDto.getUpgradeMode());
				respJson.put(RspJsonNode.DOWNLOAD_PATH,
						/*
						 * prefxiDownloadPath + File.separator + "appfiles" +
						 * File.separator +
						 */deviceAppInfoDto.getAppFile());

				respJson.put(RspJsonNode.APP_ID, deviceAppInfoDto.getId());
				respJson.put(RspJsonNode.APP_NAME, deviceAppInfoDto.getAppName());
				respJson.put(RspJsonNode.APP_DESC, deviceAppInfoDto.getAppDescription());
				respJson.put(RspJsonNode.APP_TYPE, deviceAppInfoDto.getCategory());
				respJson.put(RspJsonNode.APP_PLATFORM, deviceAppInfoDto.getPlatform());
				respJson.put(RspJsonNode.APP_PACKAGE_NAME,
						deviceAppInfoDto.getAppFile().split("/")[deviceAppInfoDto.getAppFile().split("/").length - 1]);
				respJson.put(RspJsonNode.APP_SIZE, deviceAppInfoDto.getAppFileSize());
				respJson.put(RspJsonNode.APP_LOGO, deviceAppInfoDto.getAppLogo());
				respJson.put(RspJsonNode.APP_IMG, deviceAppInfoDto.getAppImg());
				respJson.put(RspJsonNode.VERSION_CODE, deviceAppInfoDto.getAppVersionNumber());
				JSONObject strategy = JSONObject.parseObject(deviceAppInfoDto.getStrategyDesc());
				strategy.put(RspJsonNode.UPGRADE_TYPE, deviceAppInfoDto.getUpgradeDesc());
				respJson.put(RspJsonNode.STRATEGY, strategy);
				appJsonList.add(respJson);
			}
		}
		return appJsonList;
	}

	/**
	 * 单个检查app版本信息
	 */
	@Override
	public DeviceAppInfoDto getCheckAppVersion(AppParamsWrapper params) {
		DeviceInfo deviceInfo = new DeviceInfo();
		deviceInfo.setDeviceSn(params.getSn());
		deviceInfo.setManufacturerNo(params.getManufacturer());
		deviceInfo.setDeviceType(params.getDeviceType());
		deviceInfo = deviceInfoService.selectBySn(deviceInfo);
		if (deviceInfo == null) {
			throw new OTAExcetion(RspCode.NO_DEVICE_ERROR, "该设备信息不存在");
		}
		DeviceAppInfoDto dto = new DeviceAppInfoDto();
		dto.setVersion(params.getVersion());
		dto.setManufacturerNo(params.getManufacturer());
		dto.setDeviceSn(params.getSn());
		dto.setDeviceType(params.getDeviceType());
		dto.setAppVersion(params.getAppVersion());
		dto.setAppPackage(params.getAppPackage());
		dto.setOrganId(deviceInfo.getOrganId());
		return getAppInfo(dto);
	}

	/**
	 * 检出是否有需要升级版本信息
	 * 
	 * @param dto
	 * @return
	 */
	public DeviceAppInfoDto getAppInfo(DeviceAppInfoDto dto) {
		return getDefaultSource(dto);
		/*
		 * if (StringUtils.isBlank(dto.getSourceId())) { return
		 * getDefaultSource(dto); } else { return getNoneDefaultSource(dto); }
		 */

	}

	/**
	 * 根据数据判断程序中是否存在相关整包， 如果存在整包 优先下载版本最大的整包
	 * 
	 * @param list
	 * @return
	 */
	public DeviceAppInfoDto checkPackeType(List<DeviceAppInfoDto> list, DeviceAppInfoDto dto) {
		List<DeviceAppInfoDto> wholePackets = new ArrayList<>();
		DeviceAppInfoDto result = null;
		for (DeviceAppInfoDto deviceAppInfoDto : list) {
			if (StringUtil.compareVersion(String.valueOf(deviceAppInfoDto.getAppVersionNumber()),
					dto.getAppVersion()) >= 0) {
				wholePackets.add(deviceAppInfoDto);
			}
		}

		if (!wholePackets.isEmpty()) {
			Collections.sort(wholePackets);
			result = wholePackets.get(wholePackets.size() - 1);
		}
		return result;
	}

	/**
	 * 0-版本号相同 小于 0 本地版本小 大于本地版本
	 * 
	 * @param deviceInfo
	 * @param deviceOsInfoDto
	 * @return
	 */
	public int valitionVersion(DeviceInfo deviceInfo, AppParamsWrapper params) {
		if (ObjectUtils.allNotNull(deviceInfo, params)) {
			return StringUtil.compareVersion(deviceInfo.getDeviceOsVersion(), params.getAppVersion());
		} else {
			return 0;
		}
	}

	/**
	 * 默认来源App信息
	 * 
	 * @param dto
	 * @return
	 */
	public DeviceAppInfoDto getDefaultSource(DeviceAppInfoDto dto) {
		DeviceAppInfoDto appDto = null;
		List<DeviceAppInfoDto> result = clientIdApk(dto);

		appDto = checkPackeType(result, dto);
		return appDto;
	}

	private List<DeviceAppInfoDto> clientIdApk(DeviceAppInfoDto dto) {
		String chcheKey = "APP" + dto.getManufacturerNo() + dto.getDeviceType() + dto.getDeviceSn() + dto.getOrganId()
				+ dto.getAppPackage();

		List<DeviceAppInfoDto> result = cast(redisOpt().get(chcheKey));
		if (result == null || result.isEmpty()) {
			try {
				result = deviceAppInfoMapper.getCheckAppVersion(dto);
				if (result != null && !result.isEmpty()) {
					redisOpt().set(chcheKey, result);
				}

			} catch (Exception e) {
				logger.error(e.getMessage());
				throw new OTAExcetion(RspCode.SYSTEM_ERROR, "系统错误,前联系服务商!");
			}

		}
		return result;
	}

	/**
	 * 非默认来源App信息
	 * 
	 * @param dto
	 * @return
	 */
	public DeviceAppInfoDto getNoneDefaultSource(DeviceAppInfoDto dto) {
		String chcheKey = "APP" + dto.getSourceId() + dto.getAppPackage();
		DeviceAppInfoDto appDto = null;
		List<DeviceAppInfoDto> result = cast(redisOpt().get(chcheKey));
		if (result == null || result.isEmpty()) {
			try {
				result = deviceAppInfoMapper.getNoDefaultSysAppVersion(dto);
				if (result != null && !result.isEmpty()) {
					redisOpt().set(chcheKey, result);
				}

			} catch (Exception e) {
				logger.error(e.getMessage());
				throw new OTAExcetion(RspCode.SYSTEM_ERROR, "系统错误,前联系服务商!");
			}

		}
		if (result != null && !result.isEmpty()) {
			appDto = checkPackeType(result, dto);
		}
		return appDto;
	}

	// 记录更新流水
	public void recordUpgradeInfo(DeviceAppInfoDto deviceAppInfoDto) {
		AppUpgradeRecord record = new AppUpgradeRecord();
		record.setDeviceSn(deviceAppInfoDto.getDeviceSn());
		record.setAppId(deviceAppInfoDto.getId());
		record.setAppName(deviceAppInfoDto.getAppName());
		record.setAppPackage(deviceAppInfoDto.getAppPackage());
		record.setAppVersion(deviceAppInfoDto.getAppVersion());
		record.setAppFilePath(/*
								 * prefxiDownloadPath + File.separator +
								 * "appfiles" + File.separator +
								 */deviceAppInfoDto.getAppFile());
		record.setAppFileName(deviceAppInfoDto.getAppFile());
		record.setAppFileSize(deviceAppInfoDto.getAppFileSize());
		String currentDate = DateTimeUtil.getSystemDateTime("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		try {
			record.setUpgradeDate(sdf.parse(currentDate));
		} catch (ParseException e) {
			logger.error(e.getMessage());
			throw new OTAExcetion(RspCode.SYSTEM_ERROR, "系统错误,前联系服务商!");
		}
		record.setRemarks(deviceAppInfoDto.getAppName() + "更新");
		record.setOrganId(deviceAppInfoDto.getOrganId());

		appUpgradeRecordMapper.insertSelective(record);
	}

}
