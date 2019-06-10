package com.jiewen.jwp.base.utils;

import java.io.File;
import java.io.FileInputStream;

import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPSClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.alibaba.druid.util.StringUtils;
import com.jiewen.commons.util.IOUtil;

/**
 * @author cr7 文件上传ftp工具类
 */
public class FtpUtils {

	public static boolean uploadFtp(File file, String savePath) {
		boolean changeFlag = false;
		FileInputStream in = null;
		try {
			if (!StringUtils.isEmpty(Host) && !StringUtils.isEmpty(Username) && !StringUtils.isEmpty(Password)) {
				//FTPClient ftpClient = new FTPClient();
				FTPSClient ftpClient = new FTPSClient();
				in = new FileInputStream(file);
				ftpClient.connect(Host);
				ftpClient.login(Username, Password);
				ftpClient.setFileType(FTP.BINARY_FILE_TYPE);
				
				changeFlag = ftpClient.changeWorkingDirectory(savePath);
				if(!changeFlag){
					boolean makeDirectory = ftpClient.makeDirectory(savePath);
					if(makeDirectory){
						changeFlag = ftpClient.changeWorkingDirectory(savePath);
					}
				}
				String name = new String(file.getName().getBytes(LOCAL_CHARSET), SERVER_CHARSET);
				ftpClient.storeFile(name, in);
				ftpClient.sendSiteCommand("chmod 755 " + name);
				ftpClient.disconnect();
			}
		} catch (Exception e) {
			logger.error("ftp文件上傳失敗", e);
		} finally {
			IOUtil.closeQuietly(in);
		}
		return changeFlag;
	}
	
	private final static String LOCAL_CHARSET = "GBK";

	private final static String SERVER_CHARSET = "ISO-8859-1";

	private static String Host;

	private static String Username;

	private static String Password;

	private final static Logger logger = LoggerFactory.getLogger(Logger.class);

	public static void setHost(String host) {
		Host = host;
	}

	public static void setUsername(String username) {
		Username = username;
	}

	public static void setPassword(String password) {
		Password = password;
	}

}
