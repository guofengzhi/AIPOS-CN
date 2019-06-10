package com.jiewen.spp.service.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.ObjectUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jiewen.base.core.AbstractService;
import com.jiewen.base.excetion.OTAExcetion;
import com.jiewen.spp.dao.DeviceInfoMapper;
import com.jiewen.spp.dao.DeviceOsInfoMapper;
import com.jiewen.spp.dto.DeviceOsInfoDto;
import com.jiewen.spp.model.DeviceInfo;
import com.jiewen.spp.service.DeviceInfoService;
import com.jiewen.spp.wrapper.OsParamsWrapper;
import com.jiewen.spp.wrapper.RecDeviceInfoWrapper;
import com.jiewen.utils.RspCode;
import com.jiewen.utils.StringUtil;

/**
 * Created by CodeGenerator on 2017/08/18.
 */
@Service
public class DeviceInfoServiceImpl extends AbstractService<DeviceInfo> implements DeviceInfoService {

	@Autowired
	private DeviceInfoMapper deviceInfoMapper;

	@Autowired
	private DeviceOsInfoMapper deviceOsInfoMapper;

	@Override
	public DeviceOsInfoDto getCheckVersion(OsParamsWrapper params) {
		DeviceOsInfoDto dto = new DeviceOsInfoDto();
		dto.setOsVersion(params.getOsVersion());
		dto.setManufacturerNo(params.getManufacturer());
		dto.setDeviceSn(params.getSn());
		dto.setDeviceType(params.getDeviceType());
		dto.setClientIdentification(params.getBankName());
		dto.setHardWare(StringUtil.formatVersion(params.getHardware()));
		dto = getOsInfo(dto);
		DeviceInfo deviceInfo = new DeviceInfo();
		deviceInfo.setDeviceSn(params.getSn());
		deviceInfo.setManufacturerNo(params.getManufacturer());
		deviceInfo.setDeviceType(params.getDeviceType());
		deviceInfo = selectBySn(deviceInfo);
		if (deviceInfo == null) {
			throw new OTAExcetion(RspCode.NO_DEVICE_ERROR, "该设备信息不存在");
		}
		updateDeviceInfo(params, deviceInfo);
		return dto;

	}

	public DeviceInfo selectBySn(DeviceInfo deviceInfo) {
		DeviceInfo infoDevice = (DeviceInfo) redisOpt()
				.get("deviceInfo_" + deviceInfo.getManufacturerNo() + deviceInfo.getDeviceSn());
		if (infoDevice == null) {
			try {
				infoDevice = deviceInfoMapper.selectOne(deviceInfo);
			} catch (Exception e) {
				logger.error(e.getMessage());
				throw new OTAExcetion(RspCode.SYSTEM_ERROR, "系统错误,前联系服务商!");
			}
			if (infoDevice != null) {
				redisOpt().set("deviceInfo_" + deviceInfo.getManufacturerNo() + deviceInfo.getDeviceSn(), infoDevice);
			}
		}

		return infoDevice;
	}

	/**
	 * 更新关于服务端设备信息处理
	 * 
	 * @param params
	 */
	@Transactional
	public void updateDeviceInfo(OsParamsWrapper params, DeviceInfo deviceInfo) {
		int valVersion = valitionVersion(deviceInfo, params);
		if (StringUtils.isBlank(deviceInfo.getDeviceOsVersion())
				|| !StringUtils.equalsIgnoreCase(deviceInfo.getOrganId(), params.getBankName())
				|| StringUtils.equalsIgnoreCase(StringUtil.formatVersion(params.getHardware()),
						deviceInfo.getHardwareShifter())) {
			deviceInfo.setDeviceOsVersion(params.getOsVersion());
			deviceInfo.setOsVersionShifter(StringUtil.formatVersion(params.getOsVersion()));
			deviceInfo.setHardwareVersion(params.getHardware());
			deviceInfo.setHardwareShifter(StringUtil.formatVersion(params.getHardware()));
			deviceInfo.setOrganId(params.getBankName());
			deviceInfo.setDeviceInfo(params.getDeviceInfo().toString());
			deviceInfo.setCreateDate(new Date());
			if (valVersion > 0) {
				deviceInfo.setOsMsg("版本不一致");
			} else {
				deviceInfo.setOsMsg("版本一致更新成功");
			}
			try {
				deviceInfoMapper.updateByPrimaryKeySelective(deviceInfo);
				redisTemplate.delete("deviceInfo_" + deviceInfo.getManufacturerNo() + params.getSn());
			} catch (Exception e) {
				logger.error(e.getMessage());
				throw new OTAExcetion(RspCode.SYSTEM_ERROR, "系统错误,前联系服务商!");
			}

		}

	}

	/**
	 * 检出是否有需要升级版本信息
	 * 
	 * @param dto
	 * @return
	 */
	public DeviceOsInfoDto getOsInfo(DeviceOsInfoDto dto) {
		String chcheKey = dto.getManufacturerNo() + dto.getDeviceType() + dto.getDeviceSn();
		DeviceOsInfoDto osInfoDto = null;
		List<DeviceOsInfoDto> result = cast(redisOpt().get(chcheKey));
		if (result == null || result.isEmpty()) {
			try {
				result = deviceOsInfoMapper.getCheckVersion(dto);
				if (result != null && !result.isEmpty()) {
					redisOpt().set(chcheKey, result);
				}

			} catch (Exception e) {
				logger.error(e.getMessage());
				throw new OTAExcetion(RspCode.SYSTEM_ERROR, "系统错误,前联系服务商!");
			}

		}
		if (result != null && !result.isEmpty()) {
			osInfoDto = checkPacketType(result, dto);
		}
		return osInfoDto;
	}

	/**
	 * 根据数据判断程序中是否存在相关整包，以及差分包。 如果存在整包 优先下载版本最大的整包 如果不存在整包 则使用差分包升级寻找相关依赖中最大版本升级
	 * 
	 * @param list
	 * @return
	 */
	public DeviceOsInfoDto checkPacketType(List<DeviceOsInfoDto> list, DeviceOsInfoDto dto) {
		List<DeviceOsInfoDto> wholePackets = new ArrayList<>();
		List<DeviceOsInfoDto> diffPackets = new ArrayList<>();
		DeviceOsInfoDto result = null;
		for (DeviceOsInfoDto deviceOsInfoDto : list) {
			if (isUpgrade(deviceOsInfoDto, dto)) {
				if (StringUtils.equalsIgnoreCase("0", deviceOsInfoDto.getOsPacketType())) {
					wholePackets.add(deviceOsInfoDto);
				} else {
					diffPackets.add(deviceOsInfoDto);
				}
			}
		}
		DeviceOsInfoDto wholePacket = null;
		DeviceOsInfoDto diffPacket = null;

		if (!wholePackets.isEmpty()) {
			Collections.sort(wholePackets);
			wholePacket = wholePackets.get(wholePackets.size() - 1);
		} else if (!diffPackets.isEmpty()) {
			Collections.sort(diffPackets);
			diffPacket = lookDiffPackt(diffPackets, dto.getOsVersion());
		}
		// 如果整包和差分包都存在需要判断整包和差分包版本进行判断 那个版本大优先推那个
		if (ObjectUtils.allNotNull(wholePacket, diffPacket)) {
			if (wholePacket != null && wholePacket.compareTo(diffPacket) > 0) {
				result = wholePacket;
			} else {
				result = diffPacket;
			}
		} else {
			DeviceOsInfoDto doDto = null;
			doDto = diffPacket != null ? diffPacket : null;
			result = wholePacket != null ? wholePacket : doDto;
		}
		return result;
	}

	/**
	 * 寻找差分包中依赖关系中最大版本升级
	 * 
	 * @param diffList
	 * @return
	 */
	public DeviceOsInfoDto lookDiffPackt(List<DeviceOsInfoDto> diffList, String upOsVersion) {
		DeviceOsInfoDto result = null;
		for (DeviceOsInfoDto d : diffList) {
			if (StringUtil.compareVersion(upOsVersion, d.getOsStart()) >= 0) {
				result = d;
			}
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
	public int valitionVersion(DeviceInfo deviceInfo, OsParamsWrapper params) {
		if (ObjectUtils.allNotNull(deviceInfo, params)) {
			if (StringUtils.isBlank(deviceInfo.getDeviceOsVersion())) {
				return 1;
			}
			return StringUtil.compareVersion(deviceInfo.getDeviceOsVersion(), params.getOsVersion());
		} else {
			return 0;
		}
	}

	@Override
	public void recDeviceInfo(RecDeviceInfoWrapper recDeviceInfoWrapper) {
		DeviceInfo deviceInfo = new DeviceInfo();
		deviceInfo.setDeviceSn(recDeviceInfoWrapper.getSn());
		deviceInfo.setManufacturerNo(recDeviceInfoWrapper.getManufacturer());
		deviceInfo.setDeviceType(recDeviceInfoWrapper.getDeviceType());
		deviceInfo = selectBySn(deviceInfo);

		if (deviceInfo != null) {
			deviceInfo.setAppInfo(recDeviceInfoWrapper.getAppList());
			deviceInfo.setDeviceInfo(recDeviceInfoWrapper.getDeviceInfo());
			deviceInfo.setLocation(recDeviceInfoWrapper.getLocation());
			deviceInfo.setHardwareVersion(recDeviceInfoWrapper.getHardware());
			deviceInfo.setHardwareShifter(StringUtil.formatVersion(recDeviceInfoWrapper.getHardware()));
		} else {
			throw new OTAExcetion(RspCode.PARAM_ERROR, "设备信息不存在！");
		}
		try {
			deviceInfoMapper.updateByPrimaryKeySelective(deviceInfo);
			redisTemplate.delete("deviceInfo_" + deviceInfo.getManufacturerNo() + recDeviceInfoWrapper.getSn());
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw new OTAExcetion(RspCode.SYSTEM_ERROR, "系统错误,前联系服务商!");
		}

	}

	/**
	 * 判断是否能够进行升级数据 包含 版本号比较 系统版本（icbc等） 硬件版本号比较
	 * 
	 * @param listDto
	 * @param dto
	 * @return
	 */
	private boolean isUpgrade(DeviceOsInfoDto listDto, DeviceOsInfoDto dto) {
		boolean result = false;
		if (StringUtil.compareVersion(listDto.getOsVersion(), dto.getOsVersion()) > 0
				&& StringUtils.containsIgnoreCase(listDto.getClientIdentification(), dto.getClientIdentification())) {
			if (StringUtils.isNoneEmpty(listDto.getStartHardShift(), listDto.getEndHardShift())) {
				if (StringUtils.compare(listDto.getStartHardShift(), dto.getHardWare()) <= 0
						&& StringUtils.compare(listDto.getEndHardShift(), dto.getHardWare()) >= 0) {
					result = true;
				}
			} else {
				result = true;
			}
		}
		return result;
	}
	
	@Override
	public DeviceInfo getBySn(String termSn) {
		DeviceInfo deviceInfo = new DeviceInfo();
		deviceInfo.setDeviceSn(termSn);
		return deviceInfoMapper.get(deviceInfo);
	}

	public void updateJwd(DeviceInfo deviceInfo) {
		deviceInfoMapper.updateJwd(deviceInfo);
	}

}
