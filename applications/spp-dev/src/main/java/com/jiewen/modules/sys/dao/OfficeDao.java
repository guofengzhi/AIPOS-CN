package com.jiewen.modules.sys.dao;

import java.util.List;
import com.jiewen.jwp.base.dao.TreeDao;
import com.jiewen.modules.sys.entity.Area;
import com.jiewen.modules.sys.entity.Office;

/**
 * 机构DAO接口
 */
public interface OfficeDao extends TreeDao<Office> {
	
	public List<Office> selectOfficeByAreaId(Area area);
	
	public Office selectOfficeId();
	
	public int selectOfficeUserCount(Office office);
}
