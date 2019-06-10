package com.jiewen.spp.web;

import java.util.Random;

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
import com.jiewen.commons.util.DateTimeUtil;
import com.jiewen.spp.model.DeviceInfo;
import com.jiewen.spp.model.DeviceLogin;
import com.jiewen.spp.service.impl.DeviceInfoServiceImpl;
import com.jiewen.spp.service.impl.DeviceLoginServiceImpl;
import com.jiewen.spp.wrapper.LogonInWrapper;
import com.jiewen.utils.RspCode;
import com.jiewen.utils.RspJsonNode;

@RestController
public class LogonInController extends AbstractController {

	@Autowired
	private DeviceInfoServiceImpl deviceInfoService;

	@Autowired
	private DeviceLoginServiceImpl deviceLoginService;

	@JsonApiMethod
	@RequestMapping(value = "/logonIn")
	public @ResponseBody String recDirectory(@RequestBody String params) {
		LogonInWrapper requestWrapper = JSON.parseObject(params, LogonInWrapper.class);
		if (!validParams(requestWrapper)) {
			return setRspMessage(RspCode.PARAM_ERROR, "参数不能为空", requestWrapper.getSn());
		}
		DeviceInfo record = new DeviceInfo();
		record.setDeviceSn(requestWrapper.getSn());
		DeviceInfo deviceInfo = deviceInfoService.selectBySn(record);
		if (deviceInfo == null) {
			return setRspMessage(RspCode.NO_DEVICE_ERROR, "设备信息不存在", requestWrapper.getSn());
		}

		JSONObject respJson = setRspJsonCommonObject(requestWrapper);

		// 生成随机数作为token
		Random r = new Random();
		String dateTime = DateTimeUtil.getSystemDateTime("ss");
		String token = deviceInfo.getDeviceSn() + dateTime + r.nextInt(999999);

		DeviceLogin devicelogin = new DeviceLogin();
		devicelogin.setDeviceSn(deviceInfo.getDeviceSn());
		deviceLoginService.RecordDevicelogonInfo(devicelogin, token);

		respJson.put(RspJsonNode.TOKEN, token);
		respJson.put(RspJsonNode.DEVICE_INFO, JSONObject.toJSONString(deviceInfo));

		return respJson.toJSONString();
	}

	/**
	 * 返回报文
	 * 
	 * @param requestWrapper
	 * @return
	 */
	private JSONObject setRspJsonCommonObject(LogonInWrapper requestWrapper) {
		JSONObject rspBody = new JSONObject();
		rspBody.put(RspJsonNode.VERSION, requestWrapper.getVersion());
		rspBody.put(RspJsonNode.DEVICE_TYPE, requestWrapper.getDeviceType());
		rspBody.put(RspJsonNode.MANUFACTURER, requestWrapper.getManufacturer());
		rspBody.put(RspJsonNode.SN, requestWrapper.getSn());
		rspBody.put(RspJsonNode.RESP_CODE, "00");
		return rspBody;
	}

	private boolean validParams(LogonInWrapper params) {
		if (StringUtils.isBlank(params.getSn()) || StringUtils.isBlank(params.getVersion())) {
			logger.debug("参数不能为空");
			return false;
		} else {
			return true;
		}
	}
}
