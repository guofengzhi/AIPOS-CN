
package com.jiewen.spp.modules.app.dao;

import org.springframework.transaction.annotation.Transactional;

import com.jiewen.base.core.dao.CrudDao;
import com.jiewen.spp.modules.app.entity.AppDevice;

/**
 * AppDeviceDao
 * 
 * @author Administrator
 *
 */
@Transactional
public interface AppDeviceDao extends CrudDao<AppDevice> {

    public void deleteAppDeviceByApkId(String apkId);

    public void deleteAppDeviceByDeviceSn(String deviceSn);

}
