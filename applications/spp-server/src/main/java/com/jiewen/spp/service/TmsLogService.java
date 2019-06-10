package com.jiewen.spp.service;

import com.jiewen.base.core.Service;
import com.jiewen.spp.model.TmsLog;
import com.jiewen.spp.wrapper.ResultNotifyWrapper;

public interface TmsLogService extends Service<TmsLog> {

	void resultNotify(ResultNotifyWrapper resultNotifyWrapper);

}
