package com.jiewen.modules.device.entity;

import java.io.Serializable;

public class DeviceInfo implements Serializable {

    /**
     * 
     */
    private static final long serialVersionUID = 1L;

    private String serialno;

    private String model;

    private String manufacture;

    private String androidosversion;

    private String printinfo;

    private String magcard;

    private String iccard;

    private String contactless;

    private String internet;

    private String totalmemory;

    private String availmemory;

    private String battery;
    
    private String gprs;

    private String lan;

    private String wifi;

    private String wcdma;
    
    private String bluetooth;
    
    private String printer;

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

	public String getWifi() {
		return wifi;
	}

	public void setWifi(String wifi) {
		this.wifi = wifi;
	}

	public String getWcdma() {
		return wcdma;
	}

	public void setWcdma(String wcdma) {
		this.wcdma = wcdma;
	}

	public String getBluetooth() {
		return bluetooth;
	}

	public void setBluetooth(String bluetooth) {
		this.bluetooth = bluetooth;
	}

	public String getPrinter() {
		return printer;
	}

	public void setPrinter(String printer) {
		this.printer = printer;
	}

	public String getSerialno() {
		return serialno;
	}

	public void setSerialno(String serialno) {
		this.serialno = serialno;
	}

	public String getModel() {
		return model;
	}

	public void setModel(String model) {
		this.model = model;
	}

	public String getManufacture() {
		return manufacture;
	}

	public void setManufacture(String manufacture) {
		this.manufacture = manufacture;
	}

	public String getAndroidosversion() {
		return androidosversion;
	}

	public void setAndroidosversion(String androidosversion) {
		this.androidosversion = androidosversion;
	}

	public String getPrintinfo() {
		return printinfo;
	}

	public void setPrintinfo(String printinfo) {
		this.printinfo = printinfo;
	}

	public String getMagcard() {
		return magcard;
	}

	public void setMagcard(String magcard) {
		this.magcard = magcard;
	}

	public String getIccard() {
		return iccard;
	}

	public void setIccard(String iccard) {
		this.iccard = iccard;
	}

	public String getContactless() {
		return contactless;
	}

	public void setContactless(String contactless) {
		this.contactless = contactless;
	}

	public String getInternet() {
		return internet;
	}

	public void setInternet(String internet) {
		this.internet = internet;
	}

	public String getTotalmemory() {
		return totalmemory;
	}

	public void setTotalmemory(String totalmemory) {
		this.totalmemory = totalmemory;
	}

	public String getAvailmemory() {
		return availmemory;
	}

	public void setAvailmemory(String availmemory) {
		this.availmemory = availmemory;
	}

	public String getBattery() {
		return battery;
	}

	public void setBattery(String battery) {
		this.battery = battery;
	}


}
