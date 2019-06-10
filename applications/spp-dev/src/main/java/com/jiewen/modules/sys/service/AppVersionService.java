
package com.jiewen.modules.sys.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jiewen.jwp.base.service.CrudService;
import com.jiewen.modules.sys.dao.AppVersionDao;
import com.jiewen.modules.sys.entity.AppVersion;

@Service
public class AppVersionService extends CrudService<AppVersionDao, AppVersion> {

	@Override
	@Transactional(readOnly = false)
	public void save(AppVersion entity) {
		super.save(entity);
	}
}
