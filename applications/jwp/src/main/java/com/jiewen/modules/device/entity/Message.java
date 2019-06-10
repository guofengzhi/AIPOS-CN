package com.jiewen.modules.device.entity;

import com.jiewen.jwp.base.entity.DataEntity;
import com.jiewen.modules.rom.entity.PushRec;

public class Message extends DataEntity<PushRec> {

    private static final long serialVersionUID = 1L;

    private String action;

    private String message;

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

}
