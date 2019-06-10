package com.jiewen.spp.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.jiewen.base.core.AbstractService;
import com.jiewen.spp.dao.SysOfficeMapper;
import com.jiewen.spp.model.Office;
import com.jiewen.spp.service.SysOfficeService;

@Service
public class SysOfficeServiceImpl extends AbstractService<Office> implements SysOfficeService {

	@Resource
	private SysOfficeMapper sysOfficeMapper;

	@Override
	public String getOfficeList(String officeId) {
		Office office = sysOfficeMapper.selectByPrimaryKey(officeId);
		StringBuffer sbr = new StringBuffer();
		sbr.append("(").append("'").append(officeId).append("'");
		if (office != null) {
			String parentIds = office.getParentIds();
			String[] ids = parentIds.split(",");
			for (String id : ids) {
				sbr.append(",'").append(id).append("'");
			}
		}
		sbr.append(")");
		return sbr.toString();
	}
}
