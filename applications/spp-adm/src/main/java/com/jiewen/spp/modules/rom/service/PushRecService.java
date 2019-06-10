
package com.jiewen.spp.modules.rom.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jiewen.base.core.service.CrudService;
import com.jiewen.spp.modules.rom.dao.PushRecDao;
import com.jiewen.spp.modules.rom.entity.PushRec;

@Service
public class PushRecService extends CrudService<PushRecDao, PushRec> {

    @Transactional(readOnly = false)
    public void insert(PushRec pushRec) {
        pushRec.preInsert(true);
        dao.insert(pushRec);
    }

}
