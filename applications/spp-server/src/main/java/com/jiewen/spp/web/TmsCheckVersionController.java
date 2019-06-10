package com.jiewen.spp.web;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.jiewen.base.core.AbstractController;
import com.jiewen.commons.toolkit.annotation.JsonApiMethod;
import com.jiewen.spp.service.impl.TmsFileServiceImpl;
import com.jiewen.spp.wrapper.TmsCheckVersionWrapper;
import com.jiewen.utils.RspCode;
import com.jiewen.utils.RspJsonNode;
import com.jiewen.utils.StringUtil;

/**
 * TMS版本检查controller
 * 
 * @author Pang.M
 *
 */
@RestController
public class TmsCheckVersionController extends AbstractController {

	@Autowired
	private TmsFileServiceImpl tmsFileService;

	@JsonApiMethod
	@RequestMapping(value = "/tms/checkVersion")
	public @ResponseBody String checkVersion(@RequestBody String params) {

		TmsCheckVersionWrapper requestWrapper = JSON.parseObject(params,
				TmsCheckVersionWrapper.class);
		if (!validParams(requestWrapper)) {
			return setRspMessage(RspCode.PARAM_ERROR, "params is not empty", requestWrapper.getSn());
		}
		List<JSONObject> jSONObjectList = tmsFileService.getFileList(requestWrapper);
		JSONObject respJson = setRspJsonCommonObject(requestWrapper);
		String merNo = requestWrapper.getMerNo();
		String termNo = requestWrapper.getTermNo();
		if (StringUtil.isNotEmpty(merNo)) {
			respJson.put(RspJsonNode.MERNO, merNo);
		}
		if (StringUtil.isNotEmpty(termNo)) {
			respJson.put(RspJsonNode.TERMNO, termNo);
		}
		respJson.put("fileList", jSONObjectList);
		return respJson.toJSONString();
	}

	/**
	 * 验证参数是否为空
	 * 
	 * @param params
	 * @return
	 */
	private boolean validParams(TmsCheckVersionWrapper params) {
		if (!this.verifyString(params.getSn(), params.getManufacturer())) {
			logger.debug("参数不能为空");
			return false;
		}
		return true;
	}

}
