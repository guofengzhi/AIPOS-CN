
package com.jiewen.spp.modules.baseinfo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jiewen.base.common.utils.CacheUtils;
import com.jiewen.base.core.service.CrudService;
import com.jiewen.spp.modules.baseinfo.dao.DeviceTypeDao;
import com.jiewen.spp.modules.baseinfo.entity.DeviceType;

@Service
public class DeviceTypeService extends CrudService<DeviceTypeDao, DeviceType> {

    @Autowired
    private DeviceTypeDao deviceTypeDao;

    private static final String CACHE_DEVICE_TYPE = "cache_device_type";

    @Override
    public List<DeviceType> findList(DeviceType deviceType) {
        return dao.findList(deviceType);
    }

    @Transactional(readOnly = false)
    public void deleteById(DeviceType deviceType) {
        dao.delete(deviceType);
        CacheUtils.remove(CACHE_DEVICE_TYPE);
    }

    @Transactional(readOnly = false)
    public void saveDeviceType(DeviceType deviceType) {
        deviceType.preInsert(true);
        dao.insert(deviceType);
        CacheUtils.remove(CACHE_DEVICE_TYPE);
    }

    @Transactional(readOnly = false)
    public void update(DeviceType deviceType) {
        deviceType.preUpdate();
        dao.update(deviceType);
        CacheUtils.remove(CACHE_DEVICE_TYPE);
    }

    public DeviceType findDeviceTypeByType(DeviceType deviceType) {
        return deviceTypeDao.findDeviceTypeByType(deviceType);
    }

    public List<DeviceType> getDeviceTypeByManuNo(DeviceType deviceType) {
        return deviceTypeDao.getDeviceTypeByManuNo(deviceType);
    }

    public List<DeviceType> getDeviceTypeList() {
        @SuppressWarnings("unchecked")
        List<DeviceType> deviceTypes = (List<DeviceType>) CacheUtils.get(CACHE_DEVICE_TYPE);
        if (deviceTypes == null || deviceTypes.isEmpty()) {
            deviceTypes = deviceTypeDao.getDeviceTypeList();
        }
        CacheUtils.put(CACHE_DEVICE_TYPE, deviceTypes);
        return deviceTypes;
    }

}
