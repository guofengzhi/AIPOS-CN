package com.jiewen.modules.app.entity;

import com.jiewen.jwp.base.entity.DataEntity;



public class AppDeveloper extends DataEntity {

    private static final long serialVersionUID = 1L;

    private String name;

    private String phone;

    private String company;

    private String address;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getCompany() {
        return company;
    }

    public void setCompany(String company) {
        this.company = company;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

}
