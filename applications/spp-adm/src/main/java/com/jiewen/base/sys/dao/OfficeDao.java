
package com.jiewen.base.sys.dao;

import java.util.List;

import com.jiewen.base.core.dao.TreeDao;
import com.jiewen.base.sys.entity.Office;

/**
 * 机构DAO接口
 */
public interface OfficeDao extends TreeDao<Office> {

	List<Office> findListByOrg(Office office);

}
