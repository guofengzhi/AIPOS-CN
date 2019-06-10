package com.jiewen.modules.workflow.dao;

import java.util.List;

import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.modules.workflow.entity.TblActModule;

public interface TblActModuleDao extends CrudDao<TblActModule> {

	public List<TblActModule> findList(TblActModule module);

	public TblActModule getByCode(TblActModule module);

	public List<TblActModule> getAll();

	public List<String> getModuleList(TblActModule module);
}
