package com.jiewen.modules.baseinfo.dao;

import org.springframework.transaction.annotation.Transactional;

import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.modules.baseinfo.entity.ClientEntity;

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
