package com.jiewen.ota;

import java.io.IOException;

import com.alibaba.fastjson.JSONObject;

public class TmsCheckVersionTest extends TestBase {

	public void testParams1() throws IOException {
		// 按列表查询
		String url = "http://localhost:8080/tms/checkVersion";
		JSONObject req = new JSONObject();
		req.put("version", "V1.0");
		req.put("sn", "1234567890");
		req.put("manufacturer", "A701");
		req.put("deviceType", "A70");
//		req.put("merNo", "1234567891");
//		req.put("termNo", "002");

		logger.info("log输出数据:" + req.toJSONString());
		String rsp = exchange(url, req.toJSONString());
		logger.info("log输出数据:" + rsp);
	}

}
