package com.jiewen.modules.device.dao;

import org.springframework.transaction.annotation.Transactional;

import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.modules.device.entity.Message;

/**
 * 设备Dao
 * 
 * @author Administrator
 *
 */
@Transactional
public interface MessageDao extends CrudDao<Message> {

}
