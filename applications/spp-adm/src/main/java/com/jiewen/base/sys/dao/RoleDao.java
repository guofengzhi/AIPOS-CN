
package com.jiewen.base.sys.dao;

import java.util.List;

import com.jiewen.base.core.dao.CrudDao;
import com.jiewen.base.sys.entity.Role;

/**
 * 角色DAO接口
 */

public interface RoleDao extends CrudDao<Role> {

    public Role getByName(Role role);

    public Role getByEnname(Role role);

    /**
     * 维护角色与菜单权限关系
     * 
     * @param role
     * @return
     */
    public int deleteRoleMenu(Role role);

    public int insertRoleMenu(Role role);

    /**
     * 维护角色与公司部门关系
     * 
     * @param role
     * @return
     */
    public int deleteRoleOffice(Role role);

    public int insertRoleOffice(Role role);

    public List<Role> findRolIdList(Role role);

}
