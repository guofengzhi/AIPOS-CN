
package com.jiewen.modules.sys.dao;

import org.springframework.transaction.annotation.Transactional;

import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.modules.sys.entity.AppDeveloper;


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
