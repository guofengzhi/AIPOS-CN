
package com.jiewen.spp.modules.baseinfo.dao;

import org.springframework.transaction.annotation.Transactional;

import com.jiewen.base.core.dao.CrudDao;
import com.jiewen.spp.modules.baseinfo.entity.ClientEntity;

/**
 * 客戶Dao
 * 
 * @author Administrator
 *
 */
@Transactional
public interface ClientEntityDao extends CrudDao<ClientEntity> {

    public ClientEntity findClientByName(String clientName);
    
    public ClientEntity findClientBySn(String sn);

}
