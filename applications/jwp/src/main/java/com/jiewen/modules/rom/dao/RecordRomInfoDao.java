package com.jiewen.modules.rom.dao;

import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.modules.rom.entity.RecordRomInfo;

public interface RecordRomInfoDao extends CrudDao<RecordRomInfo> {

    public void deleteRomRecordByOsId(String osId);

}
