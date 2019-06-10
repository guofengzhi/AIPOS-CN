package com.jiewen.modules.device.entity;

import com.jiewen.jwp.base.entity.DataEntity;

/**
 * 2017年11月14日
 * 
 * @author Pang.M
 *
 */
public class RecordInfo extends DataEntity<RecordInfo> {

    private static final long serialVersionUID = 1L;

    private String parentId; // 上一级记录ID

    private String status; // 状态

    private String packageInfo; // 包数据

    private String recordDateTime; // 记录日期时间

    private String packagePath; // 包路径

    private String packageName; // 包名称

    public String getParentId() {
        return parentId;
    }

    public void setParentId(String parentId) {
        this.parentId = parentId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPackageInfo() {
        return packageInfo;
    }

    public void setPackageInfo(String packageInfo) {
        this.packageInfo = packageInfo;
    }

    public String getRecordDateTime() {
        return recordDateTime;
    }

    public void setRecordDateTime(String recordDateTime) {
        this.recordDateTime = recordDateTime;
    }

    public String getPackagePath() {
        return packagePath;
    }

    public void setPackagePath(String packagePath) {
        this.packagePath = packagePath;
    }

    public String getPackageName() {
        return packageName;
    }

    public void setPackageName(String packageName) {
        this.packageName = packageName;
    }

}
