package com.jiewen.utils;

import java.io.IOException;
import java.io.InputStream;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPReply;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.Base64Utils;

import com.jiewen.base.excetion.OTAExcetion;

/**
 * 从ftp上读固定位置的文件内容
 * 
 * @author Pang.M
 *
 */
public class ReadFtpFileUtil {

	private static String Host;

	private static String Username;

	private static String Password;

	private final static Logger logger = LoggerFactory.getLogger(ReadFtpFileUtil.class);

	/**
	 * 从ftp上读固定位置的文件段
	 * 
	 * @param start
	 * @param fileName
	 * @return
	 */
	public static String readFile(long start, String path) {
		InputStream ins = null;
		byte[] bs = null;
		FTPClient ftpClient = null;
		try {
			ftpClient = connectServer();

			// 从服务器上读取指定的文件
			ins = ftpClient.retrieveFileStream(path);
			ins.skip(start);
			//TODO 优化
			Thread.sleep(200);//等待网络分批发送完成
			int available = 0; //判断是否是最后一个不足1024字节的请求
			while(available == 0) { 
				available = ins.available();
			}
			if (available >= 1024) {
				bs = new byte[1024];
				ins.read(bs, 0, 1024);
			} else {
				bs = new byte[available];
				ins.read(bs, 0, available);
			}
		} catch (Exception e) {
			logger.error(e.toString());
			throw new OTAExcetion(RspCode.SYSTEM_ERROR, "系统错误,请联系服务商!");
		} finally {
			try {
				if (ins != null) {
					ins.close();
				}
				ftpClient.completePendingCommand();
				ftpClient.enterLocalPassiveMode();
				closeServer(ftpClient);
			} catch (IOException e) {
				logger.error(e.toString());
				throw new OTAExcetion(RspCode.SYSTEM_ERROR, "系统错误,请联系服务商!");
			} catch (Exception e) {
				logger.error(e.toString());
				throw new OTAExcetion(RspCode.SYSTEM_ERROR, "系统错误,请联系服务商!");
			}
		}
		return Base64Utils.encodeToString(bs);
	}

	/**
	 * 查看FTP服务器返回的状态码是否正确
	 * @param ftpClient
	 */
	private static void showReply(FTPClient ftpClient) {
		String[] replies = ftpClient.getReplyStrings();
        if (replies != null && replies.length > 0) {
            for (String aReply : replies) {
            	logger.info("server return reply: " + aReply);
            }
        }
	}
	/**
	 * 链接ftp服务器
	 * 
	 * @param ip
	 * @param userName
	 * @param userPwd
	 * @param path
	 */
	private static FTPClient connectServer() {
		FTPClient ftpClient = new FTPClient();
		try {
			// 连接
			ftpClient.connect(Host);
			showReply(ftpClient);
			int replyCode = ftpClient.getReplyCode();
            if (!FTPReply.isPositiveCompletion(replyCode)) {
                logger.error("server connected filed. Server reply code: " + replyCode);
            }
//			 登录
			boolean loginResult = ftpClient.login(Username, Password);
			showReply(ftpClient);
			if (loginResult) {
				logger.info("logged in server");
			} else {
				logger.error("Could not login to the server");
			}
			ftpClient.login(Username, Password);
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw new OTAExcetion(RspCode.SYSTEM_ERROR, "ftp服务器连接失败");
		}
		return ftpClient;
	}

	/**
	 * 关闭ftp链接
	 */
	private static void closeServer(FTPClient ftpClient) {
		if (ftpClient.isConnected()) {
			try {
				ftpClient.logout();
				ftpClient.disconnect();
			} catch (Exception e) {
				logger.error(e.getMessage());
				throw new OTAExcetion(RspCode.SYSTEM_ERROR, "ftp服务器关闭失败");
			}
		}
	}

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
