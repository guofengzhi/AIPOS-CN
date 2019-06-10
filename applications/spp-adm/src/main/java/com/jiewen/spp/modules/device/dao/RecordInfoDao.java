
package com.jiewen.spp.modules.device.dao;

import com.jiewen.base.core.dao.CrudDao;
import com.jiewen.spp.modules.device.entity.RecordInfo;

public interface RecordInfoDao extends CrudDao<RecordInfo> {

    public RecordInfo findById(RecordInfo recordInfo);
}
