package com.jiewen.base.core;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;

import com.alibaba.fastjson.JSONObject;
import com.jiewen.commons.util.StringUtil;
import com.jiewen.spp.model.DeviceInfo;
import com.jiewen.spp.service.impl.DeviceInfoServiceImpl;
import com.jiewen.spp.wrapper.BaseWrapper;
import com.jiewen.utils.RspJsonNode;

public class AbstractController {

	protected Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${http.download.path}")
	protected String prefxiDownloadPath;

	@Autowired
	protected DeviceInfoServiceImpl deviceInfoService;

	/**
	 * 设置返回信息
	 * 
	 * @param rspCode
	 * @param rspMsg
	 * @return
	 */
	protected String setRspMessage(String rspCode, String rspMsg, String sn) {
		JSONObject rsp = new JSONObject();
		rsp.put(RspJsonNode.RESP_CODE, rspCode);
		rsp.put(RspJsonNode.RESP_MSG, rspMsg);
		rsp.put(RspJsonNode.SN, sn);
		return rsp.toJSONString();
	}

	/**
	 * 根据sn获取设备信息
	 * 
	 * @param token
	 * @return
	 */
	protected DeviceInfo selectDeviceInfo(DeviceInfo deviceInfo) {
		return deviceInfoService.selectBySn(deviceInfo);
	}

	/**
	 * 验证字符串是否为空
	 * 
	 * @param msgs
	 * @return
	 */
	protected boolean verifyString(String... msgs) {
		for (String s : msgs) {
			if (StringUtil.isEmpty(s)) {
				return false;
			}
		}
		return true;
	}

	/**
	 * 创建公共返回报文
	 * 
	 * @param requestWrapper
	 * @return
	 */
	protected JSONObject setRspJsonCommonObject(BaseWrapper requestWrapper) {
		JSONObject rspBody = new JSONObject();
		rspBody.put(RspJsonNode.VERSION, requestWrapper.getVersion());
		rspBody.put(RspJsonNode.DEVICE_TYPE, requestWrapper.getDeviceType());
		rspBody.put(RspJsonNode.MANUFACTURER, requestWrapper.getManufacturer());
		rspBody.put(RspJsonNode.SN, requestWrapper.getSn());
		rspBody.put(RspJsonNode.RESP_CODE, "00");
		rspBody.put(RspJsonNode.RESP_MSG, "request successed"); // 应答消息
		return rspBody;
	}

}
