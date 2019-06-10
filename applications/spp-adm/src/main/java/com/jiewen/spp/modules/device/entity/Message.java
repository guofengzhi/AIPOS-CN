
package com.jiewen.spp.modules.device.entity;

import com.jiewen.base.core.entity.DataEntity;
import com.jiewen.spp.modules.rom.entity.PushRec;

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
