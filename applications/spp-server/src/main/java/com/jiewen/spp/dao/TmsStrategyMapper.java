package com.jiewen.spp.dao;

import com.jiewen.base.core.Mapper;
import com.jiewen.spp.model.TmsStrategy;

public interface TmsStrategyMapper extends Mapper<TmsStrategy> {

	TmsStrategy getStrategyByFileId(String id);


}
