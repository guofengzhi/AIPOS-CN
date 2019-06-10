package com.jiewen.spp.modules.tms.entity;

import java.util.Date;

import com.jiewen.base.core.entity.DataEntity;

/**
 * 更新物文件 实体
 * 
 * @author guofengzhi
 */
public class UpdateItems extends DataEntity<UpdateItems> {

	private static final long serialVersionUID = -8905585018644727239L;

	private String fileName; // 更新物名称

	private String fileType; // 文件类型

	private String fileSize; // 文件大小

	private String fileVersion; // 版本

	private String filePath; // 文件路径

	private Date uploadTime; // 上传时间

	private String manufactureNo; // 厂商编号

	private String organId; // 机构号

	private String strategyId;

	public String getStrategyId() {
		return strategyId;
	}

	public void setStrategyId(String strategyId) {
		this.strategyId = strategyId;
	}

	private String md5; //文件md5值
	
	public String getMd5() {
		return md5;
	}

	public void setMd5(String md5) {
		this.md5 = md5;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getFileType() {
		return fileType;
	}

	public void setFileType(String fileType) {
		this.fileType = fileType;
	}

	public String getFileSize() {
		return fileSize;
	}

	public void setFileSize(String fileSize) {
		this.fileSize = fileSize;
	}

	public String getFileVersion() {
		return fileVersion;
	}

	public void setFileVersion(String fileVersion) {
		this.fileVersion = fileVersion;
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public Date getUploadTime() {
		return uploadTime;
	}

	public void setUploadTime(Date uploadTime) {
		this.uploadTime = uploadTime;
	}

	public String getManufactureNo() {
		return manufactureNo;
	}

	public void setManufactureNo(String manufactureNo) {
		this.manufactureNo = manufactureNo;
	}

	public String getOrganId() {
		return organId;
	}

	public void setOrganId(String organId) {
		this.organId = organId;
	}

}
