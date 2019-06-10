package com.jiewen.spp.service;

import com.jiewen.base.core.Service;
import com.jiewen.spp.model.TmsStrategy;

public interface TmsStrategyService extends Service<TmsStrategy> {

	TmsStrategy getStrategyByFileId(String id);
}
