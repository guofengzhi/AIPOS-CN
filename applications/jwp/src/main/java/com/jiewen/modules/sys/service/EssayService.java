package com.jiewen.modules.sys.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jiewen.jwp.base.service.CrudService;
import com.jiewen.modules.sys.dao.EssayDao;
import com.jiewen.modules.sys.entity.Essay;

/**
 * 文章Service
 */
@Service
@Transactional(readOnly = true)
public class EssayService extends CrudService<EssayDao, Essay> {


    @Override
    public Essay get(Essay essay) {
        return dao.get(essay);
    }

    @Override
    @Transactional(readOnly = false)
    public void save(Essay essay) {
    	essay.setDelFlag("0");
        super.save(essay);
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(Essay essay) {
        super.delete(essay);
    }

}
