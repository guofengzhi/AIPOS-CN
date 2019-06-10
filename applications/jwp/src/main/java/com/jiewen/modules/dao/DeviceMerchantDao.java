package com.jiewen.modules.dao;

import java.util.List;

import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.modules.device.entity.Device;
import com.jiewen.modules.entity.DeviceMerchant;

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
