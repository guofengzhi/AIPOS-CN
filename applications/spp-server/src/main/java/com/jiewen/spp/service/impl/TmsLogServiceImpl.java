package com.jiewen.spp.service.impl;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.exceptions.TooManyResultsException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.jiewen.spp.dao.TmsFileMapper;
import com.jiewen.spp.dao.TmsLogMapper;
import com.jiewen.spp.model.TmsFile;
import com.jiewen.spp.model.TmsLog;
import com.jiewen.spp.service.TmsLogService;
import com.jiewen.spp.wrapper.ResultNotifyWrapper;

import tk.mybatis.mapper.entity.Condition;

@Service
public class TmsLogServiceImpl implements TmsLogService {

	@Autowired
	private TmsLogMapper tmsLogMapper;
	
	@Autowired
	private TmsFileMapper tmsFileMapper;
	
	@Override
	public void save(TmsLog model) {
		tmsLogMapper.insert(model);
	}

	@Override
	public void resultNotify(ResultNotifyWrapper resultNotifyWrapper) {
		/*根据厂商、文件类型、文件版本获取文件*/
		TmsFile tmsFile = new TmsFile();
		tmsFile.setFileType(resultNotifyWrapper.getFileType());
		tmsFile.setFileVersion(resultNotifyWrapper.getFileVersion());
		tmsFile.setManufactureNo(resultNotifyWrapper.getManufacturer());
		TmsFile file = tmsFileMapper.findByCondition(tmsFile);
		TmsLog tmsLog = new TmsLog();
		if (file == null) {
			String sn = resultNotifyWrapper.getSn();
			String manufactureNo = resultNotifyWrapper.getManufacturer();
			String deviceType = resultNotifyWrapper.getDeviceType();
			String fileName = resultNotifyWrapper.getFileName();
			String fileType = resultNotifyWrapper.getFileType();
			String fileVersion = resultNotifyWrapper.getFileVersion();
			tmsLog.setFileVersion(fileVersion);
			tmsLog.setDeviceSn(sn);
			tmsLog.setManufacture(manufactureNo);
			tmsLog.setDeviceType(deviceType);
			tmsLog.setFileName(fileName);
			tmsLog.setFileType(fileType);
		} else {
			//根据文件内容通过逻辑关系获取所需要的日志内容
			tmsLog = tmsLogMapper.getLogInfoByFile(file);
		}
		tmsLog.setOperateDate(new Date());
		save(tmsLog);
	}

	@Override
	public void save(List<TmsLog> models) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteById(Integer id) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteByIds(String ids) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void update(TmsLog model) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public TmsLog findById(Integer id) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public TmsLog findBy(String fieldName, Object value) throws TooManyResultsException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<TmsLog> findByIds(String ids) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<TmsLog> findByCondition(Condition condition) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<TmsLog> findAll() {
		// TODO Auto-generated method stub
		return null;
	}

}
