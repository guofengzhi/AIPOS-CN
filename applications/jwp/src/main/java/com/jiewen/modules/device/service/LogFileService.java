package com.jiewen.modules.device.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.jiewen.jwp.base.service.CrudService;
import com.jiewen.modules.device.dao.LogFileDao;
import com.jiewen.modules.device.entity.LogFile;

@Service
public class LogFileService extends CrudService<LogFileDao, LogFile> {

    @Autowired
    private LogFileDao logInfoDao;

    /**
     * 通过id查日志信息
     * 
     * @param device
     */
    @Transactional(readOnly = false)
    public LogFile findById(String id) {
        LogFile logInfo = new LogFile();
        logInfo.setId(id);
        return logInfoDao.findById(logInfo);
    }

    public PageInfo<LogFile> findPage(LogFile logFile) {
        PageHelper.startPage(logFile);
        return new PageInfo<>(logInfoDao.findList(logFile));
    }

}
