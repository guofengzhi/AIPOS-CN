package com.jiewen.spp.dao;

import com.jiewen.base.core.Mapper;
import com.jiewen.spp.model.DeviceInfo;

@org.apache.ibatis.annotations.Mapper
public interface DeviceInfoMapper extends Mapper<DeviceInfo> {

	DeviceInfo get(DeviceInfo deviceInfo);

	void updateJwd(DeviceInfo deviceInfo);

}