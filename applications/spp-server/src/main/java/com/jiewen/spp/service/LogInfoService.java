package com.jiewen.spp.service;

import org.springframework.web.multipart.MultipartFile;

import com.jiewen.base.core.Service;
import com.jiewen.spp.model.LogInfo;
import com.jiewen.spp.wrapper.RecLogInfoWrapper;

/**
 * Created by CodeGenerator on 2017/10/24.
 */
public interface LogInfoService extends Service<LogInfo> {

    public void recLogInfo(RecLogInfoWrapper recLogInfoWrapper, MultipartFile file);
}
