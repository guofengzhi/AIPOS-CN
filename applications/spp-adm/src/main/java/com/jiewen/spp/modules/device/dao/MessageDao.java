
package com.jiewen.spp.modules.device.dao;

import org.springframework.transaction.annotation.Transactional;

import com.jiewen.base.core.dao.CrudDao;
import com.jiewen.spp.modules.device.entity.Message;

/**
 * 设备Dao
 * 
 * @author Administrator
 *
 */
@Transactional
public interface MessageDao extends CrudDao<Message> {

}
