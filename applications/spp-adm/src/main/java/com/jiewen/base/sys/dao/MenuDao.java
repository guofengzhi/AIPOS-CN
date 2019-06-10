
package com.jiewen.base.sys.dao;

import java.util.List;

import com.jiewen.base.core.dao.CrudDao;
import com.jiewen.base.sys.entity.Menu;

/**
 * 菜单DAO接口
 */

public interface MenuDao extends CrudDao<Menu> {

    public List<Menu> findByParentIdsLike(Menu menu);

    public List<Menu> findByUserId(Menu menu);

    public int updateParentIds(Menu menu);

    public int updateSort(Menu menu);

}
