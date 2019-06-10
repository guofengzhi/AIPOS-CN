package com.jiewen.modules.rom.dao;

import org.springframework.transaction.annotation.Transactional;

import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.modules.rom.entity.RomDevice;

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
