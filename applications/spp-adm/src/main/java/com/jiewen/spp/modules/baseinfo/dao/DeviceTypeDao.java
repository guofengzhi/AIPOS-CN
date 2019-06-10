
package com.jiewen.spp.modules.baseinfo.dao;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import com.jiewen.base.core.dao.CrudDao;
import com.jiewen.spp.modules.baseinfo.entity.DeviceType;

/**
 * 设备型号Dao
 * 
 * @author Administrator
 *
 */
@Transactional
public interface DeviceTypeDao extends CrudDao<DeviceType> {

    public DeviceType findDeviceTypeByType(DeviceType deviceType);

    public List<DeviceType> getDeviceTypeByManuNo(DeviceType deviceType);

    public List<DeviceType> getDeviceTypeList();

}
