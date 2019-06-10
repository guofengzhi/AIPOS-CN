
package com.jiewen.base.sys.dao;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import com.jiewen.base.core.dao.CrudDao;
import com.jiewen.base.sys.entity.Merchant;
import com.jiewen.base.sys.entity.Store;

/**
 * 用户DAO接口
 */
@Transactional
public interface StoreDao extends CrudDao<Store> {
	
	/**查询所有门店
	 * @param merchant
	 * @return
	 */
	public List<Store> selectStoreList(Store store);

	/**根据id删除门店
	 * @param id
	 */
	public void deleteStore(String id);

	/**根据id更新门店
	 * @param merchant
	 */
	public void updateStore(Store store);

	public List<Store> getAllStore(Store store);

	public Store getStoreByStoreId(String storeId);

}
