package com.jiewen.modules.sys.utils;

import java.util.List;
import java.util.Locale;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.UnavailableSecurityManagerException;
import org.apache.shiro.session.InvalidSessionException;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.transaction.annotation.Transactional;

import com.jiewen.jwp.base.utils.CacheUtils;
import com.jiewen.jwp.common.SpringUtil;
import com.jiewen.jwp.common.StringUtils;
import com.jiewen.modules.sys.dao.AreaDao;
import com.jiewen.modules.sys.dao.MenuDao;
import com.jiewen.modules.sys.dao.OfficeDao;
import com.jiewen.modules.sys.dao.RoleDao;
import com.jiewen.modules.sys.dao.UserDao;
import com.jiewen.modules.sys.entity.Area;
import com.jiewen.modules.sys.entity.Menu;
import com.jiewen.modules.sys.entity.Office;
import com.jiewen.modules.sys.entity.Role;
import com.jiewen.modules.sys.entity.User;
import com.jiewen.modules.sys.security.SystemAuthorizingRealm.Principal;

/**
 * 用户工具类
 */
@Transactional
public class UserUtils {

    private static UserDao userDao = SpringUtil.getBean(UserDao.class);

    private static RoleDao roleDao = SpringUtil.getBean(RoleDao.class);

    private static MenuDao menuDao = SpringUtil.getBean(MenuDao.class);

    private static AreaDao areaDao = SpringUtil.getBean(AreaDao.class);

    private static OfficeDao officeDao = SpringUtil.getBean(OfficeDao.class);

    public static final String USER_CACHE = "userCache";

    public static final String USER_CACHE_ID_ = "id_";

    public static final String USER_CACHE_LOGIN_NAME_ = "ln";

    public static final String USER_CACHE_LIST_BY_OFFICE_ID_ = "oid_";

    public static final String CACHE_AUTH_INFO = "authInfo";

    public static final String CACHE_ROLE_LIST = "roleList";

    public static final String CACHE_MENU_LIST = "menuList";

    public static final String CACHE_AREA_LIST = "areaList";

    public static final String CACHE_OFFICE_LIST = "officeList";

    public static final String CACHE_OFFICE_ALL_LIST = "officeAllList";
    

    private UserUtils() {
        throw new IllegalStateException("Utility class");
    }

    /**
     * 根据ID获取用户
     *
     * @param id
     * @return 取不到返回null
     */
    public static User get(String id) {
        User user = (User) CacheUtils.get(USER_CACHE, USER_CACHE_ID_ + id);
        if (user == null) {
            user = userDao.get(id);
            if (user == null) {
                return null;
            }
            user.setRoleList(roleDao.findList(new Role(user)));
            CacheUtils.put(USER_CACHE, USER_CACHE_ID_ + user.getId(), user);
            CacheUtils.put(USER_CACHE, USER_CACHE_LOGIN_NAME_ + user.getLoginName(),
                    user);
            
        }
        return user;
    }
    
    
    /**
     * 根据登录名获取用户
     *
     * @param loginName
     * @return 取不到返回null
     */
    public static User getByLoginName(String loginName) {
        User user = (User) CacheUtils.get(USER_CACHE, USER_CACHE_LOGIN_NAME_ + loginName);
        if (user == null) {
            user = userDao.getByLoginName(new User(null, loginName));
            if (user == null) {
                return null;
            }
            user.setRoleList(roleDao.findList(new Role(user)));
            CacheUtils.put(USER_CACHE, USER_CACHE_ID_ + user.getId(), user);
            CacheUtils.put(USER_CACHE, USER_CACHE_LOGIN_NAME_ + user.getLoginName(),
                    user);
        }
        return user;
    }

    /**
     * 清除当前用户缓存
     */
    public static void clearCache() {
        removeCache(CACHE_AUTH_INFO);
        removeCache(CACHE_ROLE_LIST);
        removeCache(CACHE_MENU_LIST);
        removeCache(CACHE_AREA_LIST);
        removeCache(CACHE_OFFICE_LIST);
        removeCache(CACHE_OFFICE_ALL_LIST);
        UserUtils.clearCache(getUser());
    }

    /**
     * 清除指定用户缓存
     *
     * @param user
     */
    public static void clearCache(User user) {
        CacheUtils.remove(USER_CACHE, USER_CACHE_ID_ + user.getId());
        CacheUtils.remove(USER_CACHE, USER_CACHE_LOGIN_NAME_ + user.getLoginName());
        CacheUtils.remove(USER_CACHE, USER_CACHE_LOGIN_NAME_ + user.getOldLoginName());
        if (user.getOffice() != null && user.getOffice().getId() != null) {
            CacheUtils.remove(USER_CACHE,
                    USER_CACHE_LIST_BY_OFFICE_ID_ + user.getOffice().getId());
        }
    }

    
    
    /**
     * 获取当前用户
     *
     * @return 取不到返回 new User()
     */
    public static User getUser() {
        Principal principal = getPrincipal();
        if (principal != null) {
            User user = get(principal.getId());
            if (user != null) {
                return user;
            }
            return new User();
        }
        // 如果没有登录，则返回实例化空的User对象。
        return new User();
    }

    /**
     * 获取当前用户角色列表
     *
     * @return
     */
    public static List<Role> getRoleList() {
        @SuppressWarnings("unchecked")
        List<Role> roleList = (List<Role>) getCache(CACHE_ROLE_LIST);
        if (roleList == null) {
            User user = getUser();
            if (user.isAdmin()) {
                roleList = roleDao.findAllList(new Role());
            } else {
                Role role = new Role();
                roleList = roleDao.findList(role);
            }
            putCache(CACHE_ROLE_LIST, roleList);
        }
        return roleList;
    }

    /**
     * 获取当前用户授权菜单
     *
     * @return
     */
    public static List<Menu> getMenuList(String language) {
        @SuppressWarnings("unchecked")
        List<Menu> menuList = (List<Menu>) getCache(CACHE_MENU_LIST);
        if (menuList == null) {
            User user = getUser();
            if (user.isAdmin()) {
                Menu menu = new Menu();
                menu.setLang(language);
                menuList = menuDao.findAllList(menu);
            } else {
                Menu m = new Menu();
                m.setUserId(user.getId());
                menuList = menuDao.findByUserId(m);
            }
            // 不设置缓存 防止因为角色按钮变化无法得到新的菜单显示
            // putCache(CACHE_MENU_LIST, menuList);
        }
        return menuList;
    }

    /**
	 * 获取当前用户授权菜单
	 * 
	 * @return
	 */
	public static List<Menu> getMenuList() {
		@SuppressWarnings("unchecked")
		List<Menu> menuList = (List<Menu>) getCache(CACHE_MENU_LIST);
		if (menuList == null) {
			User user = getUser();
			if (user.isAdmin()) {
				menuList = menuDao.findAllList(new Menu());
			} else {
				menuList = menuDao.findByUserId(new Menu(user));
			}
			// 不设置缓存 防止因为角色按钮变化无法得到新的菜单显示
			// putCache(CACHE_MENU_LIST, menuList);
		}
		menuList = i18nToMenuLang(menuList);
		return menuList;
	}
	
	public static List<Menu> i18nToMenuLang(List<Menu> menus) {
		String lang = LocaleContextHolder.getLocale().toString();
		for (Menu menu : menus) {
			spiltName(menu);
			if (StringUtils.endsWithIgnoreCase(Locale.US.toString(), lang)
					&& StringUtils.isNotBlank(menu.getEnName())) {
				menu.setName(menu.getEnName());
			} else if (StringUtils.endsWithIgnoreCase(Locale.TRADITIONAL_CHINESE.toString(), lang)
					&& StringUtils.isNotBlank(menu.getTcName())) {
				menu.setName(menu.getTcName());
			}
		}
		return menus;
	}
	
	public static void spiltName(Menu menu) {
		if (menu.getName().contains("|")) {
			String[] muneName = StringUtils.splitByWholeSeparatorPreserveAllTokens(menu.getName(), "|");
			menu.setName(muneName[0]);
			menu.setShowName(muneName[0]);
			menu.setEnName(StringUtils.defaultString(muneName[1], StringUtils.EMPTY));
			menu.setTcName(StringUtils.defaultString(muneName[2], StringUtils.EMPTY));
		}
		if (!StringUtils.isBlank(menu.getParentName()) && menu.getParentName().contains("|")) {
			String[] muneParentName = StringUtils.splitByWholeSeparatorPreserveAllTokens(menu.getParentName(), "|");
			menu.setParentName(muneParentName[0]);
			menu.setEnParentName(StringUtils.defaultString(muneParentName[1], StringUtils.EMPTY));
			menu.setTwParentName(StringUtils.defaultString(muneParentName[2], StringUtils.EMPTY));
		}
		String lang = LocaleContextHolder.getLocale().toString();
		if (StringUtils.endsWithIgnoreCase(Locale.US.toString(), lang) && StringUtils.isNotBlank(menu.getEnName())) {
			menu.setShowName(menu.getEnName());
			if (StringUtils.isNotBlank(menu.getEnParentName())) {
				menu.setParentName(menu.getEnParentName());
			}

		} else if (StringUtils.endsWithIgnoreCase(Locale.TRADITIONAL_CHINESE.toString(), lang)
				&& StringUtils.isNotBlank(menu.getTcName())) {
			menu.setShowName(menu.getTcName());
			if (StringUtils.isNotBlank(menu.getTwParentName())) {
				menu.setParentName(menu.getTwParentName());
			}
		}

	}
	
    /**
     * 获取当前用户授权的区域
     *
     * @return
     */
    public static List<Area> getAreaList() {
        @SuppressWarnings("unchecked")
        List<Area> areaList = (List<Area>) getCache(CACHE_AREA_LIST);
        if (areaList == null) {
            areaList = areaDao.findAllList(new Area());
            putCache(CACHE_AREA_LIST, areaList);
        }
        return areaList;
    }

    /**
     * 获取当前用户有权限访问的部门
     *
     * @return
     */
    public static List<Office> getOfficeList() {
        @SuppressWarnings("unchecked")
        List<Office> officeList = (List<Office>) getCache(CACHE_OFFICE_LIST);
        if (officeList == null) {
            User user = getUser();
            if (user.isAdmin()) {
                officeList = officeDao.findAllList(new Office());
            } else {
                Office office = new Office();
                officeList = officeDao.findList(office);
            }
            putCache(CACHE_OFFICE_LIST, officeList);
        }
        return officeList;
    }

    /**
     * 获取当前用户有权限访问的部门
     *
     * @return
     */
    public static List<Office> getOfficeAllList() {
        @SuppressWarnings("unchecked")
        List<Office> officeList = (List<Office>) getCache(CACHE_OFFICE_ALL_LIST);
        if (officeList == null) {
            officeList = officeDao.findAllList(new Office());
        }
        return officeList;
    }

    /**
     * 获取授权主要对象
     */
    public static Subject getSubject() {
        return SecurityUtils.getSubject();
    }

    /**
     * 获取当前登录者对象
     */
    public static Principal getPrincipal() {
        try {
            Subject subject = SecurityUtils.getSubject();
            Principal principal = (Principal) subject.getPrincipal();
            if (principal != null) {
                return principal;
            }
            // subject.logout();
        } catch (UnavailableSecurityManagerException | InvalidSessionException e) {

        }
        return null;
    }

    public static Session getSession() {
        try {
            Subject subject = SecurityUtils.getSubject();
            Session session = subject.getSession(false);
            if (session == null) {
                session = subject.getSession();
            }
            if (session != null) {
                return session;
            }
            // subject.logout();
        } catch (InvalidSessionException e) {

        }
        return null;
    }

    // ============== User Cache ==============

    public static Object getCache(String key) {
        return getCache(key, null);
    }

    public static Object getCache(String key, Object defaultValue) {
        Object obj = getSession().getAttribute(key);
        return obj == null ? defaultValue : obj;
    }

    public static void putCache(String key, Object value) {
        getSession().setAttribute(key, value);
    }

    public static void removeCache(String key) {
        getSession().removeAttribute(key);
    }

    public static Office get(Office office){
		return officeDao.get(office);
	}
    
    public static List<Office> getUserOfficeList() {
		@SuppressWarnings("unchecked")
		List<Office> officeList = (List<Office>) getCache(CACHE_OFFICE_LIST);
		if (officeList == null) {
			User user = getUser();
			if (user.isAdmin()) {
				officeList = officeDao.findAllList(new Office());
			} else {
				Office office = new Office();
				officeList = officeDao.findListByOrg(office);
			}
			putCache(CACHE_OFFICE_LIST, officeList);
		}
		return officeList;
	}
    
}
