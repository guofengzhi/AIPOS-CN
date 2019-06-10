package com.jiewen.modules.rom.dao;

import org.springframework.transaction.annotation.Transactional;

import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.modules.rom.entity.PushRec;

/**
 * 设备Dao
 * 
 * @author Administrator
 *
 */
@Transactional
public interface PushRecDao extends CrudDao<PushRec> {

    public void deletePushRecByOsId(String osId);

    public void deletePushRecByDeviceId(String deviceId);

}
