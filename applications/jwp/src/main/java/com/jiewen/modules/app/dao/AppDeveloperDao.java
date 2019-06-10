package com.jiewen.modules.app.dao;

import org.springframework.transaction.annotation.Transactional;

import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.modules.app.entity.AppDeveloper;

/**
 * APPDao
 * 
 * @author Administrator
 *
 */
@Transactional
public interface AppDeveloperDao extends CrudDao<AppDeveloper> {

    public AppDeveloper findAppDeveloperByName(String developerName);

}
