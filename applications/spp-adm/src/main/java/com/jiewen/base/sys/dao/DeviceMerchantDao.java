
package com.jiewen.base.sys.dao;

import java.util.List;

import com.jiewen.base.core.dao.CrudDao;
import com.jiewen.base.sys.entity.DeviceMerchant;
import com.jiewen.spp.modules.device.entity.Device;

/**
 * 用户DAO接口
 */
public interface DeviceMerchantDao extends CrudDao<DeviceMerchant> {

	void insertDeviceMerchant(DeviceMerchant deviceMerchant);

	List<DeviceMerchant> selectDeviceMerchantList(DeviceMerchant deviceMerchant);

	void updateBoundState(String id);
	
	/**获取所有未绑定的设备
	 * @param device 
	 * @return
	 */
	public List<Device> getUnBoundTerms(Device device);

	void batchUnBound(List<DeviceMerchant> deviceMerchantList);

	List<Device> getUnBoundStoreTerms(Device device);

	List<DeviceMerchant> selectDeviceStoreList(DeviceMerchant deviceMerchant);

	DeviceMerchant getBoundTermBySn(String sn);

	void updateDeviceMerchant(DeviceMerchant dm);

	List<DeviceMerchant> findDeviceUnBoundPage(DeviceMerchant deviceMerchant);

	List<DeviceMerchant> boundAndUnBound(DeviceMerchant deviceMerchant);
	
}
