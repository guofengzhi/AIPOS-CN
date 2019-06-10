package com.jiewen.spp.service.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.jiewen.base.core.AbstractService;
import com.jiewen.base.excetion.OTAExcetion;
import com.jiewen.commons.util.DateTimeUtil;
import com.jiewen.spp.dao.AdvertisementMapper;
import com.jiewen.spp.model.Advertisement;
import com.jiewen.spp.model.DeviceInfo;
import com.jiewen.spp.service.GetAdvertisementService;
import com.jiewen.spp.wrapper.GetAdvertisementWrapper;
import com.jiewen.utils.RspCode;

@Service
public class GetAdvertisementServiceImpl extends AbstractService<Advertisement> implements GetAdvertisementService {

	@Resource
	private AdvertisementMapper advertisementMapper;

	@Autowired
	private SysOfficeServiceImpl sysOfficeService;

	@Value("${jdbc.type}")
	private String dbName;

	@Override
	public List<Advertisement> getAdvertisement(GetAdvertisementWrapper requestWrapper, DeviceInfo deviceInfo) {
		Advertisement advertisement = new Advertisement();
		advertisement.setIds(sysOfficeService.getOfficeList(deviceInfo.getOrganId()));
		String currentDate = DateTimeUtil.getSystemDateTime("yyyy-MM-dd");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		try {
			Date startDate = sdf.parse(currentDate + " 23:59:59");
			advertisement.setAdStartTime(startDate);
			Date endDate = sdf.parse(currentDate + " 00:00:00");
			advertisement.setAdEndTime(endDate);
		} catch (ParseException e) {
			logger.error(e.getMessage());
			throw new OTAExcetion(RspCode.SYSTEM_ERROR, "系统错误,前联系服务商!");
		}

		int currentPage = Integer.parseInt(requestWrapper.getPage());
		int pageSize = Integer.parseInt(requestWrapper.getPageSize());
		int startNum = currentPage * pageSize;
		advertisement.setStartPageNum(startNum);
		advertisement.setPageSize(pageSize);
		advertisement.setDbName(dbName);

		List<Advertisement> list = advertisementMapper.getAdvertisementList(advertisement);
		return list;
	}

}
