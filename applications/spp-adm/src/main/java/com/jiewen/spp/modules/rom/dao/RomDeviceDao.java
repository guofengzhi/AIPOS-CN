
package com.jiewen.spp.modules.rom.dao;

import org.springframework.transaction.annotation.Transactional;

import com.jiewen.base.core.dao.CrudDao;
import com.jiewen.spp.modules.rom.entity.RomDevice;

/**
 * 设备Dao
 * 
 * @author Administrator
 *
 */
@Transactional
public interface RomDeviceDao extends CrudDao<RomDevice> {

    public void deleteRomDeviceByOsId(String osId);

    public void deleteRomDeviceByDeviceId(String deviceId);
}
