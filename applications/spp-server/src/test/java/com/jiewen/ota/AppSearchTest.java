package com.jiewen.ota;

import java.io.IOException;

import com.alibaba.fastjson.JSONObject;

public class AppSearchTest extends TestBase {

	public void testParams1() throws IOException {
		// 按列表查询
		String url = "http://ipos-s.vanstone.com.cn/appSearch";
		JSONObject req = new JSONObject();
		req.put("version", "1.0");
		req.put("manufacturer", "Aisino");
		req.put("deviceType", "A90");
		req.put("sn", "00021041740");
		req.put("page", "0");
		req.put("pageSize", "10");
		req.put("searchType", "list");

		logger.info("log输出数据:" + req.toJSONString());
		String rsp = exchange(url, req.toJSONString());
		logger.info("log输出数据:" + rsp);
	}

	public void testParams2() throws IOException {
		// 查询最新APP
		String url = "http://localhost:8080/appSearch";
		JSONObject req = new JSONObject();
		req.put("version", "1.0");
		req.put("manufacturer", "00014");
		req.put("deviceType", "A90");
		req.put("sn", "00021000311");
		req.put("page", "0");
		req.put("pageSize", "10");
		req.put("searchType", "new");

		logger.info("log输出数据:" + req.toJSONString());
		String rsp = exchange(url, req.toJSONString());
		logger.info("log输出数据:" + rsp);
	}

	public void testParams3() throws IOException {
		// 按照排名查询
		String url = "http://localhost:8080/appSearch";
		JSONObject req = new JSONObject();
		req.put("version", "1.0");
		req.put("manufacturer", "00014");
		req.put("deviceType", "A90");
		req.put("sn", "00021000311");
		req.put("page", "0");
		req.put("pageSize", "10");
		req.put("searchType", "rank");

		logger.info("log输出数据:" + req.toJSONString());
		String rsp = exchange(url, req.toJSONString());
		logger.info("log输出数据:" + rsp);
	}

	public void testParams4() throws IOException {
		// 按照类别查询
		String url = "http://localhost:8080/appSearch";
		JSONObject req = new JSONObject();
		req.put("version", "1.0");
		req.put("manufacturer", "00014");
		req.put("deviceType", "A90");
		req.put("sn", "00021000311");
		req.put("page", "0");
		req.put("pageSize", "10");
		req.put("searchType", "class");
		req.put("classId", "1001");

		logger.info("log输出数据:" + req.toJSONString());
		String rsp = exchange(url, req.toJSONString());
		logger.info("log输出数据:" + rsp);
	}

	public void testParams5() throws IOException {
		// 按照应用名称查询
		String url = "http://localhost:8080/appSearch";
		JSONObject req = new JSONObject();
		req.put("version", "1.0");
		req.put("manufacturer", "00014");
		req.put("deviceType", "A90");
		req.put("sn", "00021000311");
		req.put("page", "0");
		req.put("pageSize", "10");
		req.put("searchType", "condition");
		req.put("appName", "支");

		logger.info("log输出数据:" + req.toJSONString());
		String rsp = exchange(url, req.toJSONString());
		logger.info("log输出数据:" + rsp);
	}
}
