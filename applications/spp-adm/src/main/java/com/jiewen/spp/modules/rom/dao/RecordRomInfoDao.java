
package com.jiewen.spp.modules.rom.dao;

import com.jiewen.base.core.dao.CrudDao;
import com.jiewen.spp.modules.rom.entity.RecordRomInfo;

public interface RecordRomInfoDao extends CrudDao<RecordRomInfo> {

    public void deleteRomRecordByOsId(String osId);

}
