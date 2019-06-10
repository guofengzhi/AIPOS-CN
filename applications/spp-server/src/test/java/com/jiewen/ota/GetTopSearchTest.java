package com.jiewen.ota;

import java.io.IOException;

import com.alibaba.fastjson.JSONObject;

public class GetTopSearchTest extends TestBase {

	public void testParams() throws IOException {
		String url = "http://localhost:8080/topSearch";
		JSONObject req = new JSONObject();
		req.put("version", "1.0");
		req.put("manufacturer", "000014");
		req.put("deviceType", "A90");
		req.put("sn", "00021000277");
		req.put("page", "0");
		req.put("pageSize", "10");

		logger.info("log输出数据:" + req.toJSONString());
		String rsp = exchange(url, req.toJSONString());
		logger.info("log输出数据:" + rsp);
	}
}
