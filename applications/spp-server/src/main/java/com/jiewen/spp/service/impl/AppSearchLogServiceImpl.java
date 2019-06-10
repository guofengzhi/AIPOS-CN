package com.jiewen.spp.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.jiewen.base.core.AbstractService;
import com.jiewen.spp.dao.AppSearchLogMapper;
import com.jiewen.spp.model.AppSearchLog;
import com.jiewen.spp.model.DeviceInfo;
import com.jiewen.spp.service.AppSearchLogService;
import com.jiewen.spp.wrapper.TopSearchWrapper;

@Service
public class AppSearchLogServiceImpl extends AbstractService<AppSearchLog> implements AppSearchLogService {

	@Resource
	private AppSearchLogMapper appSearchLogMapper;

	@Value("${jdbc.type}")
	private String dbName;

	@Override
	public List<AppSearchLog> getTopSearchList(TopSearchWrapper requestWrapper, DeviceInfo deviceInfo) {
		AppSearchLog record = new AppSearchLog();
		int currentPage = Integer.parseInt(requestWrapper.getPage());
		int pageSize = Integer.parseInt(requestWrapper.getPageSize());
		int startNum = currentPage * pageSize;
		record.setPage(startNum);
		record.setPageSize(pageSize);
		record.setDbName(dbName);
		record.setOrganId(deviceInfo.getOrganId());
		List<AppSearchLog> list = appSearchLogMapper.getTopSearchList(record);
		return list;
	}

}
