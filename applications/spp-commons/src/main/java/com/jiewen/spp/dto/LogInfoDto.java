package com.jiewen.spp.dto;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Transient;

public class LogInfoDto implements Serializable, Comparable<LogInfoDto> {

    /**
     * 
     */
    private static final long serialVersionUID = 1L;

    /**
     * ID
     */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @Transient
    private String version;
    @Transient
    private String manufacturerNo;
    @Transient
    private String deviceType;
    @Transient
    private String sn;
    @Transient
    private String logName;
    @Transient
    private String logMd5;
    @Transient
    private String fileSzie;
    @Transient
    private String filePath;
    @Transient
    private Date recDate;

    public Date getRecDate() {
        return recDate;
    }

    public void setRecDate(Date recDate) {
        this.recDate = recDate;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public String getManufacturerNo() {
        return manufacturerNo;
    }

    public void setManufacturerNo(String manufacturerNo) {
        this.manufacturerNo = manufacturerNo;
    }

    public String getDeviceType() {
        return deviceType;
    }

    public void setDeviceType(String deviceType) {
        this.deviceType = deviceType;
    }

    public String getSn() {
        return sn;
    }

    public void setSn(String sn) {
        this.sn = sn;
    }

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

    public String getFileSzie() {
        return fileSzie;
    }

    public void setFileSzie(String fileSzie) {
        this.fileSzie = fileSzie;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    @Override
    public int compareTo(LogInfoDto arg0) {
        // TODO Auto-generated method stub
        return 0;
    }

}
