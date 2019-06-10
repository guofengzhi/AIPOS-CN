package com.jiewen.ota;

import java.io.IOException;

import com.alibaba.fastjson.JSONObject;

public class GetFileControllerTest extends TestBase {

	public void testParams() throws IOException {
		String url = "http://localhost:8080/tms/getFile";
		JSONObject req = new JSONObject();
		req.put("version", "1.0");
		req.put("manufacturer", "Vanstone");
		req.put("deviceType", "A70");
		req.put("sn", "00021000311");
		req.put("merNo", "100000100011");
		req.put("termNo", "10000010001100011");
		req.put("fileName", "test.txt");
		req.put("fileType", "4");
		req.put("fileVersion", "v1.0");
		req.put("startPosi", "0");

		logger.info("log输出数据:" + req.toJSONString());
		String rsp = exchange(url, req.toJSONString());
		logger.info("log输出数据:" + rsp);
	}
}
