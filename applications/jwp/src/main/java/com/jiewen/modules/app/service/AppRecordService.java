package com.jiewen.modules.app.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jiewen.jwp.base.service.CrudService;
import com.jiewen.modules.app.dao.AppRecordDao;
import com.jiewen.modules.app.entity.AppRecord;

@Service
@Transactional(readOnly = true)
public class AppRecordService extends CrudService<AppRecordDao, AppRecord> {

    @Transactional(readOnly = false)
    public void save(AppRecord appRecord) {
        appRecord.preInsert(true);
        dao.insert(appRecord);
    }

}
