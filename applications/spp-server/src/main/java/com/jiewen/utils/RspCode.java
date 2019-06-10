package com.jiewen.utils;

/**
 * 响应码
 * 
 * @see 《OTA服务平台接口文档》-错误码
 * 
 * 
 */
public class RspCode {

	/** 系统错误 **/
	public static final String SYSTEM_ERROR = "SYSTEM_ERROR";

	/** 参数错误 **/
	public static final String PARAM_ERROR = "PARAM_ERROR";

	/** 签名错误 **/
	public static final String SIGN_ERROR = "SIGN_ERROR";

	/** token验证失败 **/
	public static final String TOKEN_VALID_ERROR = "TOKEN_VALID_ERROR";
	
	/** 终端超出范围 **/
	public static final String DEVICE_SCOPE_OVERRUN = "DEVICE_SCOPE_OVERRUN";


	public static final String NO_DEVICE_ERROR = "NO_DEVICE_ERROR";

	private RspCode() {
	}

}