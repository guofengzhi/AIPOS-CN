
package com.jiewen.spp.modules.customer.service;

import java.util.Date;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.jiewen.base.common.utils.CacheUtils;
import com.jiewen.base.common.web.ServletsUtils;
import com.jiewen.base.config.Global;
import com.jiewen.base.core.exception.ServiceException;
import com.jiewen.base.core.service.BaseService;
import com.jiewen.base.sys.dao.RoleDao;
import com.jiewen.base.sys.dao.UserDao;
import com.jiewen.base.sys.entity.Role;
import com.jiewen.base.sys.entity.User;
import com.jiewen.base.sys.utils.UserUtils;
import com.jiewen.jwp.common.security.Digests;
import com.jiewen.jwp.common.utils.Encodes;
import com.jiewen.jwp.common.utils.StringUtils;
import com.jiewen.spp.modules.customer.dao.CustomerUserDao;
import com.jiewen.spp.utils.LocaleMessageSourceUtil;

/**
 * 客户用户service
 */
@Service
@Transactional
public class CustomerUserService extends BaseService {

    public static final int HASH_INTERATIONS = 1024;

    public static final int SALT_SIZE = 8;

    @Resource
    protected LocaleMessageSourceUtil messageSourceUtil;

    @Autowired
    private RoleDao roleDao;

    @Autowired
    private UserDao userDao;

    @Autowired
    private CustomerUserDao customerUserDao;

    public static final String USER_CACHE = "userCache";

    public static final String USER_CACHE_ID_ = "id_";

    public static final String USER_CACHE_LOGIN_NAME_ = "ln";

    /**
     * 获取分页查询
     * 
     * @param user
     * @return
     */
    @Transactional
    public PageInfo<User> findPage(User user) {
        PageHelper.startPage(user);
        return new PageInfo<>(customerUserDao.findList(user));
    }

    /**
     * 保存用户
     * 
     * @param user
     */
    @Transactional(readOnly = false)
    public void saveUser(User user) {
        if (StringUtils.isBlank(user.getId())) {
            user.setPassword(entryptPassword(Global.getConfig("create.user.initpd"))); // 新增用户初始化密码
            user.preInsert();
            customerUserDao.insert(user);
        } else {
            // 清除原用户机构用户缓存
            User oldUser = customerUserDao.get(user.getId());
            if (oldUser.getOffice() != null && oldUser.getOffice().getId() != null) {
                CacheUtils.remove(UserUtils.USER_CACHE,
                        UserUtils.USER_CACHE_LIST_BY_OFFICE_ID_ + oldUser.getOffice().getId());
            }
            // 更新用户数据
            user.preUpdate();
            customerUserDao.update(user);
        }
        if (StringUtils.isNotBlank(user.getId())) {
            // 更新用户与角色关联
            userDao.deleteUserRole(user);
            if (user.getRoleList() != null && !user.getRoleList().isEmpty()) {
                userDao.insertUserRole(user);
            } else {
                String message = messageSourceUtil.getMessage("sys.role.noset.roles");
                throw new ServiceException(user.getLoginName() + message);
            }
            // 清除用户缓存
            UserUtils.clearCache(user);
        }
    }

    /**
     * 生成安全的密码，生成随机的16位salt并经过1024次 sha-256 hash
     */
    public static String entryptPassword(String plainPassword) {
        String plain = Encodes.unescapeHtml(plainPassword);
        byte[] salt = Digests.generateSalt(SALT_SIZE);
        byte[] hashPassword = Digests.sha256(plain.getBytes(), salt, HASH_INTERATIONS);
        return Encodes.encodeHex(salt) + Encodes.encodeHex(hashPassword);
    }

    public User getUser(String id) {
        User user = customerUserDao.get(id);
        if (user == null) {
            return null;
        }
        user.setRoleList(roleDao.findList(new Role(user)));

        return user;
    }

    @Transactional(readOnly = false)
    public void deleteUser(String id) {
        User user = new User(id);
        customerUserDao.delete(user);
        // 清除用户缓存
        UserUtils.clearCache(user);
    }

    /**
     * 根据登录名获取用户
     * 
     * @param loginName
     * @return 取不到返回null
     */
    public User getByLoginName(String loginName) {
        User user = (User) CacheUtils.get(USER_CACHE, USER_CACHE_LOGIN_NAME_ + loginName);
        if (user == null) {
            user = customerUserDao.getByLoginName(new User(null, loginName));
            if (user == null) {
                return null;
            }
            user.setRoleList(roleDao.findList(new Role(user)));
            CacheUtils.put(USER_CACHE, USER_CACHE_ID_ + user.getId(), user);
            CacheUtils.put(USER_CACHE, USER_CACHE_LOGIN_NAME_ + user.getLoginName(), user);
        }
        return user;
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

    @Transactional(readOnly = false)
    public void updatePasswordById(String id, String loginName, String newPassword) {
        User user = new User(id);
        user.setPassword(entryptPassword(newPassword));
        customerUserDao.updatePasswordById(user);
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
        user.setLoginIp(StringUtils.getRemoteAddr(ServletsUtils.getRequest()));
        user.setLoginDate(new Date());
        customerUserDao.updateLoginInfo(user);
    }
}
