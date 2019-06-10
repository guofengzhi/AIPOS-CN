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
import com.jiewen.spp.dto.DeviceAppInfoDto;
import com.jiewen.spp.service.impl.DeviceAppInfoServiceImpl;
import com.jiewen.spp.wrapper.AppParamsWrapper;
import com.jiewen.utils.RspCode;
import com.jiewen.utils.RspJsonNode;

@RestController
public class CheckAppVersionController extends AbstractController {

	@Autowired
	private DeviceAppInfoServiceImpl deviceAppInfoService;

	@JsonApiMethod
	@RequestMapping(value = "/checkAppVersion")
	public @ResponseBody String checkAppVersion(@RequestBody String params) {

		AppParamsWrapper requestWrapper = JSON.parseObject(params, AppParamsWrapper.class);
		if (!validParams(requestWrapper)) {
			return setRspMessage(RspCode.PARAM_ERROR, "参数不能为空", requestWrapper.getSn());
		}

		DeviceAppInfoDto deviceAppInfo = deviceAppInfoService.getCheckAppVersion(requestWrapper);

		JSONObject respJson = setRspJsonCommonObject(requestWrapper);

		if (deviceAppInfo == null) {
			respJson.put(RspJsonNode.IS_UPGRADE, "0");
		} else {
			// 插入更新交易流水
			deviceAppInfoService.recordUpgradeInfo(deviceAppInfo);

			respJson.put(RspJsonNode.IS_UPGRADE, "1");
			respJson.put(RspJsonNode.CHECK_HASH, deviceAppInfo.getAppMd5());
			respJson.put(RspJsonNode.NEW_VERSION, deviceAppInfo.getAppVersion());
			respJson.put(RspJsonNode.APP_PACKAGE, deviceAppInfo.getAppPackage());
			respJson.put(RspJsonNode.DES, deviceAppInfo.getAppDescription());
			respJson.put(RspJsonNode.DOWNLOAD_PATH,
					/*prefxiDownloadPath + File.separator + "appfiles" + File.separator + */deviceAppInfo.getAppFile());

			JSONObject strategy = JSONObject.parseObject(deviceAppInfo.getStrategyDesc());
			strategy.put(RspJsonNode.UPGRADE_TYPE, deviceAppInfo.getUpgradeDesc());
			respJson.put(RspJsonNode.STRATEGY, strategy.toJSONString());
		}
		return respJson.toJSONString();
	}

	/**
	 * 返回报文
	 * 
	 * @param requestWrapper
	 * @return
	 */
	private JSONObject setRspJsonCommonObject(AppParamsWrapper requestWrapper) {
		JSONObject rspBody = new JSONObject();
		rspBody.put(RspJsonNode.VERSION, requestWrapper.getVersion());
		rspBody.put(RspJsonNode.DEVICE_TYPE, requestWrapper.getDeviceType());
		rspBody.put(RspJsonNode.MANUFACTURER, requestWrapper.getManufacturer());
		rspBody.put(RspJsonNode.SN, requestWrapper.getSn());
		rspBody.put(RspJsonNode.RESP_CODE, "00");
		rspBody.put(RspJsonNode.APP_PACKAGE, requestWrapper.getAppPackage());
		return rspBody;
	}

	private boolean validParams(AppParamsWrapper params) {
		if (StringUtils.isNotBlank(params.getSourceId())) {
			if (StringUtils.isBlank(params.getSn()) || StringUtils.isBlank(params.getAppPackage())
					|| StringUtils.isBlank(params.getAppVersion())) {
				logger.debug("参数不能为空");
				return false;
			} else {
				return true;
			}
		}
		if (StringUtils.isBlank(params.getSn()) || StringUtils.isBlank(params.getDeviceType())
				|| StringUtils.isBlank(params.getVersion()) || StringUtils.isBlank(params.getManufacturer())
				|| StringUtils.isBlank(params.getAppPackage()) || StringUtils.isBlank(params.getAppVersion())) {
			logger.debug("参数不能为空");
			return false;
		} else {
			return true;
		}
	}

}
