
package com.jiewen.spp.modules.app.dao;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import com.jiewen.base.core.dao.CrudDao;
import com.jiewen.spp.modules.app.entity.AppDeviceType;

/**
 * APPDao
 * 
 * @author Administrator
 *
 */
@Transactional
public interface AppDeviceTypeDao extends CrudDao<AppDeviceType> {

    public AppDeviceType findAppDeviceTypeByApkId(String apkId);

    public AppDeviceType findAppDeviceTypeById(AppDeviceType appDeviceType);

    public List<AppDeviceType> getAppDeviceTypeByApkId(AppDeviceType appDeviceType);

    public void deleteByApkId(AppDeviceType appDeviceType);

}
