
package com.jiewen.spp.modules.app.dao;

import org.springframework.transaction.annotation.Transactional;

import com.jiewen.base.core.dao.CrudDao;
import com.jiewen.spp.modules.app.entity.AppDeveloper;

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
