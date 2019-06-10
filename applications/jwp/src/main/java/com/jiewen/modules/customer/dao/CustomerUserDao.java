package com.jiewen.modules.customer.dao;

import org.springframework.transaction.annotation.Transactional;

import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.modules.sys.entity.User;

/**
 * 用户DAO接口
 */
@Transactional
public interface CustomerUserDao extends CrudDao<User> {

    /**
     * 根据登录名称查询用户
     * 
     * @param loginName
     * @return
     */
    public User getByLoginName(User user);

    /**
     * 更新用户密码
     * 
     * @param user
     * @return
     */
    public int updatePasswordById(User user);

    /**
     * 更新登录信息，如：登录IP、登录时间
     * 
     * @param user
     * @return
     */
    public int updateLoginInfo(User user);
}
