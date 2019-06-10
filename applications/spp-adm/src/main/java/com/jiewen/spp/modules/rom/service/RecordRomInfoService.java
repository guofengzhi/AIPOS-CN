
package com.jiewen.spp.modules.rom.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.jiewen.base.core.service.CrudService;
import com.jiewen.spp.modules.rom.dao.RecordRomInfoDao;
import com.jiewen.spp.modules.rom.entity.RecordRomInfo;

@Service
@Transactional
public class RecordRomInfoService extends CrudService<RecordRomInfoDao, RecordRomInfo> {

    @Autowired
    private RecordRomInfoDao recordRomInfoDao;

    @Override
    public List<RecordRomInfo> findList(RecordRomInfo recordRomInfo) {
        return dao.findList(recordRomInfo);
    }

    @Override
    public PageInfo<RecordRomInfo> findPage(RecordRomInfo recordRomInfo) {
        PageHelper.startPage(recordRomInfo);
        return new PageInfo<>(recordRomInfoDao.findList(recordRomInfo));
    }

    @Transactional(readOnly = false)
    @Override
    public void save(RecordRomInfo recordRomInfo) {
        recordRomInfo.preInsert(false);
        dao.insert(recordRomInfo);
    }

}
