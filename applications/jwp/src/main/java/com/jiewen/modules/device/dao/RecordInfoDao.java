package com.jiewen.modules.device.dao;

import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.modules.device.entity.RecordInfo;

public interface RecordInfoDao extends CrudDao<RecordInfo> {

    public RecordInfo findById(RecordInfo recordInfo);
}
