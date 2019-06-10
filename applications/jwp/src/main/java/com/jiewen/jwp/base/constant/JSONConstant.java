package com.jiewen.jwp.base.constant;

/**
 * 用于项目内JSON KEY常量
 * 
 * @author Pang.M
 *
 */
public class JSONConstant {

	public class ZtreeNode {

		/** id **/
		public static final String TREE_ID = "id";

		/** Pid **/
		public static final String TREE_PID = "pId";

		/** name **/
		public static final String TREE_NAME = "name";

		/** target **/
		public static final String TREE_TARGET = "target";

		/** isParent **/
		public static final String NODE_IS_PARENT = "isParent";

		private ZtreeNode() {
		}

	}

	public class Result {

		/** true **/
		public static final String TRUE = "true";

		/** false **/
		public static final String FALSE = "false";

		private Result() {
		}
	}

	public class Flie {

		/** fileFlag **/
		public static final String FILE_FLAG = "fileFlag";

		/** fileName **/
		public static final String FILE_NAME = "fileName";

		/** length **/
		public static final String FILE_LENGTH = "length";

		/** fileTimes **/
		public static final String FILE_TIMES = "fileTimes";

		private Flie() {
		}
	}

	public class AppInfo {

		public static final String APP_NAME = "appName";

		public static final String APP_PACKAGE = "appPackage";

		public static final String APP_VERSION = "appVersion";
		
		public static final String APP_INSTALL_DATE = "installDate";

		private AppInfo() {
		}
	}

	public class JPush {

		public static final String OPTION = "option";

		public static final String APP_PATH = "appPath";

		public static final String APP_PACKAGE = "appPackage";

		public static final String TRANS_ID = "transId";

		private JPush() {
		}

	}

	private JSONConstant() {
	}
}
