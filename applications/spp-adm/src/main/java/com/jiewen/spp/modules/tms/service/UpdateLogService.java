package com.jiewen.spp.modules.tms.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.jiewen.base.core.service.CrudService;
import com.jiewen.spp.modules.tms.dao.UpdateLogDao;
import com.jiewen.spp.modules.tms.entity.UpdateLog;

/**
 * 更新日志处理
 * @author guofengzhi
 */
@Service
public class UpdateLogService extends CrudService<UpdateLogDao, UpdateLog> {

	@Autowired
	private UpdateLogDao updateLogDao;
	
    @Transactional
    public PageInfo<UpdateLog> findPage(UpdateLog updateLog) {
        PageHelper.startPage(updateLog);
        return new PageInfo<>(updateLogDao.findList(updateLog));
    }
    
}
