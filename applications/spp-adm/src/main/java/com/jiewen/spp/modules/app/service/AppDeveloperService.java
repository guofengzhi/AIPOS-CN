
package com.jiewen.spp.modules.app.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jiewen.base.core.service.CrudService;
import com.jiewen.spp.modules.app.dao.AppDeveloperDao;
import com.jiewen.spp.modules.app.entity.AppDeveloper;

@Service
@Transactional(readOnly = true)
public class AppDeveloperService extends CrudService<AppDeveloperDao, AppDeveloper> {

    @Autowired
    private AppDeveloperDao appDeveloperDao;

    @Transactional(readOnly = false)
    public void deleteById(AppDeveloper appDeveloper) {
        dao.delete(appDeveloper);
    }

    @Transactional(readOnly = false)
    public void saveAppDeveloper(AppDeveloper appDeveloper) {
        appDeveloper.preInsert(true);
        dao.insert(appDeveloper);
    }

    @Transactional(readOnly = false)
    public void update(AppDeveloper appDeveloper) {

        appDeveloper.preUpdate();
        dao.update(appDeveloper);
    }

    public AppDeveloper findAppDeveloperByName(String developName) {
        return appDeveloperDao.findAppDeveloperByName(developName);
    }

}
