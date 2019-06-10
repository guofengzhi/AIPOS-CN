package com.jiewen.spp.dao;

import com.jiewen.base.core.Mapper;
import com.jiewen.spp.model.TmsDeviceInfo;
import com.jiewen.spp.model.TmsStrategy;
import com.jiewen.spp.wrapper.TmsCheckVersionWrapper;

public interface TmsDeviceInfoMapper extends Mapper<TmsDeviceInfo> {

	/**
	 * 根据SN、厂商获取策略
	 * @param requestWrapper
	 * @return
	 */
	TmsStrategy getStrategyByCondition(TmsCheckVersionWrapper requestWrapper);

}
