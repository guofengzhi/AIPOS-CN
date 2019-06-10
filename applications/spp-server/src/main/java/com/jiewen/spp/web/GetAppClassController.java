package com.jiewen.spp.web;

import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jiewen.base.core.AbstractController;
import com.jiewen.commons.toolkit.annotation.JsonApiMethod;
import com.jiewen.spp.dao.SysDictMapper;
import com.jiewen.spp.model.DeviceInfo;
import com.jiewen.spp.model.SysDict;
import com.jiewen.spp.wrapper.GetClassWrapper;
import com.jiewen.utils.RspCode;
import com.jiewen.utils.RspJsonNode;

@RestController
public class GetAppClassController extends AbstractController {

	@Resource
	private SysDictMapper sysDictMapper;

	@JsonApiMethod
	@RequestMapping(value = "/getClass")
	public @ResponseBody String getClass(@RequestBody String params) {

		GetClassWrapper requestWrapper = JSON.parseObject(params, GetClassWrapper.class);
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
		setClassRecordToObject(respJson);
		return respJson.toJSONString();
	}

	/**
	 * 返回报文
	 * 
	 * @param requestWrapper
	 * @return
	 */
	private JSONObject setRspJsonCommonObject(GetClassWrapper requestWrapper) {
		JSONObject rspBody = new JSONObject();
		rspBody.put(RspJsonNode.VERSION, requestWrapper.getVersion());
		rspBody.put(RspJsonNode.DEVICE_TYPE, requestWrapper.getDeviceType());
		rspBody.put(RspJsonNode.MANUFACTURER, requestWrapper.getManufacturer());
		rspBody.put(RspJsonNode.SN, requestWrapper.getSn());
		rspBody.put(RspJsonNode.RESP_CODE, "00");
		return rspBody;
	}

	/**
	 * 加入类别记录
	 * 
	 * @param respJson
	 */
	private void setClassRecordToObject(JSONObject respJson) {
		JSONArray jsonArray = new JSONArray();
		List<SysDict> list = sysDictMapper.getClassByType();
		for (SysDict sysDict : list) {
			JSONObject jot = new JSONObject();
			jot.put(RspJsonNode.CLASS_ID, sysDict.getId());
			jot.put(RspJsonNode.CLASS_CODE, sysDict.getValue());
			jot.put(RspJsonNode.CLASS_NAME, sysDict.getLabel());
			jot.put(RspJsonNode.CLASS_DESC, sysDict.getDescription());
			jot.put(RspJsonNode.CLASS_LOGO, "");

			jsonArray.add(jot);
		}
		respJson.put(RspJsonNode.CLASS_LIST, jsonArray.toJSONString());
	}

	private boolean validParams(GetClassWrapper params) {
		if (StringUtils.isBlank(params.getSn()) || StringUtils.isBlank(params.getManufacturer())) {
			logger.debug("参数不能为空");
			return false;
		} else {
			return true;
		}
	}
}
