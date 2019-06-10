package com.jiewen.spp.web;

import java.io.File;
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
import com.jiewen.spp.model.AppInfo;
import com.jiewen.spp.model.DeviceInfo;
import com.jiewen.spp.service.impl.AppSearchServiceImpl;
import com.jiewen.spp.wrapper.AppSearchWrapper;
import com.jiewen.utils.Contants;
import com.jiewen.utils.RspCode;
import com.jiewen.utils.RspJsonNode;

/**
 * 应用查询
 * 
 * @author Pang.M
 *
 */
@RestController
public class AppSearchController extends AbstractController {

	@Autowired
	private AppSearchServiceImpl appSearchService;

	@JsonApiMethod
	@RequestMapping(value = "/appSearch")
	public @ResponseBody String appSearch(@RequestBody String params) {

		AppSearchWrapper requestWrapper = JSON.parseObject(params, AppSearchWrapper.class);
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

		List<AppInfo> list = appSearchService.getAppInfoList(requestWrapper, deviceInfo);
		JSONObject respJson = setRspJsonCommonObject(requestWrapper);
		setAppInfoListJSON(respJson, list);

		return respJson.toJSONString();
	}

	private boolean validParams(AppSearchWrapper requestWrapper) {
		if (StringUtils.isBlank(requestWrapper.getSn()) || StringUtils.isBlank(requestWrapper.getManufacturer())
				|| StringUtils.isBlank(requestWrapper.getPage()) || StringUtils.isBlank(requestWrapper.getPageSize())
				|| StringUtils.isBlank(requestWrapper.getSearchType())) {
			if (StringUtils.equals(requestWrapper.getClassId(), Contants.SearchType.CLASS)) {
				if (StringUtils.isBlank(requestWrapper.getClassId())) {
					return false;
				}
			}
			if (StringUtils.equals(requestWrapper.getClassId(), Contants.SearchType.CONDITION)) {
				if (StringUtils.isBlank(requestWrapper.getAppName())) {
					return false;
				}
			}
			logger.debug("参数不能为空");
			return false;
		} else {
			return true;
		}
	}

	/**
	 * 返回报文
	 * 
	 * @param requestWrapper
	 * @return
	 */
	private JSONObject setRspJsonCommonObject(AppSearchWrapper requestWrapper) {
		JSONObject rspBody = new JSONObject();
		rspBody.put(RspJsonNode.VERSION, requestWrapper.getVersion());
		rspBody.put(RspJsonNode.DEVICE_TYPE, requestWrapper.getDeviceType());
		rspBody.put(RspJsonNode.MANUFACTURER, requestWrapper.getManufacturer());
		rspBody.put(RspJsonNode.SN, requestWrapper.getSn());
		rspBody.put(RspJsonNode.RESP_CODE, "00");
		return rspBody;
	}

	/**
	 * 设置返回APP信息列表
	 * 
	 * @param respJson
	 * @param list
	 */
	private void setAppInfoListJSON(JSONObject respJson, List<AppInfo> list) {
		JSONArray jsonArray = new JSONArray();
		for (AppInfo appInfo : list) {
			JSONObject jot = new JSONObject();
			String appPackageName = appInfo.getAppPackageName();
			jot.put(RspJsonNode.APP_ID, appInfo.getId());
			jot.put(RspJsonNode.APP_NAME, appInfo.getAppName());
			jot.put(RspJsonNode.APP_DESC, appInfo.getAppDescription());
			jot.put(RspJsonNode.APP_TYPE, appInfo.getCategory());
			jot.put(RspJsonNode.APP_PLATFORM, appInfo.getPlatform());
			jot.put(RspJsonNode.APP_PACKAGE, appInfo.getAppPackage());
			appPackageName = appPackageName.substring(appPackageName.lastIndexOf("\\")+1, appPackageName.length());
			jot.put(RspJsonNode.APP_PACKAGE_NAME, appPackageName);
			jot.put(RspJsonNode.APP_FILE_PATH, appInfo.getAppFile());
			jot.put(RspJsonNode.APP_SIZE, appInfo.getAppFileSize());
			jot.put(RspJsonNode.APP_LOGO, appInfo.getAppLogo());
			jot.put(RspJsonNode.APP_IMG, appInfo.getAppImg());
			jot.put(RspJsonNode.VERSION_CODE,appInfo.getAppVersionNumber());
			jot.put(RspJsonNode.VERSION_NUMBER,appInfo.getAppVersion());
			jot.put(RspJsonNode.COUNTS, appInfo.getCounts());

			jsonArray.add(jot);
		}
		respJson.put(RspJsonNode.APP_LIST, jsonArray.toJSONString());
	}
}
