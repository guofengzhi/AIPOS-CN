
package com.jiewen.spp.modules.app.dao;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import com.jiewen.base.core.dao.CrudDao;
import com.jiewen.spp.modules.app.entity.AppVersion;

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
