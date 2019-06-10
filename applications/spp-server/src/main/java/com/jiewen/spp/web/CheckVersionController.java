package com.jiewen.spp.web;

import java.io.File;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.jiewen.base.core.AbstractController;
import com.jiewen.commons.toolkit.annotation.JsonApiMethod;
import com.jiewen.constant.ControlCommand;
import com.jiewen.spp.dto.DeviceOsInfoDto;
import com.jiewen.spp.service.impl.DeviceInfoServiceImpl;
import com.jiewen.spp.wrapper.OsParamsWrapper;
import com.jiewen.utils.RspCode;
import com.jiewen.utils.RspJsonNode;
import com.jiewen.utils.StringUtil;

@RestController
public class CheckVersionController extends AbstractController {

	@Autowired
	private DeviceInfoServiceImpl deviceInfoService;

	@JsonApiMethod
	@RequestMapping(value = "/checkVersion")
	public @ResponseBody String checkOsVersion(@RequestBody String params) {

		OsParamsWrapper requestWrapper = JSON.parseObject(params, OsParamsWrapper.class);
		requestWrapper.setPacket(params);
		if (!validParams(requestWrapper)) {
			return setRspMessage(RspCode.PARAM_ERROR, "参数不能为空", requestWrapper.getSn());
		}

		DeviceOsInfoDto deviceInfo = deviceInfoService.getCheckVersion(requestWrapper);

		JSONObject respJson = setRspJsonCommonObject(requestWrapper);

		if (deviceInfo == null) {
			respJson.put(RspJsonNode.IS_UPGRADE, ControlCommand.Upgrade.UPGRADE_NO);
		} else {
			respJson.put(RspJsonNode.IS_UPGRADE, ControlCommand.Upgrade.UPGRADE_YES);
			respJson.put(RspJsonNode.CHECK_HASH, deviceInfo.getRomHash());
			respJson.put(RspJsonNode.DOWNLOAD_PATH,/* prefxiDownloadPath + File.separator + */deviceInfo.getRomPath());
			respJson.put(RspJsonNode.NEWOSVERSION, deviceInfo.getOsVersion());
			if (!StringUtil.isEmpty(deviceInfo.getStrategy())) {
				respJson.put(RspJsonNode.STRATEGY, deviceInfo.getStrategy());
			}
			if (!StringUtils.isBlank(deviceInfo.getDescription())) {
				respJson.put(RspJsonNode.DES, deviceInfo.getDescription());
			}
		}
		return respJson.toJSONString();
	}

	/**
	 * 返回报文
	 * 
	 * @param requestWrapper
	 * @return
	 */
	private JSONObject setRspJsonCommonObject(OsParamsWrapper requestWrapper) {
		JSONObject rspBody = new JSONObject();
		rspBody.put(RspJsonNode.VERSION, requestWrapper.getVersion());
		rspBody.put(RspJsonNode.DEVICE_TYPE, requestWrapper.getDeviceType());
		rspBody.put(RspJsonNode.MANUFACTURER, requestWrapper.getManufacturer());
		rspBody.put(RspJsonNode.SN, requestWrapper.getSn());
		rspBody.put(RspJsonNode.RESP_CODE, "00");
		return rspBody;
	}

	private boolean validParams(OsParamsWrapper params) {
		if (StringUtils.isBlank(params.getSn()) || StringUtils.isBlank(params.getDeviceType())
				|| StringUtils.isBlank(params.getOsVersion()) || StringUtils.isBlank(params.getManufacturer())) {
			logger.debug("参数不能为空");
			return false;
		} else {
			return true;
		}
	}

}
