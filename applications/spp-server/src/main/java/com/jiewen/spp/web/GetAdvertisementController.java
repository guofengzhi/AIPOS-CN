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
import com.jiewen.spp.model.Advertisement;
import com.jiewen.spp.model.DeviceInfo;
import com.jiewen.spp.service.impl.GetAdvertisementServiceImpl;
import com.jiewen.spp.wrapper.GetAdvertisementWrapper;
import com.jiewen.utils.RspCode;
import com.jiewen.utils.RspJsonNode;

/**
 * 获取广告
 * 
 * @author Pang.M
 *
 */
@RestController
public class GetAdvertisementController extends AbstractController {

	@Autowired
	private GetAdvertisementServiceImpl getAdvertisementService;

	@JsonApiMethod
	@RequestMapping(value = "/getAdvertisement")
	public @ResponseBody String getAdvertisement(@RequestBody String params) {

		GetAdvertisementWrapper requestWrapper = JSON.parseObject(params, GetAdvertisementWrapper.class);
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
		List<Advertisement> list = getAdvertisementService.getAdvertisement(requestWrapper, deviceInfo);
		JSONObject respJson = setRspJsonCommonObject(requestWrapper);
		setAdvertismentJSON(respJson, list);
		return respJson.toJSONString();
	}

	/**
	 * 返回报文
	 * 
	 * @param requestWrapper
	 * @return
	 */
	private JSONObject setRspJsonCommonObject(GetAdvertisementWrapper requestWrapper) {
		JSONObject rspBody = new JSONObject();
		rspBody.put(RspJsonNode.VERSION, requestWrapper.getVersion());
		rspBody.put(RspJsonNode.DEVICE_TYPE, requestWrapper.getDeviceType());
		rspBody.put(RspJsonNode.MANUFACTURER, requestWrapper.getManufacturer());
		rspBody.put(RspJsonNode.SN, requestWrapper.getSn());
		rspBody.put(RspJsonNode.RESP_CODE, "00");
		return rspBody;
	}

	private boolean validParams(GetAdvertisementWrapper params) {
		if (StringUtils.isBlank(params.getManufacturer()) || StringUtils.isBlank(params.getSn())
				|| StringUtils.isBlank(params.getPage()) || StringUtils.isBlank(params.getPageSize())) {
			logger.debug("参数不能为空");
			return false;
		} else {
			return true;
		}
	}

	private void setAdvertismentJSON(JSONObject respJson, List<Advertisement> list) {
		JSONArray array = new JSONArray();
		for (Advertisement advertisement : list) {
			JSONObject jot = new JSONObject();
			jot.put(RspJsonNode.AD_ID, advertisement.getAdId());
			jot.put(RspJsonNode.AD_NAME, advertisement.getAdName());
			jot.put(RspJsonNode.AD_TITIE, advertisement.getAdTitle());
			jot.put(RspJsonNode.AD_TYPE, advertisement.getAdType());
			jot.put(RspJsonNode.AD_DESC, advertisement.getAdDesc());
			jot.put(RspJsonNode.AD_MANUFACTURERS, advertisement.getAdManufacturers());
			jot.put(RspJsonNode.AD_IMG, advertisement.getAdImg());
			jot.put(RspJsonNode.AD_START_TIME, advertisement.getAdStartTime());
			jot.put(RspJsonNode.AD_END_TIME, advertisement.getAdEndTime());

			array.add(jot);
		}

		respJson.put(RspJsonNode.ADVERTISEMENT_LIST, array.toJSONString());
	}
}
