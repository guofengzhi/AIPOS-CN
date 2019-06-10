
package com.jiewen.spp.modules.rom.dao;

import java.util.List;

import com.jiewen.base.core.dao.CrudDao;
import com.jiewen.spp.modules.rom.entity.OsRomInfo;

/**
 * 系统版本Dao
 * 
 * @author Administrator
 *
 */
public interface OsRomInfoDao extends CrudDao<OsRomInfo> {

    public OsRomInfo getOsRomByVersionType(OsRomInfo osRomInfo);

    public List<OsRomInfo> getOsRomByDeviceId(OsRomInfo osRomInfo);

    //查找数量
    public Integer getDeviceCount();
}
