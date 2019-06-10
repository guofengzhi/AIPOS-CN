package com.jiewen.ota;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.alibaba.fastjson.JSONObject;
import com.jiewen.commons.Encodings;
import com.jiewen.commons.util.StringUtil;

public class RecLogInfoTest {
	protected static Logger logger = LoggerFactory.getLogger(RecLogInfoTest.class);

	public static final String key = "998876511QQQWWeerASDHGJKL";

	private static final int TIME_OUT = 10 * 10000000; // 超时时间

	private static final String CHARSET = "utf-8"; // 设置编码

	private static final String PREFIX = "--";

	private static final String LINE_END = "\r\n";

	public static void upload(String host, File file, Map<String, String> params) {
		String BOUNDARY = UUID.randomUUID().toString(); // 边界标识 随机生成 String
														// PREFIX = "--" ,
														// LINE_END = "\r\n";
		String CONTENT_TYPE = "multipart/form-data"; // 内容类型
		long timestemp = System.currentTimeMillis();
		try {
			URL url = new URL(host);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setReadTimeout(TIME_OUT);
			conn.setConnectTimeout(TIME_OUT);
			conn.setRequestMethod("POST"); // 请求方式
			conn.setRequestProperty("Charset", CHARSET); // 设置编码
			conn.setRequestProperty("connection", "keep-alive");
			conn.setRequestProperty("sign", sign("00021000064", String.valueOf(timestemp), params));
			conn.setRequestProperty("timestamp", String.valueOf(timestemp));
			conn.setRequestProperty("Content-Type", CONTENT_TYPE + ";boundary=" + BOUNDARY);
			conn.setDoInput(true); // 允许输入流
			conn.setDoOutput(true); // 允许输出流
			conn.setUseCaches(false); // 不允许使用缓存

			if (file != null) {
				/** * 当文件不为空，把文件包装并且上传 */
				OutputStream outputSteam = conn.getOutputStream();
				DataOutputStream dos = new DataOutputStream(outputSteam);
				StringBuffer sb = new StringBuffer();
				sb.append(LINE_END);
				if (params != null) { // 根据格式，开始拼接文本参数
					sb.append(PREFIX).append(BOUNDARY).append(LINE_END); // 分界符
					sb.append("Content-Disposition: form-data; name=\"body\"" + LINE_END);
					sb.append("Content-Type: text/plain; charset=" + CHARSET + LINE_END);
					sb.append(LINE_END);
					sb.append(params.get("body"));
					sb.append(LINE_END); // 换行！
				}
				sb.append(PREFIX); // 开始拼接文件参数
				sb.append(BOUNDARY);
				sb.append(LINE_END);
				/**
				 * 这里重点注意： name里面的值为服务器端需要key 只有这个key 才可以得到对应的文件
				 * filename是文件的名字，包含后缀名的 比如:abc.png
				 */
				sb.append("Content-Disposition: form-data; name=\"file\"; filename=\"" + file.getName() + "\""
						+ LINE_END);
				sb.append("Content-Type: application/octet-stream; charset=" + CHARSET + LINE_END);
				sb.append(LINE_END);
				// 写入文件数据
				dos.write(sb.toString().getBytes());
				InputStream is = new FileInputStream(file);
				byte[] bytes = new byte[1024];
				long totalbytes = file.length();
				logger.info("cky", "total=" + totalbytes);
				int len = 0;
				while ((len = is.read(bytes)) != -1) {
					dos.write(bytes, 0, len);
				}
				is.close();
				dos.write(LINE_END.getBytes()); // 一定还有换行
				byte[] end_data = (PREFIX + BOUNDARY + PREFIX + LINE_END).getBytes();
				dos.write(end_data);
				dos.flush();
				/**
				 * 获取响应码 200=成功 当响应成功，获取响应的流
				 */
				// int code = conn.getResponseCode();
				sb.setLength(0);
				BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
				String line;
				while ((line = br.readLine()) != null) {
					sb.append(line);
					logger.info(line);
				}

			}
		} catch (MalformedURLException e) {
			logger.error(e.getMessage());
		} catch (IOException e) {
			logger.error(e.getMessage());
		}
	}

	public static String sign(String sn, String timestemp, Map<String, String> params) {
		String keySecrct = com.jiewen.utils.StringUtil.encrypt(sn, timestemp, key);
		logger.info(params.get("body").toString());
		String signData = String.format("%s%s", params.get("body").toString(), keySecrct);
		String sign = "";
		try {
			sign = StringUtil.md5sum(signData.getBytes(Encodings.UTF8));
		} catch (UnsupportedEncodingException e) {
			logger.error(e.getMessage());
		}
		return sign;
	}

	public static String buildBody() {
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("manufacturerName", "Vanstone");
		jsonObject.put("logMd5", "086dfd0594d9b305fede86845424cdc4");
		jsonObject.put("logName", "00021000064_20171114132828_com.vanstone.icbc.test5.zip");
		jsonObject.put("deviceType", "A90");
		jsonObject.put("sn", "00021000064");
		jsonObject.put("transId", "1234567890");
		jsonObject.put("signType", "0");
		jsonObject.put("bankName", "master");
		jsonObject.put("manufacturer", "000014");
		jsonObject.put("hardware", "V3.3");
		jsonObject.put("version", "1.0");
		jsonObject.put("osVersion", "1.00.03");
		return jsonObject.toJSONString();

	}

	public static void main(String[] args) {
		String json = buildBody();
		// String host = "http://otatest.jiewen.com.cn/ota/recLogInfo";
		String host = "http://localhost:8080/recLogInfo";
		Map<String, String> params = new HashMap<>();
		params.put("body", json);
		logger.info(json);
		upload(host,
				new File("C:\\Users\\Administrator\\Desktop\\00021000064_20171114132828_com.vanstone.icbc.test5.zip"),
				params);
	}

	public void test() {
		/** do someThing */
	}

}
