
package com.jiewen.base.sys.dao;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import com.jiewen.base.core.dao.CrudDao;
import com.jiewen.base.sys.entity.Merchant;

/**
 * 用户DAO接口
 */
@Transactional
public interface MerchantDao extends CrudDao<Merchant> {
	
	/**查询所有商户
	 * @param merchant
	 * @return
	 */
	public List<Merchant> selectMerchantList(Merchant merchant);

	/**根据id删除商户
	 * @param id
	 */
	public void deleteMerchant(String id);

	/**根据id更新商户
	 * @param merchant
	 */
	public void updateMerchant(Merchant merchant);

	public List<Merchant> getAllMerchant(Merchant merchant);

	public Merchant getMerchantByMerId(String merId);

	public Merchant getMerchantById(String id);
	
	public List<Merchant> getAllMerchantWithStores(String organId);
}
