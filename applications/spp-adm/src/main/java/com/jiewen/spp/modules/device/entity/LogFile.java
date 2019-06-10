
package com.jiewen.spp.modules.device.entity;

import com.jiewen.base.core.entity.DataEntity;

public class LogFile extends DataEntity<LogFile> {

    /**
     * 
     */
    private static final long serialVersionUID = 1L;

    /**
     * 版本号
     */
    private String version;

    /**
     * 厂商编号
     */
    private String manufacturerNo;

    /**
     * 设备型号
     */
    private String deviceType;

    /**
     * 设备序列号
     */
    private String sn;

    /**
     * 日志文件名称
     */
    private String logName;

    /**
     * 日志文件MD5
     */
    private String logMd5;

    /**
     * 文件大小
     */
    private Integer fileSize;

    /**
     * 文件路径
     */
    private String filePath;

    /**
     * 上传时间
     */
    private String recDate;

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
    public Integer getFileSize() {
        return fileSize;
    }

    /**
     * 设置文件大小
     *
     * @param fileSize
     *            文件大小
     */
    public void setFileSize(Integer fileSize) {
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
    public String getRecDate() {
        return recDate;
    }

    /**
     * 设置上传时间
     *
     * @param recDate
     *            上传时间
     */
    public void setRecDate(String recDate) {
        this.recDate = recDate;
    }
}