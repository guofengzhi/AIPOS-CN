package com.jiewen.modules.app.dao;

import org.springframework.transaction.annotation.Transactional;

import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.modules.app.entity.AppDevice;

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
