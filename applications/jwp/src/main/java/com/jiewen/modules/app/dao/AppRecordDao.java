package com.jiewen.modules.app.dao;

import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.modules.app.entity.AppRecord;

public interface AppRecordDao extends CrudDao<AppRecord> {

    public void deleteAppRecordByApkId(String apkId);

}
