package com.jiewen.spp.modules.tms.dao;

import java.util.List;

import com.jiewen.base.core.dao.CrudDao;
import com.jiewen.spp.modules.tms.entity.UpdateItems;

public interface UpdateItemsDao extends CrudDao<UpdateItems> {

	UpdateItems findByCondition(UpdateItems updateItems);

	public List<UpdateItems> findNotConfigList(UpdateItems updateItems);

}
