package com.jiewen.spp.web;

import java.util.List;

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
import com.jiewen.spp.service.impl.DeviceAppInfoServiceImpl;
import com.jiewen.spp.wrapper.AppListParamsWrapper;
import com.jiewen.utils.RspCode;
import com.jiewen.utils.RspJsonNode;

@RestController
public class BatchCheckAppVersionController extends AbstractController {

	@Autowired
	private DeviceAppInfoServiceImpl deviceAppInfoService;

	@JsonApiMethod
	@RequestMapping(value = "/batchCheckAppVersion")
	public @ResponseBody String checkAppVersion(@RequestBody String params) {
		AppListParamsWrapper requestWrapper = JSON.parseObject(params, AppListParamsWrapper.class);
		if (!validParams(requestWrapper)) {
			return setRspMessage(RspCode.PARAM_ERROR, "参数不能为空", requestWrapper.getSn());
		}

		List<JSONObject> jSONObjectList = deviceAppInfoService.getCheckAppVersionList(requestWrapper);
		JSONObject respJsonCommon = setRspJsonCommonObject(requestWrapper);
		if(jSONObjectList!=null&&jSONObjectList.size()>0){
			respJsonCommon.put("appUpgradeList", jSONObjectList);
		}
		return respJsonCommon.toJSONString();
	}

	/**
	 * 返回报文
	 * 
	 * @param requestWrapper
	 * @return
	 */
	private JSONObject setRspJsonCommonObject(AppListParamsWrapper requestWrapper) {
		JSONObject rspBody = new JSONObject();
		rspBody.put(RspJsonNode.VERSION, requestWrapper.getVersion());
		rspBody.put(RspJsonNode.DEVICE_TYPE, requestWrapper.getDeviceType());
		rspBody.put(RspJsonNode.MANUFACTURER, requestWrapper.getManufacturer());
		rspBody.put(RspJsonNode.SN, requestWrapper.getSn());
		rspBody.put(RspJsonNode.RESP_CODE, "00");
		return rspBody;
	}

	private boolean validParams(AppListParamsWrapper params) {
		if (StringUtils.isBlank(params.getSn()) || StringUtils.isBlank(params.getManufacturer())
				|| params.getAppList().isEmpty() || params.getAppList() == null) {
			logger.debug("参数不能为空");
			return false;
		} else {
			return true;
		}
	}

}
