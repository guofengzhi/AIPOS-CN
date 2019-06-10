
package com.jiewen.modules.sys.dao;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.modules.sys.entity.AppVersion;


/**
 * APPDao
 * 
 * @author Administrator
 *
 */
@Transactional
public interface AppVersionDao extends CrudDao<AppVersion> {

	public List<AppVersion> findAppVerListByParams(AppVersion appVersion);

	public List<AppVersion> findAppVersionByDeviceSn(AppVersion appVersion);

	public List<AppVersion> findAppVersionBySn(AppVersion appVersion);

	public List<AppVersion> findAppVerByVersion(AppVersion appVersion);

}
