package com.jiewen.ota;

import java.io.IOException;

import com.alibaba.fastjson.JSONObject;

public class LogonInTest extends TestBase {

	public void testParams() throws IOException {
		String url = "http://ipos-s.vanstone.com.cn/logonIn";
		JSONObject req = new JSONObject();
		req.put("version", "1.0");
		req.put("manufacturer", "000014");
		req.put("deviceType", "A90");
		req.put("sn", "00021041741");

		logger.info("log输出数据:" + req.toJSONString());
		String rsp = exchange(url, req.toJSONString());
		logger.info("log输出数据:" + rsp);
	}
}
