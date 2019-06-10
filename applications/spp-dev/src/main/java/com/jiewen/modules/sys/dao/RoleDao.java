package com.jiewen.modules.sys.dao;

import java.util.List;

import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.modules.sys.entity.Role;
import com.jiewen.modules.sys.entity.SysUserRole;
import com.jiewen.modules.sys.entity.User;

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
    
    public List<Role> findRoleList(Role role);
    
    public List<SysUserRole> findUserRoleList(User user);
    

}
