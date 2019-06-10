
package com.jiewen.base.sys.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.PageInfo;
import com.jiewen.base.core.service.CrudService;
import com.jiewen.base.sys.dao.LogDao;
import com.jiewen.base.sys.entity.Log;
import com.jiewen.jwp.common.utils.DateUtils;

/**
 * 日志Service
 *
 */
@Service
@Transactional(readOnly = true)
public class LogService extends CrudService<LogDao, Log> {

    @Override
    public PageInfo<Log> findPage(Log log) {
        // 设置默认时间范围，默认当前月
        if (log.getBeginDate() == null) {
            log.setBeginDate(DateUtils.setDays(DateUtils.parseDate(DateUtils.getDate()), 1));
        }
        if (log.getEndDate() == null) {
            log.setEndDate(DateUtils.addMonths(log.getBeginDate(), 1));
        }
        if (DateUtils.isSameDay(log.getBeginDate(), log.getEndDate())) {
            log.setEndDate(DateUtils.addDays(log.getEndDate(), 1));
        }
        return super.findPage(log);
    }

}
