package com.jiewen.modules.baseinfo.dao;

import org.springframework.transaction.annotation.Transactional;

import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.modules.baseinfo.entity.ManuFacturer;

/**
 * 厂商Dao
 * 
 * @author Administrator
 *
 */
@Transactional
public interface ManuFacturerDao extends CrudDao<ManuFacturer> {

    public ManuFacturer findManuFacturerByNo(String manuFacturerNo);

    public ManuFacturer findManuFacturerByName(String manufacturerName);

}
