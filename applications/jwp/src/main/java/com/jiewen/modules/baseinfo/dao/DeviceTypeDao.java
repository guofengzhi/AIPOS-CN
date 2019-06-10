package com.jiewen.modules.baseinfo.dao;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.modules.baseinfo.entity.DeviceType;

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
