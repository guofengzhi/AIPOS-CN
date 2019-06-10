package com.jiewen.spp.wrapper;

import com.alibaba.fastjson.JSON;

/**
 * 
 * @author Administrator {"gprs":"1","lan":"1","wifi":"1","wcdma":"1","picc":"1","modem":"0",
 *         "led":"1","blueTooth":"1","mag":"1","gm":"1","location":"1","beep":"1",
 *         "cdma":"1","ic":"1","printer":"0"}
 *
 */
public class DeviceInfoWrapper {

    private String blueTooth;

    private String wifi;

    private String gprs;

    private String lan;

    private String wcdma;

    private String picc;

    private String modem;

    private String led;

    private String mag;

    private String gm;

    private String location;

    private String beep;

    private String cdma;

    private String ic;

    private String printer;

    public String getBlueTooth() {
        return blueTooth;
    }

    public void setBlueTooth(String blueTooth) {
        this.blueTooth = blueTooth;
    }

    public String getWifi() {
        return wifi;
    }

    public void setWifi(String wifi) {
        this.wifi = wifi;
    }

    public String getGprs() {
        return gprs;
    }

    public void setGprs(String gprs) {
        this.gprs = gprs;
    }

    public String getLan() {
        return lan;
    }

    public void setLan(String lan) {
        this.lan = lan;
    }

    public String getWcdma() {
        return wcdma;
    }

    public void setWcdma(String wcdma) {
        this.wcdma = wcdma;
    }

    public String getPicc() {
        return picc;
    }

    public void setPicc(String picc) {
        this.picc = picc;
    }

    public String getModem() {
        return modem;
    }

    public void setModem(String modem) {
        this.modem = modem;
    }

    public String getLed() {
        return led;
    }

    public void setLed(String led) {
        this.led = led;
    }

    public String getMag() {
        return mag;
    }

    public void setMag(String mag) {
        this.mag = mag;
    }

    public String getGm() {
        return gm;
    }

    public void setGm(String gm) {
        this.gm = gm;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getBeep() {
        return beep;
    }

    public void setBeep(String beep) {
        this.beep = beep;
    }

    public String getCdma() {
        return cdma;
    }

    public void setCdma(String cdma) {
        this.cdma = cdma;
    }

    public String getIc() {
        return ic;
    }

    public void setIc(String ic) {
        this.ic = ic;
    }

    public String getPrinter() {
        return printer;
    }

    public void setPrinter(String printer) {
        this.printer = printer;
    }

    @Override
    public String toString() {
        return JSON.toJSONString(this);
    }

}
