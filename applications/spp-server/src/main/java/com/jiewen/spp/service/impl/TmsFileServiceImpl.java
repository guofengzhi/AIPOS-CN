package com.jiewen.spp.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSONObject;
import com.jiewen.base.core.AbstractService;
import com.jiewen.base.excetion.OTAExcetion;
import com.jiewen.spp.dao.TmsDeviceInfoMapper;
import com.jiewen.spp.dao.TmsFileMapper;
import com.jiewen.spp.dao.TmsFileStrategyMapper;
import com.jiewen.spp.dao.TmsLogMapper;
import com.jiewen.spp.model.TmsFile;
import com.jiewen.spp.model.TmsStrategy;
import com.jiewen.spp.service.TmsFileService;
import com.jiewen.spp.wrapper.GetFileWrapper;
import com.jiewen.spp.wrapper.TmsCheckVersionWrapper;
import com.jiewen.utils.ReadFtpFileUtil;
import com.jiewen.utils.RspCode;
import com.jiewen.utils.RspJsonNode;
import com.jiewen.utils.StringUtil;

@Service
public class TmsFileServiceImpl extends AbstractService<TmsFile> implements TmsFileService {

	@Autowired
	private TmsFileMapper tmsFileMapper;
	
	@Autowired
	private TmsDeviceInfoMapper tmsDeviceInfoMapper;

	@Autowired
	private TmsFileStrategyMapper tmsFileStrategyMapper;
	
	@Autowired
	private TmsLogMapper tmsLogMapper;
	
	@Value("${ftp.host}")
	protected String ftpHost;

	@Value("${ftp.username}")
	protected String ftpUsername;

	@Value("${ftp.password}")
	protected String ftpPassword;

	@Value("${ftp.tms.path}")
	protected String tmsPath;

	@Override
	public TmsFile getFileInfo(GetFileWrapper requestWrapper) {
		TmsFile params = new TmsFile();
		params.setFileType(requestWrapper.getFileType());
		params.setFileVersion(requestWrapper.getFileVersion());
		params.setFileName(requestWrapper.getFileName());
		params.setManufactureNo(requestWrapper.getManufacturer());
		TmsFile tmsFile = tmsFileMapper.getDownLoadFileByFileParams(params);
		if (tmsFile == null) {
			// 未找到更新物，返回失败。
			throw new OTAExcetion(RspCode.SYSTEM_ERROR, "未找到可用的更新文件!");
		} else {
			// 连接ftp服务器
			connectFtp();
			// 获取文件路径，例如：
			// http://ipos-n.jiewen.com.cn/tms/vanstone/1/v1.0/icon.jpg
			// 我们这里只需要：tms/vanstone/1/v1.0/icon.jpg该路径，提供去读取文件内容
			String path = tmsFile.getFilePath().substring(tmsFile.getFilePath().indexOf(tmsPath),
					tmsFile.getFilePath().length());
			// 找到更新物，按照起止位置读取更新物
			long start;
			try {
				start = Long.parseLong(requestWrapper.getStartPosi());
			} catch (NumberFormatException e) {
				logger.error(e.getMessage());
				throw new OTAExcetion(RspCode.SYSTEM_ERROR, "文件读取起始位置有误!");
			}

			String readContent = ReadFtpFileUtil.readFile(start, path);
			tmsFile.setRemarks(readContent);
			return tmsFile;
		}
	}

	/**
	 * 链接Ftp服务器
	 * 
	 * @param ip
	 * @param userName
	 * @param userPwd
	 */
	public void connectFtp() {
		ReadFtpFileUtil.setHost(ftpHost);
		ReadFtpFileUtil.setUsername(ftpUsername);
		ReadFtpFileUtil.setPassword(ftpPassword);
	}

	@Override
	public List<JSONObject> getFileList(TmsCheckVersionWrapper requestWrapper) {
		List<JSONObject> resultJson = new ArrayList<JSONObject>();
		// 根据SN、厂商获取策略
		TmsStrategy tmsStrategy = tmsDeviceInfoMapper.getStrategyByCondition(requestWrapper);
		if (null != tmsStrategy && StringUtil.isNotEmpty(tmsStrategy.getId())) {
			String updateTime = tmsStrategy.getUpdateTime();
			// 根据策略获取更新
			List<TmsFile> tmsFiles = tmsFileStrategyMapper.findFilesByStrategy(tmsStrategy);
			// 判断策略更新次数,如果一次去日志表中查询是否有记录如果没有返回如果有去除,如果多次直接返回
			if (updateTime.equalsIgnoreCase("O")) {
				List<TmsFile> finishedTmsFiles = tmsLogMapper.getFilesByStrategy(tmsStrategy);
				tmsFiles.removeAll(finishedTmsFiles);
			}
			for (TmsFile tmsFile : tmsFiles) {
				JSONObject json = new JSONObject();
				json.put(RspJsonNode.FILE_NAME, tmsFile.getFileName());
				json.put(RspJsonNode.FILE_PATH, tmsFile.getFilePath());
				json.put(RspJsonNode.FILE_TYPE, tmsFile.getFileType());
				json.put(RspJsonNode.FILE_VERSION, tmsFile.getFileVersion());
				json.put(RspJsonNode.FILE_SIZE, tmsFile.getFileSize());
				json.put(RspJsonNode.UPLOAD_TIME, tmsFile.getUploadTime());
				resultJson.add(json);
			}
		}
		return resultJson;
	}

	@Override
	public TmsFile findByCondition(GetFileWrapper requestWrapper) {
		TmsFile tmsFile = new TmsFile();
		tmsFile.setManufactureNo(requestWrapper.getManufacturer());
		tmsFile.setFileType(requestWrapper.getFileType());
		tmsFile.setFileVersion(requestWrapper.getFileVersion());
		return tmsFileMapper.findByCondition(tmsFile);
	}

}
