package com.jiewen.spp.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jiewen.base.core.AbstractService;
import com.jiewen.base.excetion.OTAExcetion;
import com.jiewen.spp.dao.RecordInfoMapper;
import com.jiewen.spp.model.RecordInfo;
import com.jiewen.spp.service.RecordInfoService;
import com.jiewen.spp.wrapper.RecDirectoryWrapper;
import com.jiewen.utils.RspCode;

@Service
@Transactional
public class RecordInfoServiceImpl extends AbstractService<RecordInfo>
        implements RecordInfoService {

    @Resource
    private RecordInfoMapper recordInfoMapper;

    @Override
    public RecordInfo recDirectoryInfo(RecDirectoryWrapper recDirectoryWrapper) {
        RecordInfo recordInfo = new RecordInfo();
        recordInfo.setId(recDirectoryWrapper.getTransId());
        recordInfo = recordInfoMapper.selectOne(recordInfo);
        if (recordInfo == null) {
            throw new OTAExcetion(RspCode.SYSTEM_ERROR,
                    "未查询到ID为{" + recDirectoryWrapper.getDeviceType() + "}的原流水，请核查!");
        }

        RecordInfo params = new RecordInfo();
        params.setId(recDirectoryWrapper.getTransId());
        params.setPackageInfo(recDirectoryWrapper.getDirectoryList());
        params.setStatus("0");
        recordInfoMapper.update(params);

        return recordInfo;
    }
}
