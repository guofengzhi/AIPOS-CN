package com.jiewen.modules.sys.dao;

import com.jiewen.jwp.base.dao.TreeDao;
import com.jiewen.modules.sys.entity.Area;

/**
 * 区域DAO接口
 */

public interface AreaDao extends TreeDao<Area> {
	public Area selectAreaId(); 
}
