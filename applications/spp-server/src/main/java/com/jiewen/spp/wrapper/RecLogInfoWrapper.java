package com.jiewen.spp.wrapper;

public class RecLogInfoWrapper extends BaseWrapper {

	// 日志文件名称
	private String logName;

	// 日志文件MD5
	private String logMd5;

	public String getLogName() {
		return logName;
	}

	public void setLogName(String logName) {
		this.logName = logName;
	}

	public String getLogMd5() {
		return logMd5;
	}

	public void setLogMd5(String logMd5) {
		this.logMd5 = logMd5;
	}

	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return super.toString();
	}

}
