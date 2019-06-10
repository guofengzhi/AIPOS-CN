package com.jiewen.modules.device.entity;

import java.io.Serializable;

public class FileInfo implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 文件或目录名称
     */
    private String fileName;

    /**
     * 文件目录标志
     */
    private String fileFlag;

    /**
     * 文件件大小
     */
    private String length;

    /**
     * 文件时间
     */
    private String fileTimes;

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFileFlag() {
        return fileFlag;
    }

    public void setFileFlag(String fileFlag) {
        this.fileFlag = fileFlag;
    }

    public String getLength() {
        return length;
    }

    public void setLength(String length) {
        this.length = length;
    }

    public String getFileTimes() {
        return fileTimes;
    }

    public void setFileTimes(String fileTimes) {
        this.fileTimes = fileTimes;
    }

}
