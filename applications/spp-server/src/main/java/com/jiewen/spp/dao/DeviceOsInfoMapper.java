package com.jiewen.spp.dao;

import java.util.List;

import com.jiewen.base.core.Mapper;
import com.jiewen.spp.dto.DeviceOsInfoDto;

@org.apache.ibatis.annotations.Mapper
public interface DeviceOsInfoMapper extends Mapper<DeviceOsInfoDto> {
    public List<DeviceOsInfoDto> getCheckVersion(DeviceOsInfoDto deviceOsInfoDto);

}
