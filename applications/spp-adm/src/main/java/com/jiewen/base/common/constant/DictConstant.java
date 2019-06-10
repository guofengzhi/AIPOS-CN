
package com.jiewen.base.common.constant;

public class DictConstant {

	public static final String DEVICE_INFO_STATUS = "device_info_status";

	public static final String DEVICE_STATUS = "device_status";

	public static final String DEVICE_INTERNET_STATUS = "device_internet_status";

	private DictConstant() {
		throw new IllegalStateException("Utility class");
	}

	public class AppStatus {

		/** 0-已上线 **/
		public static final String ALREADY_ONLINE = "0";
		/** 1-审核中 **/
		public static final String IN_REVIEW = "1";
		/** 2-审核未通过 **/
		public static final String UNAPPROVE = "2";
		/** 4-已下线 **/
		public static final String ALREADY_DOWNLINE = "3";
	}

	public class AdvertisementStatus {

		/** 0-未审核 **/
		public static final String ALREADY_ONLINE = "0";
		/** 1-创建 **/
		public static final String IN_REVIEW = "1";
		/** 2-发布 **/
		public static final String UNAPPROVE = "2";
		/** 3-审核通过 **/
		public static final String ALREADY_DOWNLINE = "3";

		/** 4-拒绝审核 **/
		public static final String ALREADY_REFUSED = "4";

		/** T-文字 **/
		public static final String AD_TEXT = "T";

		/** I-图片 **/
		public static final String AD_PICTURE = "I";

		/** V-视频 **/
		public static final String AD_VOICE = "VO";

		/** VO-语音 **/
		public static final String AD_VIDEO = "V";

	}
}
