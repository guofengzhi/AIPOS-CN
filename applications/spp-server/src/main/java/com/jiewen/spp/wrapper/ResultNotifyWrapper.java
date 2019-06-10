package com.jiewen.spp.wrapper;

/**
 * 
 * 更新结果通知包装类
 * @author guofengzhi
 *
 */
public class ResultNotifyWrapper extends BaseWrapper {

	// 商户号
	private String merNo;

	// 终端号
	private String termNo;

	// 文件名称
	private String fileName;

	// 文件版本
	private String fileVersion;

	// 文件类型
	private String fileType;

	// 更新结果
	private String upgradeResult;

	public String getMerNo() {
		return merNo;
	}

	public void setMerNo(String merNo) {
		this.merNo = merNo;
	}

	public String getTermNo() {
		return termNo;
	}

	public void setTermNo(String termNo) {
		this.termNo = termNo;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getFileVersion() {
		return fileVersion;
	}

	public void setFileVersion(String fileVersion) {
		this.fileVersion = fileVersion;
	}

	public String getFileType() {
		return fileType;
	}

	public void setFileType(String fileType) {
		this.fileType = fileType;
	}

	public String getUpgradeResult() {
		return upgradeResult;
	}

	public void setUpgradeResult(String upgradeResult) {
		this.upgradeResult = upgradeResult;
	}

}
