package com.jiewen.spp.async;

import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

import com.jiewen.spp.dao.TransLogMapper;
import com.jiewen.spp.model.TransLog;

@Component
public class AsyncTask {
    
    @Async
    public void saveTransLogTask(TransLog transLog, TransLogMapper transLogMapper){
        transLogMapper.insertSelective(transLog);
    }

}
