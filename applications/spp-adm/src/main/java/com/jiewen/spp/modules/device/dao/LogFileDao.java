
package com.jiewen.spp.modules.device.dao;

import java.util.List;

import com.jiewen.base.core.dao.CrudDao;
import com.jiewen.spp.modules.device.entity.LogFile;

/**
 * 日志信息Dao
 * 
 * @author Pang.M
 *
 */
public interface LogFileDao extends CrudDao<LogFile> {

    public List<LogFile> findList(LogFile logInfo);

    public LogFile findById(LogFile logInfo);
}
