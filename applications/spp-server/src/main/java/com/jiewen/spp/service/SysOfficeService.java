package com.jiewen.spp.service;

import com.jiewen.base.core.Service;
import com.jiewen.spp.model.Office;

public interface SysOfficeService extends Service<Office> {

	public String getOfficeList(String officeId);
}
