package com.jiewen.spp.service.impl;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.Iterator;
import java.util.TreeMap;
import java.util.Map.Entry;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.http.ParseException;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jiewen.spp.service.BDTransLocationService;
@Service
public class BDTransLocationServiceImpl implements BDTransLocationService {

	/*private String transJWD = "http://api.map.baidu.com/geoconv/v1/";*/
/*	private String ak = "nYICsgumUhMHbsnYVBFHG2eh3vewG0p3";*/
	
	@Value("{transfer.jwd.url}")
	private String transJWD;
	
	@Value("{baidu.map.ak}")
	private String ak;
	
	
	protected Log logger = LogFactory.getLog(getClass());
	
	@Override
	public JSONObject transLocation(String longitude, String latitude) throws Exception{
		CloseableHttpClient client = null;
		CloseableHttpResponse response = null;
		HttpGet httpGet = new HttpGet();
		String result = "";
		JSONObject jwdJSON = new JSONObject();
		try {
			
			TreeMap createReq = createReq(longitude,latitude);
			Iterator iterator = createReq.entrySet().iterator();
			transJWD = transJWD +"?";
			while(iterator.hasNext()){
				Entry next = (Entry) iterator.next();
				transJWD += next.getKey()+"="+next.getValue()+"&";
			}
			transJWD = transJWD.substring(0,transJWD.length()-1);
			URI uri = new URI(transJWD);
			httpGet.setURI(uri);
			client = HttpClients.createDefault();
			response = client.execute(httpGet);
			org.apache.http.HttpEntity entity = response.getEntity();
			result = EntityUtils.toString(entity, "utf-8");
			JSONObject json = (JSONObject) JSONObject.parse(result);
			String status = json.getString("status");
			if(status.equals("0")){
				 String resul = json.getString("result");
				 JSONArray resultJson = (JSONArray) JSONObject.parse(resul);
				 if(resultJson.size()>0){
					String jwd =  resultJson.get(0).toString();
					JSONObject jwdJson = (JSONObject) JSONObject.parse(jwd);
					String bdLongitude = jwdJson.getString("x");
					String bdLatitude = jwdJson.getString("y");
					jwdJSON.put("longitude", bdLongitude);
					jwdJSON.put("latitude", bdLatitude);
				 }
			 }
		} catch (ClientProtocolException e) {
			logger.error(e.getMessage(), e);
		} catch (ParseException e) {
			logger.error(e.getMessage(), e);
		} catch (URISyntaxException e) {
			logger.error(e.getMessage(), e);
		}finally {
			if(response!=null){
				response.close();
			}
			if(httpGet!=null){
				httpGet.abort();
			}
			if(client!=null){
				client.close();
			}
		}
		return jwdJSON;
	}
	
	private TreeMap createReq(String longitude,String latitude){
		TreeMap map = new TreeMap<String,Object>();
		String jwd= longitude+","+latitude;
		map.put("ak", ak);
		map.put("coords",jwd);
		return map;
	}

}
