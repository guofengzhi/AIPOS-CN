
package com.jiewen.spp.modules.rom.entity;

import com.jiewen.base.core.entity.DataEntity;

public class PushRec extends DataEntity<PushRec> {

    private static final long serialVersionUID = 1L;

    private String osId;

    private String deviceId;

    private String messageContent;

    public String getOsId() {
        return osId;
    }

    public void setOsId(String osId) {
        this.osId = osId;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public String getMessageContent() {
        return messageContent;
    }

    public void setMessageContent(String messageContent) {
        this.messageContent = messageContent;
    }

}
