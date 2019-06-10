package com.jiewen.modules.sys.service;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.jiewen.jwp.base.service.CrudService;
import com.jiewen.modules.sys.dao.AppDao;
import com.jiewen.modules.sys.entity.App;
import com.jiewen.modules.sys.entity.User;
import com.jiewen.modules.sys.utils.UserUtils;
@Service
public class AppService extends CrudService<AppDao, App>{

	@Autowired
	private AppDao appDao;
	
	public PageInfo<App> findAppPage(App app) {
		// 生成数据权限过滤条件（dsf为dataScopeFilter的简写，在xml中使用 ${sqlMap.dsf}调用权限SQL）
				PageHelper.startPage(app);
				List<App> appList = appDao.selectAppList(app);
				return new PageInfo<>(appList);
	}

	@Override
	@Transactional(readOnly=false)
	public void save(App app) {
		User user = UserUtils.getUser();
		String officeId = user.getOfficeId();
		app.setOrganId(officeId);
		app.setCreateBy(user);
		app.setCreateDate(new Date());
		app.setDelFlag("0");
		app.setAppImg("");
		super.save(app);
	}
	
	public App getAppInfoById(String id) {
		App appParam = new App();
		appParam.setId(id);
		return appDao.getAppInfoById(appParam);
	}
	
	

}
