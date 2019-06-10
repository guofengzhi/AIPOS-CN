package com.jiewen.spp.wrapper;

import com.alibaba.fastjson.JSON;

/**
 * Created by CodeGenerator on 2017/11/14.
 * 
 * @author Pang.M
 * 
 */
public class DirectoryWrapper {

    private String fileName; // 文件或目录名称

    private String fileFlag; // 文件目录标志 0-目录，1-文件

    private String length; // 文件大小

    private String fileTime; // 文件时间

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

    public String getFileTime() {
        return fileTime;
    }

    public void setFileTime(String fileTime) {
        this.fileTime = fileTime;
    }

    @Override
    public String toString() {
        return JSON.toJSONString(this);
    }

}
