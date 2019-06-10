package com.jiewen.ota;

import java.io.UnsupportedEncodingException;

import com.jiewen.commons.util.Base64;
import com.jiewen.utils.ReadFtpFileUtil;

public class ReadFtpFileTest {

	private static String ip = "172.31.231.122"; // 服务器IP地址
	private static String userName = "sppftp"; // 用户名
	private static String userPwd = "UPpm-Nm-HqEK"; // 密码
	private static String path = "tms/test.txt"; // 文件目录

	public static void main(String[] args) {
		try {
			long start = 10;
			ReadFtpFileUtil.setHost(ip);
			ReadFtpFileUtil.setUsername(userName);
			ReadFtpFileUtil.setPassword(userPwd);
			String str = ReadFtpFileUtil.readFile(start, path);
			System.out.println(str);
			System.out.println(new String(Base64.decode(str), "gbk").trim());
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
