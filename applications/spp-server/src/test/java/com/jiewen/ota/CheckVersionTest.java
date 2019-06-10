package com.jiewen.ota;

import java.io.IOException;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

public class CheckVersionTest extends TestBase {

	public void testParams() throws IOException {
		String url = "http://localhost:8080//checkVersion";
		JSONObject req = new JSONObject();
		JSONObject childreq = new JSONObject();
		JSONObject childreq1 = new JSONObject();
		JSONArray array = new JSONArray();
		childreq.put("appVersion", "2.01.00002.171120.1");
		childreq.put("appPackage", "com.vanstone.appsdk.api");
		childreq.put("appName", "SdkSer_common");
		array.add(childreq);
		childreq1.put("appVersion", "1.01.01012.171120.1");
		childreq1.put("appPackage", "com.vanstone.misposicbcscript");
		childreq1.put("appName", "中国工商银行");
		req.put("version", "1.0");
		req.put("manufacturer", "000014");
		req.put("deviceType", "A90");
		// req.put("sn", "00021000273");
		// req.put("sourceId", "000001");
		// req.put("appList",array);
		req.put("appPackage", "com.company.hsmse");
		req.put("appVersion", "1.00.15");

		logger.info("log输出数据: {}", req.toJSONString());
		String rsp = exchange(url, req.toJSONString());
		logger.info("log接收数据: {}", rsp);
	}

	public static void main(String[] args) {
		JSONObject req = new JSONObject();
		JSONObject childreq = new JSONObject();
		req.put("version", "1.0");
		req.put("manufacturer", "1001");
		req.put("deviceType", "A90");
		req.put("sn", "0010290293023123231123");
		req.put("osVersion", "v1.0.1");
		req.put("bankName", "");
		childreq.put("bluetooth", "0");
		childreq.put("wifi", "0");
		childreq.put("gprs", "0");
		req.put("deviceInfo", childreq);

		JSONObject jsonObject = JSON.parseObject(req.toJSONString());
		// String sn = jsonObject.getString("sn");
		// String sId = jsonObject.getString("sourceId");
		logger.info("log输出数据:" + jsonObject.toJSONString());
	}

}
