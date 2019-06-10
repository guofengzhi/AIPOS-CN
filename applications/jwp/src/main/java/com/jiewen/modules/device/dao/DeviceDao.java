package com.jiewen.modules.device.dao;

import java.util.List;

import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.modules.device.entity.Device;

/**
 * 设备Dao
 * 
 * @author Administrator
 *
 */
public interface DeviceDao extends CrudDao<Device> {

    // 查找未发布的版本的设备列表
    public List<Device> findNoRomDeviceList(Device device);

    //
    public List<Device> findNormalNoRomDeviceList(Device device);

    // 查找已经发布了的， 不带字典值转换的设备列表
    public List<Device> findNormalAlreayRomDeviceList(Device device);

    // 查找已经发布版本的设备列表
    public List<Device> findAlreayRomDeviceList(Device device);

    // 查找设备通过deviceSn
    public Device findDeviceByDeviceSn(Device device);

    // 查找设备列表通过ids
    public List<Device> findDeviceListByIds(List<Integer> idList);

    // 查找设备
    public Device findDeviceById(Device device);

    // 根据条件查询设备列表
    public List<Device> getDeviceList(Device device);

    // 通过厂商设备类型查找未发布应用的设备列表
    public List<Device> findNoAppDeviceListByTypesManus(Device device);

    // 通过厂商设备类型查找已发布应用的设备列表
    public List<Device> findAlreayAppDeviceList(Device device);

    // 发布记录
    public List<Device> getAppRecordDeviceList(Device device);

    // 按设备类型发布要用的设备列表
    public List<Device> findDeviceListByParams(Device device);

    // 查找设备 关联字段已转换
    public Device findDeviceInfoById(Device device);

    // 查找数量
    public Integer getDeviceCount(Device device);

    // 查找客户设备数量
    public Integer getCustomerDeviceCount(Device device);

    // 查找版本对应的设备数量列表
    public List<Device> findRomDeviceCount(Device device);

	/**获取机构下未绑定的终端
	 * @param device
	 * @return
	 */
	public List<Device> getOrgDevices(Device device);

	public Device getBySn(Device deviceParam);

	public void updateBundStateById(Device deviceParam);

	public void updateBoundState(Device device);

	public void updateBatchBoundState(List ids);

	public void batchBundDevice(List<Device> deviceList);

}
