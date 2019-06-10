
package com.jiewen.spp.modules.baseinfo.dao;

import org.springframework.transaction.annotation.Transactional;

import com.jiewen.base.core.dao.CrudDao;
import com.jiewen.spp.modules.baseinfo.entity.ManuFacturer;

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
