package com.jiewen.spp.web;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.jiewen.base.core.AbstractController;
import com.jiewen.commons.toolkit.annotation.JsonApiMethod;
import com.jiewen.spp.service.impl.LogInfoServiceImpl;
import com.jiewen.spp.wrapper.RecLogInfoWrapper;
import com.jiewen.utils.RspCode;
import com.jiewen.utils.RspJsonNode;

/**
 * Created by CodeGenerator on 2017/10/24.
 */
@RestController
public class RecLogInfoController extends AbstractController {

	@Autowired
	private LogInfoServiceImpl logInfoServiceImpl;

	@JsonApiMethod
	@RequestMapping(value = "/recLogInfo")
	public @ResponseBody String recLogInfo(@RequestParam(value = "body") String params,
			@RequestParam(value = "file") MultipartFile file) {

		RecLogInfoWrapper requestWrapper = JSON.parseObject(params, RecLogInfoWrapper.class);
		if (!validParams(requestWrapper, file)) {
			return setRspMessage(RspCode.PARAM_ERROR, "参数不能为空", requestWrapper.getSn());
		}

		logInfoServiceImpl.recLogInfo(requestWrapper, file);

		JSONObject respJsonCommon = setRspJsonCommonObject(requestWrapper);
		return respJsonCommon.toJSONString();
	}

	/**
	 * 返回报文
	 * 
	 * @param requestWrapper
	 * @return
	 */
	private JSONObject setRspJsonCommonObject(RecLogInfoWrapper requestWrapper) {
		JSONObject rspBody = new JSONObject();
		rspBody.put(RspJsonNode.VERSION, requestWrapper.getVersion());
		rspBody.put(RspJsonNode.DEVICE_TYPE, requestWrapper.getDeviceType());
		rspBody.put(RspJsonNode.MANUFACTURER, requestWrapper.getManufacturer());
		rspBody.put(RspJsonNode.SN, requestWrapper.getSn());
		rspBody.put(RspJsonNode.RESP_CODE, "00");
		return rspBody;
	}

	private boolean validParams(RecLogInfoWrapper params, MultipartFile file) {
		if (StringUtils.isBlank(params.getSn()) || StringUtils.isBlank(params.getManufacturer())
				|| StringUtils.isBlank(params.getLogName()) || StringUtils.isBlank(params.getLogMd5()) || file == null
				|| file.getSize() == 0) {
			logger.debug("参数不能为空");
			return false;
		} else {
			return true;
		}
	}
}
