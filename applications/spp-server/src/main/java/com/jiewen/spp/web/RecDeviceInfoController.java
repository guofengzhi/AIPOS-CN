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
import com.jiewen.spp.model.DeviceInfo;
import com.jiewen.spp.model.Merchant;
import com.jiewen.spp.service.BDTransLocationService;
import com.jiewen.spp.service.MerchantService;
import com.jiewen.spp.service.impl.DeviceInfoServiceImpl;
import com.jiewen.spp.wrapper.RecDeviceInfoWrapper;
import com.jiewen.utils.LocationUtils;
import com.jiewen.utils.RspCode;
import com.jiewen.utils.RspJsonNode;

/**
 * Created by CodeGenerator on 2017/10/25.
 */
@RestController
public class RecDeviceInfoController extends AbstractController {

	@Autowired
	private DeviceInfoServiceImpl deviceInfoService;
	
	@Autowired
	private MerchantService merchantService;

	@JsonApiMethod
	@RequestMapping(value = "/recDeviceInfo")
	public @ResponseBody String recDeviceInfo(@RequestBody String params) throws Exception {

		RecDeviceInfoWrapper requestWrapper = JSON.parseObject(params, RecDeviceInfoWrapper.class);
		if (!validParams(requestWrapper)) {
			return setRspMessage(RspCode.PARAM_ERROR, "参数不能为空", requestWrapper.getSn());
		}
		deviceInfoService.recDeviceInfo(requestWrapper);

		JSONObject respJsonCommon = setRspJsonCommonObject(requestWrapper);
		respJsonCommon.put(RspJsonNode.OVER_RUN_FLAG, "0");
		if (!verifyTermScope(requestWrapper)) {
			respJsonCommon.put(RspJsonNode.OVER_RUN_FLAG, "1");
		}
		return respJsonCommon.toJSONString();
	}

	private boolean verifyTermScope(RecDeviceInfoWrapper requestWrapper) throws Exception {
		String location = requestWrapper.getLocation();
		String deviceInf = requestWrapper.getDeviceInfo();
		JSONObject deviceInfObj = (JSONObject) JSONObject.parse(deviceInf);
		JSONObject locationObj = (JSONObject) JSONObject.parse(location);
		String termLongitude = locationObj.getString("longitude");
		String termLatitude = locationObj.getString("latitude");
		String termSn = deviceInfObj.getString("sn");
		DeviceInfo deviceInfo = deviceInfoService.getBySn(termSn);
		
		String merId = deviceInfo.getMerId();
		Merchant merchant = merchantService.getByMerId(merId);
		if(merchant==null){
			logger.debug("设备没有绑定商户");
			return false;
		}
		String merLongitude = merchant.getLongitude();
		String merLatitude = merchant.getLatitude();
		if(StringUtils.isEmpty(merLongitude)){
			logger.debug("商户经度信息不存在");
			return false;
		}
		if(StringUtils.isEmpty(merLatitude)){
			logger.debug("商户纬度信息不存在");
			return false;
		}
		
		//JSONObject termLocation = bdTransLocationService.transLocation(termLongitude, termLatitude);
		//JSONObject merLocation = bdTransLocationService.transLocation(merLongitude, merLatitude);
		
		/*termLongitude = termLocation.getString("longitude");
		termLatitude = termLocation.getString("latitude");
		
		merLongitude = merLocation.getString("longitude");
		merLatitude = merLocation.getString("latitude");*/
		
		double distance = LocationUtils.getDistance(Double.valueOf(merLongitude), 
				Double.valueOf(merLatitude), Double.valueOf(termLongitude), Double.valueOf(termLatitude));
		String location2 = deviceInfo.getLocation();
		JSONObject loca = (JSONObject) JSONObject.parse(location2);
		loca.put("longitude", termLongitude);
		loca.put("latitude", termLatitude);
		location2 = loca.toJSONString();
		deviceInfo.setLocation(location2);
		deviceInfoService.updateJwd(deviceInfo);
		if(distance>merchant.getRadius()){
			logger.debug("设备使用超出允许范围");
			return false;
		}
		return true;
	}

	/**
	 * 返回报文
	 * 
	 * @param requestWrapper
	 * @return
	 */
	private JSONObject setRspJsonCommonObject(RecDeviceInfoWrapper requestWrapper) {
		JSONObject rspBody = new JSONObject();
		rspBody.put(RspJsonNode.VERSION, requestWrapper.getVersion());
		rspBody.put(RspJsonNode.DEVICE_TYPE, requestWrapper.getDeviceType());
		rspBody.put(RspJsonNode.MANUFACTURER, requestWrapper.getManufacturer());
		rspBody.put(RspJsonNode.SN, requestWrapper.getSn());
		rspBody.put(RspJsonNode.RESP_CODE, "00");
		return rspBody;
	}

	private boolean validParams(RecDeviceInfoWrapper params){
		String location = params.getLocation();
		if (StringUtils.isBlank(params.getSn()) || StringUtils.isBlank(params.getVersion())
				|| StringUtils.isBlank(params.getManufacturer()) || StringUtils.isBlank(params.getAppList())
				|| StringUtils.isBlank(params.getDeviceInfo()) || StringUtils.isBlank(location)
				|| StringUtils.isBlank(params.getHardware())) {
			logger.debug("参数不能为空");
			return false;
		} else {
			return true;
		}
	}
}
