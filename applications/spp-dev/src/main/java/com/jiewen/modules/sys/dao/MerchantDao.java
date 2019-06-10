package com.jiewen.modules.sys.dao;

import com.jiewen.modules.sys.domain.MerchantDO;

import java.util.List;
import java.util.Map;

import org.springframework.transaction.annotation.Transactional;

/**
 * 商户表
 * @author 李裕泽 捷文科技
 * @email 461539197@qq.com
 * @date 2018-11-28 15:12:53
 */
@Transactional
public interface MerchantDao {

	MerchantDO get(String id);
	
	List<MerchantDO> list(MerchantDO merchant);
	
	int save(MerchantDO merchant);
	
	int update(MerchantDO merchant);
	
	int remove(String id);
	
	int batchRemove(String[] ids);
}
