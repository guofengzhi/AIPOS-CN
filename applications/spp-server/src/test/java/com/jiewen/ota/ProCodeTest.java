package com.jiewen.ota;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

import com.alibaba.fastjson.JSONObject;
import com.jiewen.commons.util.Base64;

public class ProCodeTest {

	public static void main(String[] args) {

		List<String> list = new ArrayList<>();
		list.add("'M'");
		list.add("'K'");
		list.add("'B'");

		JSONObject job = new JSONObject();
		job.put("flag", list.toString());
		System.out.println(job.toJSONString());

		try {
			System.out.println(Base64.encode("hello".getBytes("UTF-8")));
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
}
