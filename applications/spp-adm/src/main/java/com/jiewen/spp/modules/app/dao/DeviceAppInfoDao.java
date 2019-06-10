
package com.jiewen.spp.modules.app.dao;

import java.util.List;

import com.jiewen.base.core.dao.CrudDao;
import com.jiewen.spp.dto.DeviceAppInfoDto;

public interface DeviceAppInfoDao extends CrudDao<DeviceAppInfoDto> {

    public List<DeviceAppInfoDto> getCheckAppVersion(DeviceAppInfoDto deviceAppInfoDto);

}
