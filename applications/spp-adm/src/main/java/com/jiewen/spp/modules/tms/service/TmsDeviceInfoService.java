package com.jiewen.spp.modules.tms.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.jiewen.base.core.service.CrudService;
import com.jiewen.spp.modules.tms.dao.TmsDeviceInfoDao;
import com.jiewen.spp.modules.tms.entity.TmsDeviceInfo;

/**
 * @author Pang.M
 */
@Service
public class TmsDeviceInfoService extends CrudService<TmsDeviceInfoDao, TmsDeviceInfo> {

	@Autowired
	private TmsDeviceInfoDao tmsDeviceInfoDao;

}
