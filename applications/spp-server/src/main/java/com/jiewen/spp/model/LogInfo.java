package com.jiewen.spp.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

@Table(name = "t_log_file")
public class LogInfo {
	/**
	 * ID
	 */
	@Id
	private String id;

	/**
	 * 版本号
	 */
	private String version;

	/**
	 * 厂商编号
	 */
	@Column(name = "manufacturer_no")
	private String manufacturerNo;

	/**
	 * 设备型号
	 */
	@Column(name = "device_type")
	private String deviceType;

	/**
	 * 设备序列号
	 */
	private String sn;

	/**
	 * 日志文件名称
	 */
	@Column(name = "log_name")
	private String logName;

	/**
	 * 日志文件MD5
	 */
	@Column(name = "log_md5")
	private String logMd5;

	/**
	 * 文件大小
	 */
	@Column(name = "file_size")
	private Long fileSize;

	/**
	 * 文件路径
	 */
	@Column(name = "file_path")
	private String filePath;

	/**
	 * 上传时间
	 */
	@Column(name = "rec_date")
	private Date recDate;

	/**
	 * 获取ID
	 *
	 * @return id - ID
	 */
	public String getId() {
		return id;
	}

	/**
	 * 设置ID
	 *
	 * @param id
	 *            ID
	 */
	public void setId(String id) {
		this.id = id;
	}

	/**
	 * 获取版本号
	 *
	 * @return version - 版本号
	 */
	public String getVersion() {
		return version;
	}

	/**
	 * 设置版本号
	 *
	 * @param version
	 *            版本号
	 */
	public void setVersion(String version) {
		this.version = version;
	}

	/**
	 * 获取厂商编号
	 *
	 * @return manufacturer_no - 厂商编号
	 */
	public String getManufacturerNo() {
		return manufacturerNo;
	}

	/**
	 * 设置厂商编号
	 *
	 * @param manufacturerNo
	 *            厂商编号
	 */
	public void setManufacturerNo(String manufacturerNo) {
		this.manufacturerNo = manufacturerNo;
	}

	/**
	 * 获取设备型号
	 *
	 * @return device_type - 设备型号
	 */
	public String getDeviceType() {
		return deviceType;
	}

	/**
	 * 设置设备型号
	 *
	 * @param deviceType
	 *            设备型号
	 */
	public void setDeviceType(String deviceType) {
		this.deviceType = deviceType;
	}

	/**
	 * 获取设备序列号
	 *
	 * @return sn - 设备序列号
	 */
	public String getSn() {
		return sn;
	}

	/**
	 * 设置设备序列号
	 *
	 * @param sn
	 *            设备序列号
	 */
	public void setSn(String sn) {
		this.sn = sn;
	}

	/**
	 * 获取日志文件名称
	 *
	 * @return log_name - 日志文件名称
	 */
	public String getLogName() {
		return logName;
	}

	/**
	 * 设置日志文件名称
	 *
	 * @param logName
	 *            日志文件名称
	 */
	public void setLogName(String logName) {
		this.logName = logName;
	}

	/**
	 * 获取日志文件MD5
	 *
	 * @return log_md5 - 日志文件MD5
	 */
	public String getLogMd5() {
		return logMd5;
	}

	/**
	 * 设置日志文件MD5
	 *
	 * @param logMd5
	 *            日志文件MD5
	 */
	public void setLogMd5(String logMd5) {
		this.logMd5 = logMd5;
	}

	/**
	 * 获取文件大小
	 *
	 * @return file_size - 文件大小
	 */
	public Long getFileSize() {
		return fileSize;
	}

	/**
	 * 设置文件大小
	 *
	 * @param fileSize
	 *            文件大小
	 */
	public void setFileSize(Long fileSize) {
		this.fileSize = fileSize;
	}

	/**
	 * 获取文件路径
	 *
	 * @return file_path - 文件路径
	 */
	public String getFilePath() {
		return filePath;
	}

	/**
	 * 设置文件路径
	 *
	 * @param filePath
	 *            文件路径
	 */
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	/**
	 * 获取上传时间
	 *
	 * @return rec_date - 上传时间
	 */
	public Date getRecDate() {
		return recDate;
	}

	/**
	 * 设置上传时间
	 *
	 * @param recDate
	 *            上传时间
	 */
	public void setRecDate(Date recDate) {
		this.recDate = recDate;
	}
}