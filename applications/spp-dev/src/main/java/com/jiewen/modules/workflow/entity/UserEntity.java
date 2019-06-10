package com.jiewen.modules.workflow.entity;

import com.jiewen.jwp.base.entity.DataEntity;

public class UserEntity extends DataEntity {

    private static final long serialVersionUID = 1L;

    private String name;

    private String groupId;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getGroupId() {
        return groupId;
    }

    public void setGroupId(String groupId) {
        this.groupId = groupId;
    }

}
