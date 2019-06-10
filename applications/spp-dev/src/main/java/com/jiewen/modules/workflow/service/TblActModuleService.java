package com.jiewen.modules.workflow.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.jiewen.jwp.base.service.CrudService;
import com.jiewen.modules.workflow.dao.TblActModuleDao;
import com.jiewen.modules.workflow.entity.TblActModule;

@Service
@Transactional(readOnly = true)
public class TblActModuleService extends CrudService<TblActModuleDao, TblActModule> {

	@Autowired
	private TblActModuleDao tblActModuleDao;

	@Override
	public TblActModule get(TblActModule module) {
		return tblActModuleDao.get(module);
	}

	@Transactional(readOnly = false)
	public void update(TblActModule module) {
		module.preUpdate();
		tblActModuleDao.update(module);
	}

	@Transactional(readOnly = true)
	public TblActModule getByCode(String code) {
		TblActModule module = new TblActModule();
		module.setCode(code);
		return tblActModuleDao.getByCode(module);
	}

	@Transactional(readOnly = true)
	public PageInfo<TblActModule> findByPage(TblActModule module) {
		PageHelper.startPage(module);
		return new PageInfo<>(tblActModuleDao.findList(module));
	}

	@Transactional(readOnly = true)
	public List<TblActModule> getAll() {
		return tblActModuleDao.getAll();
	}

	public List<String> findModuleList() {
		return tblActModuleDao.getModuleList(new TblActModule());
	}
}
