package com.jiewen.spp.service.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.codec.binary.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.jiewen.base.core.AbstractService;
import com.jiewen.base.excetion.OTAExcetion;
import com.jiewen.commons.util.DateTimeUtil;
import com.jiewen.spp.dao.AppInfoMapper;
import com.jiewen.spp.dao.AppSearchLogMapper;
import com.jiewen.spp.model.AppInfo;
import com.jiewen.spp.model.AppSearchLog;
import com.jiewen.spp.model.DeviceInfo;
import com.jiewen.spp.service.AppSearchService;
import com.jiewen.spp.wrapper.AppSearchWrapper;
import com.jiewen.utils.RspCode;

@Service
public class AppSearchServiceImpl extends AbstractService<AppInfo> implements AppSearchService {

	private static final String TYPE_LIST = "list";

	private static final String TYPE_NEW = "new";

	private static final String TYPE_RANK = "rank";

	private static final String TYPE_CLASS = "class";

	private static final String TYPE_CONDITION = "condition";

	@Resource
	private AppInfoMapper appInfoMapper;

	@Resource
	private AppSearchLogMapper appSearchLogMapper;

	@Autowired
	private SysOfficeServiceImpl sysOfficeService;

	@Value("${jdbc.type}")
	private String dbName;

	@Override
	public List<AppInfo> getAppInfoList(AppSearchWrapper requestWrapper, DeviceInfo deviceInfo) {

		// 记录APP搜索记录
		recordSearchLog(requestWrapper, deviceInfo);

		// 初始化查询条件
		int currentPage = Integer.parseInt(requestWrapper.getPage());
		int pageSize = Integer.parseInt(requestWrapper.getPageSize());
		int startNum = currentPage * pageSize;
		AppInfo record = new AppInfo();
		record.setDbName(dbName);
		record.setStartPageNum(startNum);
		record.setPageSize(pageSize);
		record.setIds(sysOfficeService.getOfficeList(deviceInfo.getOrganId()));

		List<AppInfo> appInfoList = new ArrayList<AppInfo>();
		String searchType = requestWrapper.getSearchType();
		if (StringUtils.equals(TYPE_LIST, searchType) || StringUtils.equals(TYPE_CLASS, searchType)
				|| StringUtils.equals(TYPE_CONDITION, searchType) || StringUtils.equals(TYPE_NEW, searchType)) { // 按照条件、最新等查询APP列表
			record.setCategory(requestWrapper.getClassId());
			record.setAppName(requestWrapper.getAppName());

			List<AppInfo> list = appInfoMapper.getAppInfoList(record);
			appInfoList.addAll(list);
		}
		if (StringUtils.equals(TYPE_RANK, searchType)) { // 按照排行查询APP列表
			List<AppInfo> list = appInfoMapper.getAppListByUpgradeCounts(record);
			appInfoList.addAll(list);
		}

		// 信息处理
		if (appInfoList != null) {
			for (AppInfo appInfo : appInfoList) {
				appInfo.setAppPackageName(appInfo.getAppFile().split("/")[appInfo.getAppFile().split("/").length - 1]);
			}
		}
		return appInfoList;
	}

	private void recordSearchLog(AppSearchWrapper requestWrapper, DeviceInfo deviceInfo) {
		AppSearchLog appSearchLog = new AppSearchLog();
		appSearchLog.setDeviceSn(requestWrapper.getSn());
		appSearchLog.setSearchType(requestWrapper.getSearchType());
		appSearchLog.setAppName(requestWrapper.getAppName());
		appSearchLog.setClassId(requestWrapper.getClassId());
		String currentDate = DateTimeUtil.getSystemDateTime("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		try {
			appSearchLog.setCreateDate(sdf.parse(currentDate));
		} catch (ParseException e) {
			logger.error(e.getMessage());
			throw new OTAExcetion(RspCode.SYSTEM_ERROR, "系统错误,前联系服务商!");
		}
		if (StringUtils.equals(TYPE_LIST, requestWrapper.getSearchType())) {
			appSearchLog.setRemarks(String.format("%s{%s}", "应用列表查询", "sn:" + requestWrapper.getSn()));
		} else if (StringUtils.equals(TYPE_CLASS, requestWrapper.getSearchType())) {
			appSearchLog.setRemarks(String.format("%s{%s}", "按照类别查询", "sn:" + requestWrapper.getSn()));
		} else if (StringUtils.equals(TYPE_CONDITION, requestWrapper.getSearchType())) {
			appSearchLog.setRemarks(String.format("%s{%s}", "按照条件查询", "sn:" + requestWrapper.getSn()));
		} else if (StringUtils.equals(TYPE_NEW, requestWrapper.getSearchType())) {
			appSearchLog.setRemarks(String.format("%s{%s}", "最新应用列表查询", "sn:" + requestWrapper.getSn()));
		} else if (StringUtils.equals(TYPE_RANK, requestWrapper.getSearchType())) {
			appSearchLog.setRemarks(String.format("%s{%s}", "按照应用排行查询", "sn:" + requestWrapper.getSn()));
		} else {
			appSearchLog.setRemarks(String.format("%s{%s}", "", "sn:" + requestWrapper.getSn()));
		}
		appSearchLog.setOrganId(deviceInfo.getOrganId());
		appSearchLog.setDelFlag("0");
		appSearchLogMapper.insertSelective(appSearchLog);
	}

}
