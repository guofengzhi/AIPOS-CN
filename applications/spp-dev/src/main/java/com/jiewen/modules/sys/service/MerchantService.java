package com.jiewen.modules.sys.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

import com.jiewen.modules.sys.dao.MerchantDao;
import com.jiewen.modules.sys.domain.MerchantDO;
import com.jiewen.modules.sys.service.MerchantService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

/**
 * MerchantService
 */
@Service
@Transactional
public class MerchantService  {

	@Autowired
	private MerchantDao merchantDao;
	
	public MerchantDO get(String id){
		return merchantDao.get(id);
	}
	
	
	public PageInfo<MerchantDO> list(MerchantDO merchant){
	
		  PageHelper.startPage(merchant);
		  
		  return new PageInfo<MerchantDO>(merchantDao.list(merchant));
	}
	
	public int save(MerchantDO merchant){
		return merchantDao.save(merchant);
	}
	
	public int update(MerchantDO merchant){
		return merchantDao.update(merchant);
	}
	
	public int remove(String id){
		return merchantDao.remove(id);
	}
	
	public int batchRemove(String[] ids){
		return merchantDao.batchRemove(ids);
	}
	
}
