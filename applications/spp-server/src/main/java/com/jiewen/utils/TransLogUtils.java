package com.jiewen.utils;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.alibaba.fastjson.JSONObject;
import com.jiewen.spp.async.AsyncTask;
import com.jiewen.spp.dao.TransLogMapper;
import com.jiewen.spp.model.TransLog;

@Component
public class TransLogUtils {
    @Autowired
    private AsyncTask asyncTask;
    
    @Autowired
    private TransLogMapper transLogMapper;
    
    public void asyncSaveTransLog(JSONObject json, String urlName){
        TransLog transLog = new TransLog();
        transLog.setDeviceSn(json.getString(RspJsonNode.SN));
        transLog.setDeviceType(json.getString(RspJsonNode.DEVICE_TYPE));
        transLog.setDelFlag("0");
        transLog.setMethodName(urlName);
        transLog.setPacketInfo(json.toJSONString());
        transLog.setCreateDate(new Date());
        transLog.setUpdateDate(new Date());
        transLog.setManuNo(json.getString(RspJsonNode.MANUFACTURER));
        
        asyncTask.saveTransLogTask(transLog, transLogMapper);
    }
    
    
}

