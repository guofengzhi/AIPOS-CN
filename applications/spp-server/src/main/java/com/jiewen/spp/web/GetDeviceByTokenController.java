package com.jiewen.spp.web;

import org.apache.commons.lang3.StringUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.jiewen.base.core.AbstractController;
import com.jiewen.commons.toolkit.annotation.JsonApiMethod;
import com.jiewen.spp.model.DeviceInfo;
import com.jiewen.spp.wrapper.GetDeviceByTokenWrapper;
import com.jiewen.utils.RspCode;
import com.jiewen.utils.RspJsonNode;

/**
 * 根据token获取设备信息
 * 
 * @author Pang.M
 *
 */
@RestController
public class GetDeviceByTokenController extends AbstractController {

	@JsonApiMethod
	@RequestMapping(value = "/getByToken")
	public @ResponseBody String getByToken(@RequestBody String params) {

		GetDeviceByTokenWrapper requestWrapper = JSON.parseObject(params, GetDeviceByTokenWrapper.class);
		if (!validParams(requestWrapper)) {
			return setRspMessage(RspCode.PARAM_ERROR, "参数不能为空", requestWrapper.getSn());
		}
		DeviceInfo deviceInfo = new DeviceInfo();
		deviceInfo.setDeviceSn(requestWrapper.getSn());
		deviceInfo.setManufacturerNo(requestWrapper.getManufacturer());
		deviceInfo.setDeviceType(requestWrapper.getDeviceType());
		deviceInfo = selectDeviceInfo(deviceInfo);
		if (deviceInfo == null) {
			return setRspMessage(RspCode.NO_DEVICE_ERROR, "设备信息不存在", requestWrapper.getSn());
		}
		JSONObject respJson = setRspJsonCommonObject(requestWrapper);
		respJson.put(RspJsonNode.DEVICE_INFO, JSONObject.toJSONString(deviceInfo));
		return respJson.toJSONString();
	}

	/**
	 * 返回报文
	 * 
	 * @param requestWrapper
	 * @return
	 */
	private JSONObject setRspJsonCommonObject(GetDeviceByTokenWrapper requestWrapper) {
		JSONObject rspBody = new JSONObject();
		rspBody.put(RspJsonNode.VERSION, requestWrapper.getVersion());
		rspBody.put(RspJsonNode.DEVICE_TYPE, requestWrapper.getDeviceType());
		rspBody.put(RspJsonNode.MANUFACTURER, requestWrapper.getManufacturer());
		rspBody.put(RspJsonNode.SN, requestWrapper.getSn());
		rspBody.put(RspJsonNode.RESP_CODE, "00");
		return rspBody;
	}

	private boolean validParams(GetDeviceByTokenWrapper params) {
		if (StringUtils.isBlank(params.getSn()) || StringUtils.isBlank(params.getManufacturer())) {
			logger.debug("参数不能为空");
			return false;
		} else {
			return true;
		}
	}
}
