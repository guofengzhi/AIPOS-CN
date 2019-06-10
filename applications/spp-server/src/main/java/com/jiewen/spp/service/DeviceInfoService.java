package com.jiewen.spp.service;

import com.jiewen.base.core.Service;
import com.jiewen.spp.dto.DeviceOsInfoDto;
import com.jiewen.spp.model.DeviceInfo;
import com.jiewen.spp.wrapper.OsParamsWrapper;
import com.jiewen.spp.wrapper.RecDeviceInfoWrapper;

/**
 * Created by CodeGenerator on 2017/08/18.
 */
public interface DeviceInfoService extends Service<DeviceInfo> {
    public DeviceOsInfoDto getCheckVersion(OsParamsWrapper osParamsWrapper);

    public void recDeviceInfo(RecDeviceInfoWrapper recDeviceInfoWrapper);
    
    public DeviceInfo getBySn(String termSn);

}
