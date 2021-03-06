
package com.jiewen.modules.sys.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.jiewen.commons.ServiceException;
import com.jiewen.commons.util.StringUtil;
import com.jiewen.jwp.base.entity.TreeNode;
import com.jiewen.jwp.base.service.BaseService;
import com.jiewen.jwp.base.utils.CacheUtils;
import com.jiewen.jwp.base.utils.SessionDAO;
import com.jiewen.jwp.base.web.ServletsUtils;
import com.jiewen.jwp.common.Encodes;
import com.jiewen.jwp.common.security.Digests;
import com.jiewen.modules.sys.dao.MenuDao;
import com.jiewen.modules.sys.dao.RoleDao;
import com.jiewen.modules.sys.dao.UserDao;
import com.jiewen.modules.sys.entity.Menu;
import com.jiewen.modules.sys.entity.Office;
import com.jiewen.modules.sys.entity.Role;
import com.jiewen.modules.sys.entity.SysUserRole;
import com.jiewen.modules.sys.entity.User;
import com.jiewen.modules.sys.utils.LogUtils;
import com.jiewen.modules.sys.utils.UserUtils;

/**
 * 系统管理，安全相关实体的管理类,包括用户、角色、菜单.
 */
@Service
@Transactional
public class SystemService extends BaseService implements InitializingBean {

    public static final String HASH_ALGORITHM = "SHA-256";

    public static final int HASH_INTERATIONS = 1024;

    public static final int SALT_SIZE = 8;

    @Value("${user.initpass}")
    public String initPass;

    @Autowired
    private UserDao userDao;

    @Autowired
    private RoleDao roleDao;

    @Autowired
    private MenuDao menuDao;

    @Autowired
    private SessionDAO sessionDao;

    public Menu selectMenuId() {
       
    	return menuDao.selectMenuId();
    
    }
    
    /**
     * 获取用户
     *
     * @param id
     * @return
     */
    public User getUser(String id) {
        return UserUtils.get(id);
    }
    
    /**
     * 根据code获取其菜单信息
     *
     * @param Menu
     * @return
     */
    public  List<Menu> findMenuCode(String code) {
        return menuDao.findMenuCode(code);
    }

    /**
     * 根据登录名获取用户
     *
     * @param loginName
     * @return
     */
    public User getUserByLoginName(String loginName) {
        return UserUtils.getByLoginName(loginName);
    }

    /**
     * 无分页查询人员列表
     *
     * @param user
     * @return
     */
    public List<User> findUser(User user) {
        // 生成数据权限过滤条件（dsf为dataScopeFilter的简写，在xml中使用 ${sqlMap.dsf}调用权限SQL）
        user.getSqlMap().put("dsf", dataScopeFilter(user.getCurrentUser(), "o", "a"));
        return userDao.findList(user);
    }

    /**
     * 获取分页查询
     *
     * @param user
     * @return
     */
    @Transactional
    public PageInfo<User> findPage(User user) {
        // 生成数据权限过滤条件（dsf为dataScopeFilter的简写，在xml中使用 ${sqlMap.dsf}调用权限SQL）
        user.getSqlMap().put("dsf", dataScopeFilter(user.getCurrentUser(), "o", "a"));
        PageHelper.startPage(user);
        return new PageInfo<>(userDao.findList(user));
    }
    
    
    /**
     * 获取分页查询
     *
     * @param user
     * @return
     */
    @Transactional
    public PageInfo<Role> findRoleList(Role role) {
    	role.getSqlMap().put("dsf", dataScopeFilter(role.getCurrentUser(), "o", "a"));
        PageHelper.startPage(role);
        return new PageInfo<>(roleDao.findRoleList(role));
    }
    
    /**
     * 获取分页查询
     *
     * @param user
     * @return
     */
    @Transactional
    public List<SysUserRole> findUserRoleList(User user) {
        return roleDao.findUserRoleList(user);
    }
    
    /**
     * 获取分页查询
     *
     * @param user
     * @return
     */
    @Transactional
    public PageInfo<User> findRoleUserList(User user) {
    	user.getSqlMap().put("dsf", dataScopeFilter(user.getCurrentUser(), "o", "a"));
        PageHelper.startPage(user);
        return new PageInfo<>(userDao.findRoleUserList(user));
    }
    
    /**
     * 通过部门ID获取用户列表，仅返回用户id和name（树查询用户时用）
     *
     * @param officeId
     * @return
     */
    @SuppressWarnings("unchecked")
    public List<User> findUserByOfficeId(String officeId) {
        List<User> list = (List<User>) CacheUtils.get(UserUtils.USER_CACHE,
                UserUtils.USER_CACHE_LIST_BY_OFFICE_ID_ + officeId);
        if (list == null) {
            User user = new User();
            user.setOffice(new Office(officeId));
            list = userDao.findUserByOfficeId(user);
            CacheUtils.put(UserUtils.USER_CACHE,
                    UserUtils.USER_CACHE_LIST_BY_OFFICE_ID_ + officeId, list);
        }
        return list;
    }

    @Transactional(readOnly = false)
    public void saveUser(User user) {
        if (StringUtils.isBlank(user.getId())) {
            user.setPassword(encryptPassword(initPass)); // 新增用户初始化密码
            user.setId(userDao.selectUserId().getId());
            user.preInsert(false);
            userDao.insert(user);
        } else {
            // 清除原用户机构用户缓存
            User oldUser = userDao.get(user.getId());
            if (oldUser.getOffice() != null && oldUser.getOffice().getId() != null) {
                CacheUtils.remove(UserUtils.USER_CACHE,
                        UserUtils.USER_CACHE_LIST_BY_OFFICE_ID_
                                + oldUser.getOffice().getId());
            }
            // 更新用户数据
            user.preUpdate();
            userDao.update(user);
        }
        if (StringUtils.isNotBlank(user.getId())) {
            // 更新用户与角色关联
            userDao.deleteUserRole(user);
            if (user.getRoleList() != null && !user.getRoleList().isEmpty()) {
                userDao.insertUserRole(user);
            } else {
                throw new ServiceException(user.getLoginName() + "没有设置角色！");
            }
            // 清除用户缓存
            UserUtils.clearCache(user);
        }
    }
    
    /**
     * 删除sys_user_role表中数据
     * @param user
     * @return
     */
    @Transactional(readOnly = false)
    public void deleteUserRoleA(User user) {
         userDao.deleteUserRoleA(user);
    }
    
    /**
     * 批量添加sys_user_role表中数据
     * @param user
     * @return
     */
    @Transactional(readOnly = false)
    public void insertUserRoleA(User user) {
         userDao.insertUserRoleA(user);
    }
    
    @Transactional(readOnly = false)
    public void updateUserInfo(User user) {
        user.preUpdate();
        userDao.updateUserInfo(user);
        // 清除用户缓存
        UserUtils.clearCache(user);
    }

    @Transactional(readOnly = false)
    public void deleteUser(String id) {
        User user = getUser(id);
        userDao.delete(user);
        // 清除用户缓存
        UserUtils.clearCache(user);
    }

    @Transactional(readOnly = false)
    public void updatePasswordById(String id, String loginName, String newPassword) {
        User user = new User(id);
        user.setPassword(encryptPassword(newPassword));
        userDao.updatePasswordById(user);
        // 清除用户缓存
        user.setLoginName(loginName);
        UserUtils.clearCache(user);
    }

    @Transactional(readOnly = false)
    public void updateUserLoginInfo(User user) {
        // 保存上次登录信息
        user.setOldLoginIp(user.getLoginIp());
        user.setOldLoginDate(user.getLoginDate());
        // 更新本次登录信息
        user.setLoginIp(com.jiewen.jwp.common.StringUtils
                .getRemoteAddr(ServletsUtils.getRequest()));
        user.setLoginDate(new Date());
        userDao.updateLoginInfo(user);
    }

    /**
     * 生成安全的密码，生成随机的16位salt并经过1024次 sha-256 hash
     */
    public static String encryptPassword(String plainPassword) {
        String plain = Encodes.unescapeHtml(plainPassword);
        byte[] salt = Digests.generateSalt(SALT_SIZE);
        byte[] hashPassword = Digests.sha256(plain.getBytes(), salt, HASH_INTERATIONS);
        return Encodes.encodeHex(salt) + Encodes.encodeHex(hashPassword);
    }

    /**
     * 验证密码
     *
     * @param plainPassword
     *            明文密码
     * @param password
     *            密文密码
     * @return 验证成功返回true
     */
    public static boolean validatePassword(String plainPassword, String password) {
        String plain = Encodes.unescapeHtml(plainPassword);
        byte[] salt = Encodes.decodeHex(password.substring(0, 16));
        byte[] hashPassword = Digests.sha256(plain.getBytes(), salt, HASH_INTERATIONS);
        return password.equals(Encodes.encodeHex(salt) + Encodes.encodeHex(hashPassword));
    }

    /**
     * 获得活动会话
     *
     * @return
     */
    public SessionDAO getSessionDao() {
        return sessionDao;
    }

    // -- Role Service --//

    public Role getRole(String id) {
        return roleDao.get(id);
    }

    public Role getRoleByName(String name) {
        Role r = new Role();
        r.setName(name);
        return roleDao.getByName(r);
    }

    public Role getRoleByEnname(String enname) {
        Role r = new Role();
        r.setEnname(enname);
        return roleDao.getByEnname(r);
    }

    public List<Role> findRole(Role role) {
        return roleDao.findList(role);
    }

    public PageInfo<Role> findPage(Role role) {
        PageHelper.startPage(role);
        return new PageInfo<Role>(roleDao.findList(role));
    }

    public List<Role> findAllRole() {
        return UserUtils.getRoleList();
    }

    @Transactional(readOnly = false)
    public void saveRole(Role role) {
        if (role.getOffice() == null) {
            role.setOffice(new Office(role.getOfficeId()));
        }
        if (role.getIsNewRecord()) {
            role.preInsert();
            roleDao.insert(role);
        } else {
            role.preUpdate();
            roleDao.update(role);
        }
        // 更新角色与部门关联
        /*
         * roleDao.deleteRoleOffice(role); if (role.getOfficeList().size() > 0){
         * roleDao.insertRoleOffice(role); }
         */
        // 清除用户角色缓存
        UserUtils.removeCache(UserUtils.CACHE_ROLE_LIST);
    }

    @Transactional(readOnly = false)
    public void deleteRole(Role role) {
        roleDao.delete(role);
        // 清除用户角色缓存
        UserUtils.removeCache(UserUtils.CACHE_ROLE_LIST);
    }

    @Transactional(readOnly = false)
    public void assignMenuToRole(Role role) {
        roleDao.deleteRoleMenu(role);
        if (!role.getMenuList().isEmpty()) {
            roleDao.insertRoleMenu(role);
        }
    }

    // -- Menu Service --//

    public Menu getMenu(String id) {
        return menuDao.get(id);
    }

    public List<Menu> findAllMenu(String language) {
        return UserUtils.getMenuList(language);
    }

    /**
     * 获取菜单数据结构
     *
     * @return
     */
    public List<TreeNode> getTreeData(String language) {
        // 获取数据
        List<Menu> funcs = findAllMenu(language);
        Map<String, TreeNode> nodelist = new LinkedHashMap<String, TreeNode>();
        List<TreeNode> tnlist = new ArrayList<TreeNode>();
        for (Menu func : funcs) {
            TreeNode node = new TreeNode();
            node.setText(func.getName());
            node.setId(func.getId());
            node.setParentId(func.getParentId());
            node.setLevelCode(func.getLevelCode());
            node.setIcon(func.getIcon());
            nodelist.put(node.getId(), node);
        }
        // 构造树形结构
        for (String id : nodelist.keySet()) {
            TreeNode node = nodelist.get(id);
            if (StringUtils.equals("0", node.getParentId())) {
                tnlist.add(node);
            } else {
                if (nodelist.get(node.getParentId()).getNodes() == null) {
                    nodelist.get(node.getParentId()).setNodes(new ArrayList<TreeNode>());
                }
                nodelist.get(node.getParentId()).getNodes().add(node);
            }
        }
        return tnlist;
    }

    @Transactional(readOnly = false)
    public void saveMenu(Menu menu) {
        // 获取父节点实体
    	if (menu.getParentId()!=null&&!StringUtil.isEmpty(menu.getParentId())) {
    		menu.setParent(this.getMenu(menu.getParentId()));
    	}
        if (menu.getParent() == null || menu.getParent().getId() == null) {
            menu.setParent(new Menu(Menu.getRootId()));
        }

        // 获取修改前的parentIds，用于更新子节点的parentIds
        String oldParentIds = StringUtils.isEmpty(menu.getParentIds()) ? StringUtils.SPACE
                : menu.getParentIds();

        // 设置新的父节点串
        if (menu.getParent().getParentIds() != null) {
        	menu.setParentIds(
                    menu.getParent().getParentIds() + menu.getParent().getId() + ",");	
        }else {
        	menu.setParentIds(menu.getParent().getId() + ",");
        }
        
        // 保存或更新实体
        if (menu.getIsNewRecord()) {
            menu.preInsert();
            menuDao.insert(menu);
        } else {
            menu.preUpdate();
            menuDao.update(menu);
        }

        // 更新子节点 parentIds
        Menu m = new Menu();
        m.setParentIds("%," + menu.getId() + ",%");
        List<Menu> list = menuDao.findByParentIdsLike(m);
        for (Menu e : list) {
            e.setParentIds(e.getParentIds().replace(oldParentIds, menu.getParentIds()));
            menuDao.updateParentIds(e);
        }
        // 清除用户菜单缓存
        UserUtils.removeCache(UserUtils.CACHE_MENU_LIST);
        // 清除日志相关缓存
        CacheUtils.remove(LogUtils.CACHE_MENU_NAME_PATH_MAP);
    }

    @Transactional(readOnly = false)
    public void updateMenuSort(Menu menu) {
        menuDao.updateSort(menu);
        // 清除用户菜单缓存
        UserUtils.removeCache(UserUtils.CACHE_MENU_LIST);
        // 清除日志相关缓存
        CacheUtils.remove(LogUtils.CACHE_MENU_NAME_PATH_MAP);
    }

    @Transactional(readOnly = false)
    public void deleteMenu(Menu menu) {
        menuDao.delete(menu);
        // 清除用户菜单缓存
        UserUtils.removeCache(UserUtils.CACHE_MENU_LIST);
        // 清除日志相关缓存
        CacheUtils.remove(LogUtils.CACHE_MENU_NAME_PATH_MAP);
    }

    @Override
    public void afterPropertiesSet() throws Exception {
        // TODO Auto-generated method stub

    }
}
