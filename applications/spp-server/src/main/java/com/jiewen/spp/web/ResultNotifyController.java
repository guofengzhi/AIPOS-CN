package com.jiewen.spp.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.jiewen.base.core.AbstractController;
import com.jiewen.commons.toolkit.annotation.JsonApiMethod;
import com.jiewen.spp.service.TmsLogService;
import com.jiewen.spp.wrapper.ResultNotifyWrapper;
import com.jiewen.utils.RspCode;
import com.jiewen.utils.RspJsonNode;

@Controller
public class ResultNotifyController extends AbstractController {

	@Autowired
	private TmsLogService tmsLogService;
	
	@JsonApiMethod
	@RequestMapping(value = "/tms/resultNotify")
	public @ResponseBody String resultNotify(@RequestBody String params) {
		/*参数非空校验*/
		ResultNotifyWrapper resultNotifyWrapper = JSON.parseObject(params, ResultNotifyWrapper.class);
		String version = resultNotifyWrapper.getVersion();
		String sn = resultNotifyWrapper.getSn();
		String manufactureNo = resultNotifyWrapper.getManufacturer();
		String deviceType = resultNotifyWrapper.getDeviceType();
		String fileName = resultNotifyWrapper.getFileName();
		String fileType = resultNotifyWrapper.getFileType();
		String fileVersion = resultNotifyWrapper.getFileVersion();
		String upgradeResult = resultNotifyWrapper.getUpgradeResult();
		if (!verifyString(version, sn, manufactureNo, deviceType, fileName, fileType, fileVersion, upgradeResult)) {
			return setRspMessage(RspCode.PARAM_ERROR, "params is not empty", resultNotifyWrapper.getSn());
		}
		/*记录日志*/
		tmsLogService.resultNotify(resultNotifyWrapper);
		JSONObject respJson = setRspJsonCommonObject(resultNotifyWrapper);
		respJson.put(RspJsonNode.MERNO, resultNotifyWrapper.getMerNo());
		respJson.put(RspJsonNode.TERMNO, resultNotifyWrapper.getTermNo());
		return respJson.toJSONString();
	}
	
}
