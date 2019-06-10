
package com.jiewen.spp.modules.app.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jiewen.base.core.service.CrudService;
import com.jiewen.spp.modules.app.dao.AppDeviceTypeDao;
import com.jiewen.spp.modules.app.entity.AppDeviceType;

@Service
@Transactional(readOnly = true)
public class AppDeviceTypeService extends CrudService<AppDeviceTypeDao, AppDeviceType> {

    @Autowired
    private AppDeviceTypeDao appDeviceTypeDao;

    public AppDeviceType getAppDeviceTypeById(String appDeviceTypeId) {
        AppDeviceType appDeviceType = new AppDeviceType();
        appDeviceType.setId(appDeviceTypeId);
        return appDeviceTypeDao.get(appDeviceType);
    }

    public List<AppDeviceType> getAppDeviceTypeByApkId(String apkId) {
        AppDeviceType appDeviceType = new AppDeviceType();
        appDeviceType.setApkId(Long.parseLong(apkId));
        return appDeviceTypeDao.getAppDeviceTypeByApkId(appDeviceType);
    }

}
