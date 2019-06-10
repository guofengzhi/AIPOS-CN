package com.jiewen.spp.dao;

import java.util.List;

import com.jiewen.spp.model.TmsFile;
import com.jiewen.spp.model.TmsStrategy;

public interface TmsFileStrategyMapper {

	/**
	 * 根据策略从关联表、文件表中获取文件
	 * @param tmsStrategy
	 * @return
	 */
	List<TmsFile> findFilesByStrategy(TmsStrategy tmsStrategy);


}
