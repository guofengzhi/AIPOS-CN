package com.jiewen.constant;

public final class ControlCommand {

	/** 系统升级 **/
	public static final String SYSTEM_UPGRADE = "UpgradeRom";

	/** 系统更新 **/
	public static final String APP_UPGRADE = "UpgradeApp";

	/** 应用卸载 **/
	public static final String APP_UNINSTALL = "Uninstall";

	/** 恢复出厂设置 **/
	public static final String RESET_FACTORY_SETTINGS = "Reset";

	/** 设备远程激活 **/
	public static final String DEVICE_REMOTE_ACTIVTIOAN = "Activation";

	/** 锁屏 **/
	public static final String LOCK_SCREEN = "LockScreen";

	/** 禁用摄像头 **/
	public static final String DISABLE_CAMERA = "DisableCamera";

	/** Root检测 **/
	public static final String ROOT_DETECT = "RootDetect";

	/** 秘钥下载更新 **/
	public static final String KEY_UPDATE = "KeyDownUpdate";

	/** 设备远程锁定 **/
	public static final String DEVICE_REMOTE_LOCK = "LockDevice";

	/** 数据擦除 **/
	public static final String DATA_ERASURE = "DataEras";

	/** 远程获取日志 **/
	public static final String REMOTE_ACCESS_LOG = "LogGet";

	/** 获取设备 **/
	public static final String GET_DEVICE_INFO = "getDeviceInfo";

	public static class Option {

		private Option() {
		}

		/** 操作处理 F-获取目录 **/
		public static final String OPTION_F = "F";

		/** 操作处理 L-文件上传 **/
		public static final String OPTION_L = "L";

		/** 操作处理 P-参数处理 **/
		public static final String OPTION_P = "P";
	}

	public static class Upgrade {
		private Upgrade() {
		}

		/** 是否升级- 否 */
		public static final String UPGRADE_NO = "0";

		/** 是否升级- 是 */
		public static final String UPGRADE_YES = "1";

	}

	public static final String ACTION = "action";

	public static final String MESSAGE = "message";

	public static final String MSGCONTENT = "upgrade";

	public static final String SECURE_ELEMENT_PACKAGE = "com.vanstone.hsmse"; // 安全单元包名

	public static final String COMMON_BANK_NAME = "all";

	private ControlCommand() {
	}

}