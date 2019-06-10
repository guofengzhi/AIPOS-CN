package com.jiewen.apkutils.packinfo.bean;

import java.util.ArrayList;
import java.util.List;

public class ApkInfo {

    private String versionCode = "";

    private String versionName = "";

    private String packageName = "";

    private String signature = "";

    private String minSdkVersion = "";

    private String targetSdkVersion = "";

    private boolean isV1SignatureOK = false;

    private boolean isV2Signature = false;

    private boolean isV2SignatureOK = false;

    private String v2CheckErrorInfo = "";

    private List<String> permissions = new ArrayList<>();

    public String getVersionCode() {
        return versionCode;
    }

    public void setVersionCode(String versionCode) {
        this.versionCode = versionCode;
    }

    public String getVersionName() {
        return versionName;
    }

    public void setVersionName(String versionName) {
        this.versionName = versionName;
    }

    public String getPackageName() {
        return packageName;
    }

    public void setPackageName(String packageName) {
        this.packageName = packageName;
    }

    public String getSignature() {
        return signature;
    }

    public void setSignature(String signature) {
        this.signature = signature;
    }

    public String getMinSdkVersion() {
        return minSdkVersion;
    }

    public void setMinSdkVersion(String minSdkVersion) {
        this.minSdkVersion = minSdkVersion;
    }

    public String getTargetSdkVersion() {
        return targetSdkVersion;
    }

    public void setTargetSdkVersion(String targetSdkVersion) {
        this.targetSdkVersion = targetSdkVersion;
    }

    public boolean isV1SignatureOK() {
        return isV1SignatureOK;
    }

    public void setV1SignatureOK(boolean isV1SignatureOK) {
        this.isV1SignatureOK = isV1SignatureOK;
    }

    public boolean isV2Signature() {
        return isV2Signature;
    }

    public void setV2Signature(boolean isV2Signature) {
        this.isV2Signature = isV2Signature;
    }

    public boolean isV2SignatureOK() {
        return isV2SignatureOK;
    }

    public void setV2SignatureOK(boolean isV2SignatureOK) {
        this.isV2SignatureOK = isV2SignatureOK;
    }

    public String getV2CheckErrorInfo() {
        return v2CheckErrorInfo;
    }

    public void setV2CheckErrorInfo(String v2CheckErrorInfo) {
        this.v2CheckErrorInfo = v2CheckErrorInfo;
    }

    public List<String> getPermissions() {
        return permissions;
    }

    public void setPermissions(List<String> permissions) {
        this.permissions = permissions;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("  包名: " + packageName + "\n");
        sb.append("  版本名: " + versionName + "\n");
        sb.append("  版本号: " + versionCode + "\n");
        sb.append("  签名文件MD5: " + signature + "\n");
        sb.append("  V1签名验证通过: " + isV1SignatureOK + "\n");
        sb.append("  使用V2签名: " + isV2Signature + "\n");
        sb.append("  V2签名验证通过: " + isV2SignatureOK + "\n");
        if (!isV1SignatureOK || (isV2Signature && !isV2SignatureOK)) {
            sb.append("  签名验证失败原因: " + v2CheckErrorInfo + "\n");
        }
        return sb.toString();
    }

}
