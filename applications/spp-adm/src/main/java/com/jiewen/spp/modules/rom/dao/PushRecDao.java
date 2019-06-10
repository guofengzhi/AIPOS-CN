
package com.jiewen.spp.modules.rom.dao;

import org.springframework.transaction.annotation.Transactional;

import com.jiewen.base.core.dao.CrudDao;
import com.jiewen.spp.modules.rom.entity.PushRec;

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
