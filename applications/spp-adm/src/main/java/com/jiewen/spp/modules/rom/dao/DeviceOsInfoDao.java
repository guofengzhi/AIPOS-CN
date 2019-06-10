
package com.jiewen.spp.modules.rom.dao;

import java.util.List;

import com.jiewen.base.core.dao.CrudDao;
import com.jiewen.spp.dto.DeviceOsInfoDto;

public interface DeviceOsInfoDao extends CrudDao<DeviceOsInfoDto> {

    public List<DeviceOsInfoDto> getCheckVersion(DeviceOsInfoDto deviceOsInfoDto);

}
