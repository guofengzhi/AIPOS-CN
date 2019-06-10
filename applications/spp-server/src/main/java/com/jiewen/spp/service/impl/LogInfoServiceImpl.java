package com.jiewen.spp.service.impl;

import java.io.File;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.jiewen.base.core.AbstractService;
import com.jiewen.base.excetion.OTAExcetion;
import com.jiewen.commons.util.DateTimeUtil;
import com.jiewen.commons.util.IOUtil;
import com.jiewen.spp.dao.LogInfoMapper;
import com.jiewen.spp.model.LogInfo;
import com.jiewen.spp.service.LogInfoService;
import com.jiewen.spp.wrapper.RecLogInfoWrapper;
import com.jiewen.utils.RspCode;

/**
 * Created by CodeGenerator on 2017/10/24.
 */
@Service
@Transactional
public class LogInfoServiceImpl extends AbstractService<LogInfo> implements LogInfoService {

	@Resource
	private LogInfoMapper logInfoMapper;

	@Value("${http.uploader.path}")
	private String uploaderPath;

	@Override
	public void recLogInfo(RecLogInfoWrapper recLogInfoWrapper, MultipartFile file) {
		LogInfo logInfo = new LogInfo();
		logInfo.setSn(recLogInfoWrapper.getSn());
		logInfo.setDeviceType(recLogInfoWrapper.getDeviceType());
		logInfo.setManufacturerNo(recLogInfoWrapper.getManufacturer());
		logInfo.setLogName(recLogInfoWrapper.getLogName());
		logInfo.setLogMd5(recLogInfoWrapper.getLogMd5());
		logInfo.setVersion(recLogInfoWrapper.getVersion());

		String dateTime = DateTimeUtil.getSystemDateTime("yyyyMMddHHmmss");
		Date date = null;
		try {
			date = new SimpleDateFormat("yyyyMMddHHmmss").parse(dateTime);
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw new OTAExcetion(RspCode.SYSTEM_ERROR, "系统错误,前联系服务商!");
		}
		logInfo.setRecDate(date);
		String filePath = this.createFileDir(file);
		logInfo.setFilePath(filePath);
		logInfo.setFileSize(file.getSize());
		recLogFile(uploaderPath + filePath, file);

		logInfoMapper.insertSelective(logInfo);

	}

	/**
	 * 保存日志文件到本地
	 * 
	 * @param path
	 * @param file
	 */
	private void recLogFile(String path, MultipartFile file) {
		FileOutputStream fos = null;
		try {
			File f = new File(path);
			fos = new FileOutputStream(f);
			fos.write(file.getBytes());
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw new OTAExcetion(RspCode.SYSTEM_ERROR, "系统错误,前联系服务商!");
		} finally {
			IOUtil.closeQuietly(fos);
		}
	}

	/**
	 * 根据设备序列号、日期创建文件夹
	 * 
	 * @param file
	 * @return
	 */
	private String createFileDir(MultipartFile file) {
		// 00021000273_20171024160810.zip
		String fileName = file.getOriginalFilename();
		String[] strArray = StringUtils.split(StringUtils.split(fileName, ".")[0], "_");
		String snPath = File.separator + strArray[0] + File.separator + strArray[1].substring(0, 8);
		;
		createDirectory(uploaderPath + snPath);
		return snPath + File.separator + fileName;
	}

	/**
	 * 创建目录
	 * 
	 * @param descDirName
	 *            目录名,包含路径
	 * @return 如果创建成功，则返回true，否则返回false
	 */
	public boolean createDirectory(String descDirName) {
		String descDirNames = descDirName;
		if (!descDirNames.endsWith(File.separator)) {
			descDirNames = descDirNames + File.separator;
		}
		File descDir = new File(descDirNames);
		if (descDir.exists()) {
			logger.debug("目录 {} 已存在!", descDirNames);
			return false;
		}
		// 创建目录
		if (descDir.mkdirs()) {
			logger.debug("目录 {} 创建成功!", descDirNames);
			return true;
		} else {
			logger.debug("目录 {} 创建失败!", descDirNames);
			return false;
		}

	}

}
