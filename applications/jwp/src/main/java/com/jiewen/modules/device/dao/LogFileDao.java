package com.jiewen.modules.device.dao;

import java.util.List;

import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.modules.device.entity.LogFile;

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
