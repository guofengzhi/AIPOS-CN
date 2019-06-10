package com.jiewen.modules.sys.dao;

import java.util.List;

import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.modules.sys.entity.Menu;

/**
 * 菜单DAO接口
 */

public interface MenuDao extends CrudDao<Menu> {

    public List<Menu> findByParentIdsLike(Menu menu);

    public List<Menu> findByUserId(Menu menu);
    
    public List<Menu> findMenuCode(String code);

    public int updateParentIds(Menu menu);

    public int updateSort(Menu menu);
    
    public Menu selectMenuId();
    
}
