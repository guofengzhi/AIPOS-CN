package com.jiewen.spp.web;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jiewen.base.core.AbstractController;
import com.jiewen.commons.toolkit.annotation.JsonApiMethod;
import com.jiewen.spp.model.AppSearchLog;
import com.jiewen.spp.model.DeviceInfo;
import com.jiewen.spp.service.impl.AppSearchLogServiceImpl;
import com.jiewen.spp.wrapper.TopSearchWrapper;
import com.jiewen.utils.RspCode;
import com.jiewen.utils.RspJsonNode;

/**
 * 热门搜索
 * 
 * @author Pang.M
 *
 */
@RestController
public class TopSearchController extends AbstractController {

	@Autowired
	private AppSearchLogServiceImpl appSearchLogService;

	@JsonApiMethod
	@RequestMapping(value = "/topSearch")
	public @ResponseBody String getTopSearch(@RequestBody String params) {

		TopSearchWrapper requestWrapper = JSON.parseObject(params, TopSearchWrapper.class);
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

		List<AppSearchLog> list = appSearchLogService.getTopSearchList(requestWrapper, deviceInfo);
		JSONObject respJson = setRspJsonCommonObject(requestWrapper);
		setTopSearchJSON(respJson, list);
		return respJson.toJSONString();
	}

	/**
	 * 返回报文
	 * 
	 * @param requestWrapper
	 * @return
	 */
	private JSONObject setRspJsonCommonObject(TopSearchWrapper requestWrapper) {
		JSONObject rspBody = new JSONObject();
		rspBody.put(RspJsonNode.VERSION, requestWrapper.getVersion());
		rspBody.put(RspJsonNode.DEVICE_TYPE, requestWrapper.getDeviceType());
		rspBody.put(RspJsonNode.MANUFACTURER, requestWrapper.getManufacturer());
		rspBody.put(RspJsonNode.SN, requestWrapper.getSn());
		rspBody.put(RspJsonNode.RESP_CODE, "00");
		return rspBody;
	}

	private boolean validParams(TopSearchWrapper params) {
		if (StringUtils.isBlank(params.getManufacturer()) || StringUtils.isBlank(params.getSn())
				|| StringUtils.isBlank(params.getPage()) || StringUtils.isBlank(params.getPageSize())) {
			logger.debug("参数不能为空");
			return false;
		} else {
			return true;
		}
	}

	private void setTopSearchJSON(JSONObject respJson, List<AppSearchLog> list) {
		JSONArray array = new JSONArray();
		for (AppSearchLog appSearchLog : list) {
			JSONObject jot = new JSONObject();
			jot.put(RspJsonNode.RANK, appSearchLog.getRowNum());
			jot.put(RspJsonNode.KEY_WORD, appSearchLog.getAppName());
			jot.put(RspJsonNode.COUNTS, appSearchLog.getCounts());
			array.add(jot);
		}

		respJson.put(RspJsonNode.SEARCH_LIST, array.toJSONString());
	}
}
