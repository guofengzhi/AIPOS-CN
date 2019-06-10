package com.jiewen.spp.web;

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
import com.jiewen.spp.model.RecordInfo;
import com.jiewen.spp.service.impl.RecordInfoServiceImpl;
import com.jiewen.spp.wrapper.RecDirectoryWrapper;
import com.jiewen.utils.RspCode;
import com.jiewen.utils.RspJsonNode;

/**
 * 
 * 获取目录 https://${domain}/spp/recDirectory
 * 
 * Created by CodeGenerator on 2017/11/14.
 * 
 * @author Pang.M
 * 
 */
@RestController
public class RecDirectoryController extends AbstractController {

	@Autowired
	private RecordInfoServiceImpl recordInfoService;

	@JsonApiMethod
	@RequestMapping(value = "/recDirectory")
	public @ResponseBody String recDirectory(@RequestBody String params) {
		RecDirectoryWrapper requestWrapper = JSON.parseObject(params, RecDirectoryWrapper.class);
		if (!validParams(requestWrapper)) {
			return setRspMessage(RspCode.PARAM_ERROR, "参数不能为空", requestWrapper.getSn());
		}

		RecordInfo recordInfo = recordInfoService.recDirectoryInfo(requestWrapper);

		JSONObject respJsonCommon = setRspJsonCommonObject(requestWrapper);
		respJsonCommon.put(RspJsonNode.APP_PACKAGE, recordInfo.getPackageName());
		respJsonCommon.put(RspJsonNode.TRANS_ID, recordInfo.getId());
		return respJsonCommon.toJSONString();
	}

	/**
	 * 返回报文
	 * 
	 * @param requestWrapper
	 * @return
	 */
	private JSONObject setRspJsonCommonObject(RecDirectoryWrapper requestWrapper) {
		JSONObject rspBody = new JSONObject();
		rspBody.put(RspJsonNode.VERSION, requestWrapper.getVersion());
		rspBody.put(RspJsonNode.DEVICE_TYPE, requestWrapper.getDeviceType());
		rspBody.put(RspJsonNode.MANUFACTURER, requestWrapper.getManufacturer());
		rspBody.put(RspJsonNode.SN, requestWrapper.getSn());
		rspBody.put(RspJsonNode.RESP_CODE, "00");
		return rspBody;
	}

	private boolean validParams(RecDirectoryWrapper params) {
		if (StringUtils.isBlank(params.getSn()) || StringUtils.isBlank(params.getVersion())
				|| StringUtils.isBlank(params.getManufacturer()) || StringUtils.isBlank(params.getTransId())
				|| StringUtils.isBlank(params.getDirectoryList())) {
			logger.debug("参数不能为空");
			return false;
		} else {
			return true;
		}
	}
}
