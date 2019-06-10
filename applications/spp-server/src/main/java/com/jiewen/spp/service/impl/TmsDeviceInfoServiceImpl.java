package com.jiewen.spp.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.jiewen.base.core.AbstractService;
import com.jiewen.spp.dao.TmsDeviceInfoMapper;
import com.jiewen.spp.model.TmsDeviceInfo;
import com.jiewen.spp.service.TmsDeviceInfoService;

@Service
public class TmsDeviceInfoServiceImpl extends AbstractService<TmsDeviceInfo> implements TmsDeviceInfoService {

	@Autowired
	private TmsDeviceInfoMapper tmsDeviceInfoDao;


}
