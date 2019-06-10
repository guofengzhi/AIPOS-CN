
package com.jiewen.spp.modules.app.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jiewen.base.core.service.CrudService;
import com.jiewen.spp.modules.app.dao.AppRecordDao;
import com.jiewen.spp.modules.app.entity.AppRecord;

@Service
@Transactional(readOnly = true)
public class AppRecordService extends CrudService<AppRecordDao, AppRecord> {

    @Transactional(readOnly = false)
    public void save(AppRecord appRecord) {
        appRecord.preInsert(true);
        dao.insert(appRecord);
    }

}
