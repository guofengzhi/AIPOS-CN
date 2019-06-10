package com.jiewen.spp.service;


import com.alibaba.fastjson.JSONObject;

public interface BDTransLocationService {

	public JSONObject transLocation(String lonitude,String latitude) throws Exception;
}
