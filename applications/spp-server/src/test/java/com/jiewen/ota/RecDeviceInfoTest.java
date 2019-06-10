package com.jiewen.ota;

import java.io.IOException;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

public class RecDeviceInfoTest extends TestBase {

	public void testParams() throws IOException {
		String url = "http://localhost:8080/recDeviceInfo";
		JSONObject req = new JSONObject();
		req.put("version", "1.0");
		req.put("manufacturer", "000014");
		req.put("deviceType", "A90");
		req.put("sn", "00021000277");
		req.put("hardware", "v1.0.0.1");

		JSONArray array = new JSONArray();
		JSONObject appInfo1 = new JSONObject();
		appInfo1.put("appVersion", "v1.0.1");
		appInfo1.put("appPackage", "com.wxpay");
		array.add(appInfo1);

		JSONObject appInfo2 = new JSONObject();
		appInfo2.put("appVersion", "v1.0.1");
		appInfo2.put("appPackage", "com.alipay");
		array.add(appInfo2);

		JSONObject appInfo3 = new JSONObject();
		appInfo3.put("appVersion", "v1.0.1");
		appInfo3.put("appPackage", "com.qpay");
		array.add(appInfo3);

		req.put("appList", array.toJSONString());

		JSONObject deviceInfo = new JSONObject();
		deviceInfo.put("gprs", "1");
		deviceInfo.put("lan", "1");
		deviceInfo.put("wifi", "1");
		deviceInfo.put("wcdma", "1");
		deviceInfo.put("picc", "1");
		deviceInfo.put("modem", "0");
		deviceInfo.put("led", "1");
		deviceInfo.put("blueTooth", "1");
		deviceInfo.put("mag", "1");
		deviceInfo.put("gm", "1");
		deviceInfo.put("location", "1");
		deviceInfo.put("beep", "1");
		deviceInfo.put("cdma", "1");
		deviceInfo.put("ic", "1");
		deviceInfo.put("printer", "0");
		deviceInfo.put("serialno", "00020202930");
		deviceInfo.put("model", "A90");
		deviceInfo.put("manufacture", "艾体威尔");
		deviceInfo.put("androidosversion", "1.6.0");
		deviceInfo.put("printinfo ", "0");
		deviceInfo.put("magcard", "0");
		deviceInfo.put("iccard", "0");
		deviceInfo.put("contactless", "0");
		deviceInfo.put("internet", "0");
		deviceInfo.put("totalmemory", "13423414");
		deviceInfo.put("availmemory", "998897");
		deviceInfo.put("battery", "90");
		req.put("deviceInfo", deviceInfo.toJSONString());

		JSONObject location = new JSONObject();
		location.put("latitude", "30.2");
		location.put("longitude", "130.2");
		location.put("addr", "北京市海淀区四季青常青园南路87号");
		location.put("country", "中国");
		location.put("province", "北京");
		location.put("city", "北京");
		location.put("district", "海淀区");
		location.put("street", "常青园南路");
		req.put("location", location.toJSONString());

		logger.info("log输出数据:" + req.toJSONString());
		String rsp = exchange(url, req.toJSONString());
		logger.info("log输出数据:" + rsp);
	}

	public static void main(String[] args) {

		JSONArray array = new JSONArray();
		JSONObject appInfo1 = new JSONObject();
		appInfo1.put("appName", "微信");
		appInfo1.put("appPackage", "com.wxpay");
		array.add(appInfo1);

		JSONObject appInfo2 = new JSONObject();
		appInfo2.put("appName", "支付宝");
		appInfo2.put("appPackage", "com.alipay");
		array.add(appInfo2);

		JSONObject appInfo3 = new JSONObject();
		appInfo3.put("appName", "QQ钱包");
		appInfo3.put("appPackage", "com.qpay");
		array.add(appInfo3);

		logger.info(array.toJSONString());

		JSONObject deviceInfo = new JSONObject();
		deviceInfo.put("gprs", "1");
		deviceInfo.put("lan", "1");
		deviceInfo.put("wifi", "1");
		deviceInfo.put("wcdma", "1");
		deviceInfo.put("picc", "1");
		deviceInfo.put("modem", "0");
		deviceInfo.put("led", "1");
		deviceInfo.put("blueTooth", "1");
		deviceInfo.put("mag", "1");
		deviceInfo.put("gm", "1");
		deviceInfo.put("location", "1");
		deviceInfo.put("beep", "1");
		deviceInfo.put("cdma", "1");
		deviceInfo.put("ic", "1");
		deviceInfo.put("printer", "0");

		logger.info(deviceInfo.toJSONString());
	}
}
