package com.jiewen.modules.sys.dao;

import java.util.List;

import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.modules.sys.entity.App;

public interface AppDao extends CrudDao<App> {

	List<App> selectAppList(App app);

	App getAppInfoById(App appParam);

}
