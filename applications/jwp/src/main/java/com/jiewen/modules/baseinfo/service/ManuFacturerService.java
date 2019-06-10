package com.jiewen.modules.baseinfo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jiewen.jwp.base.service.CrudService;
import com.jiewen.jwp.base.utils.CacheUtils;
import com.jiewen.modules.baseinfo.dao.ManuFacturerDao;
import com.jiewen.modules.baseinfo.entity.ManuFacturer;

@Service
public class ManuFacturerService extends CrudService<ManuFacturerDao, ManuFacturer> {

    @Autowired
    private ManuFacturerDao manuFacturerDao;

    private static final String MANUFACTURY = "manufactury";

    public List<ManuFacturer> findList() {
        @SuppressWarnings("unchecked")
        List<ManuFacturer> manuFacturers = (List<ManuFacturer>) CacheUtils.get(MANUFACTURY);
        if (manuFacturers == null || manuFacturers.isEmpty()) {
            manuFacturers = dao.findList(new ManuFacturer());
            CacheUtils.put(MANUFACTURY, manuFacturers);
        }
        return manuFacturers;
    }

    @Transactional(readOnly = false)
    public void deleteById(ManuFacturer manuFacturer) {
        dao.delete(manuFacturer);
        CacheUtils.remove(MANUFACTURY);
    }

    public ManuFacturer getManuFacturerById(ManuFacturer manuFacturer) {
        return manuFacturerDao.get(manuFacturer.getId());
    }

    @Transactional(readOnly = false)
    public void saveManuFacturer(ManuFacturer manuFacturer) {
        manuFacturer.preInsert(true);
        dao.insert(manuFacturer);
        CacheUtils.remove(MANUFACTURY);
    }

    @Transactional(readOnly = false)
    public void update(ManuFacturer manuFacturer) {
        manuFacturer.preUpdate();
        dao.update(manuFacturer);
        CacheUtils.remove(MANUFACTURY);
    }

    public ManuFacturer findManuFacturerByNo(String manufacturerNo) {
        return manuFacturerDao.findManuFacturerByNo(manufacturerNo);
    }

    public ManuFacturer findManuFacturerByName(String manufacturerName) {
        return manuFacturerDao.findManuFacturerByName(manufacturerName);
    }

}
