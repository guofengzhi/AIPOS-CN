package com.jiewen.modules.rom.dao;

import java.util.List;

import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.spp.dto.DeviceOsInfoDto;

public interface DeviceOsInfoDao extends CrudDao<DeviceOsInfoDto> {

    public List<DeviceOsInfoDto> getCheckVersion(DeviceOsInfoDto deviceOsInfoDto);

}
