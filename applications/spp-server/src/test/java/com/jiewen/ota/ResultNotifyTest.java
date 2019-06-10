package com.jiewen.ota;

import java.io.IOException;

import com.alibaba.fastjson.JSONObject;

public class ResultNotifyTest extends TestBase {

	public void testParams1() throws IOException {
		// 按列表查询
		String url = "http://localhost:8080/tms/resultNotify";
		JSONObject req = new JSONObject();
		req.put("version", "V1.0");
		req.put("sn", "1234567890");
		req.put("manufacturer", "A70");
		req.put("deviceType", "A70");
//		req.put("merNo", "A90");
//		req.put("termNo", "");
		req.put("fileName", "1.png");
		req.put("fileType", "APP");
		req.put("fileVersion", "v1.01");
		req.put("upgradeResult", "00");
//		req.put("upgradeResult", "99");

		logger.info("log输出数据:" + req.toJSONString());
		String rsp = exchange(url, req.toJSONString());
		logger.info("log输出数据:" + rsp);
	}

}
