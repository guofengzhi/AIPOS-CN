package com.jiewen.spp.dao;

import java.util.List;

import com.jiewen.base.core.Mapper;
import com.jiewen.spp.dto.DeviceAppInfoDto;

@org.apache.ibatis.annotations.Mapper
public interface DeviceAppInfoMapper extends Mapper<DeviceAppInfoDto> {
    public List<DeviceAppInfoDto> getCheckAppVersion(DeviceAppInfoDto deviceAppInfoDto);

    public List<DeviceAppInfoDto> getNoDefaultSysAppVersion(DeviceAppInfoDto deviceAppInfoDto);

}
