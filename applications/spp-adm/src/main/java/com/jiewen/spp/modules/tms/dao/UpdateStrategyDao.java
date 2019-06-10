package com.jiewen.spp.modules.tms.dao;

import com.jiewen.base.core.dao.CrudDao;
import com.jiewen.spp.modules.tms.entity.UpdateStrategy;

public interface UpdateStrategyDao extends CrudDao<UpdateStrategy> {

	Integer getFileById(String id);

}
