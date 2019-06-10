package com.jiewen.spp.service;

import com.jiewen.base.core.Service;
import com.jiewen.spp.model.RecordInfo;
import com.jiewen.spp.wrapper.RecDirectoryWrapper;

/**
 * Created by CodeGenerator on 2017/11/14.
 * 
 * @author Pang.M
 * 
 */
public interface RecordInfoService extends Service<RecordInfo> {

    public RecordInfo recDirectoryInfo(RecDirectoryWrapper recDirectoryWrapper);
}
