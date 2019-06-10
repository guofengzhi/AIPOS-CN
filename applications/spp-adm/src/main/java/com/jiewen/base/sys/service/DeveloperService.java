package com.jiewen.base.sys.service;

import javax.annotation.Resource;

import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.jiewen.base.common.utils.CacheUtils;
import com.jiewen.base.config.Global;
import com.jiewen.base.core.exception.ServiceException;
import com.jiewen.base.core.service.BaseService;
import com.jiewen.base.sys.dao.UserDao;
import com.jiewen.base.sys.entity.User;
import com.jiewen.base.sys.utils.UserUtils;
import com.jiewen.jwp.common.utils.StringUtils;
import com.jiewen.spp.utils.LocaleMessageSourceUtil;

@Service
@Transactional
public class DeveloperService extends BaseService implements InitializingBean {

	@Autowired
	private UserDao userDao;
	
	@Resource
	protected LocaleMessageSourceUtil messageSourceUtil;
	
	@Override
	public void afterPropertiesSet() throws Exception {
	}

	/**
	 * 获取分页查询
	 * 
	 * @param user
	 * @return
	 */
	@Transactional
	public PageInfo<User> findPage(User user) {
		user.setIsDeveloper("1");//开发者
		// 生成数据权限过滤条件（dsf为dataScopeFilter的简写，在xml中使用 ${sqlMap.dsf}调用权限SQL）
		user.getSqlMap().put("dsf", dataScopeFilter(user.getCurrentUser(), "o", "a"));
		PageHelper.startPage(user);
		return new PageInfo<>(userDao.findList(user));
	}
	
	@Transactional(readOnly = false)
	public void saveUser(User user) {
		user.setIsDeveloper("1");
		user.setUserType("4");
		if (StringUtils.isBlank(user.getId())) {
			user.setPassword(SystemService.entryptPassword(Global.getConfig("create.user.initpd"))); // 新增用户初始化密码
			user.preInsert();
			userDao.insert(user);
		} else {
			// 更新用户数据
			user.preUpdate();
			userDao.update(user);
		}
	}
}
