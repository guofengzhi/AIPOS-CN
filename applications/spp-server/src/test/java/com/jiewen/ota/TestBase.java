package com.jiewen.ota;

import java.io.IOException;

import org.apache.http.HttpEntity;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.alibaba.fastjson.JSONObject;
import com.jiewen.commons.Encodings;
import com.jiewen.commons.util.StringUtil;
import com.jiewen.utils.RspJsonNode;

import junit.framework.TestCase;

public class TestBase extends TestCase {

	protected static final Logger logger = LoggerFactory.getLogger(TestBase.class);

	public final String key = "998876511QQQWWeerASDHGJKL";

	protected String exchange(String url, String req) throws IOException {

		CloseableHttpClient httpClient = null;
		HttpPost httpPost = null;
		try {
			httpClient = HttpClients.createDefault();

			RequestConfig.Builder builder = RequestConfig.custom();
			builder.setConnectTimeout(5000); // 连接超时
			builder.setSocketTimeout(30000); // 接收超时
			RequestConfig requestConfig = builder.build();

			httpPost = new HttpPost(url);
			httpPost.setConfig(requestConfig);
			JSONObject rsp = JSONObject.parseObject(req);
			logger.info("reqBody：" + req);
			long timestemp = System.currentTimeMillis();
			String keySecrct = com.jiewen.utils.StringUtil.encrypt(rsp.getString(RspJsonNode.SN),
					String.valueOf(timestemp), key);
			logger.info("keySecrct={}", keySecrct);
			String signData = String.format("%s%s", req, keySecrct);
			String sign = StringUtil.md5sum(signData.getBytes(Encodings.UTF8));

			logger.info("sign：" + sign);
			logger.info("timestamp：" + String.valueOf(timestemp));
			httpPost.setHeader("sign", sign);
			httpPost.setHeader("timestamp", String.valueOf(timestemp));
			// 请求体
			String encoding = Encodings.UTF8;
			String mimeType = "application/json";
			ContentType contentType = ContentType.create(mimeType, encoding);
			StringEntity reqEntity = new StringEntity(req, contentType);
			httpPost.setEntity(reqEntity);

			// 获取响应
			CloseableHttpResponse response = httpClient.execute(httpPost);
			HttpEntity rspEntity = response.getEntity();
			String rspStr = EntityUtils.toString(rspEntity, Encodings.UTF8);
			response.close();

			return rspStr;

		} catch (Exception e) {
			e.getMessage();
		} finally {
			if (httpPost != null) {
				httpPost.abort();
			}
			if (httpClient != null) {
				httpClient.close();
			}
		}
		return null;
	}

}
