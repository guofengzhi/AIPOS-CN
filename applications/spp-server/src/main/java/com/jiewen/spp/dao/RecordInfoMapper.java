package com.jiewen.spp.dao;

import com.jiewen.base.core.Mapper;
import com.jiewen.spp.model.RecordInfo;

public interface RecordInfoMapper extends Mapper<RecordInfo> {

    public void update(RecordInfo recordInfo);
}
