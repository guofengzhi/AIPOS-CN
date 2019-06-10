package com.jiewen.ota;

import java.io.IOException;

import com.alibaba.fastjson.JSONObject;

public class CheckAppVersionTest extends TestBase {

	public void testParams() throws IOException {
		// 按列表查询
		String url = "http://localhost:8080/checkAppVersion";
		JSONObject req = new JSONObject();
		req.put("version", "1.0");
		req.put("manufacturer", "000014");
		req.put("deviceType", "A90");
		req.put("sn", "00021000311");
		req.put("appPackage", "com.alipay");
		req.put("appVersion", "v1.01.01012.171201.0");

		logger.info("log输出数据:" + req.toJSONString());
		String rsp = exchange(url, req.toJSONString());
		logger.info("log输出数据:" + rsp);
	}

}
