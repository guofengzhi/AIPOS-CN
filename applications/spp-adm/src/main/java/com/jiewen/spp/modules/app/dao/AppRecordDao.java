
package com.jiewen.spp.modules.app.dao;

import com.jiewen.base.core.dao.CrudDao;
import com.jiewen.spp.modules.app.entity.AppRecord;

public interface AppRecordDao extends CrudDao<AppRecord> {

    public void deleteAppRecordByApkId(String apkId);

}
