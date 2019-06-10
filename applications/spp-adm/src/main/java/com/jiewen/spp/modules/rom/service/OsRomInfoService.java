
package com.jiewen.spp.modules.rom.service;

import java.io.File;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.jiewen.base.common.constant.Constant;
import com.jiewen.base.common.utils.CacheUtils;
import com.jiewen.base.core.exception.ServiceException;
import com.jiewen.base.core.service.CrudService;
import com.jiewen.base.sys.utils.UserUtils;
import com.jiewen.commons.util.DateTimeUtil;
import com.jiewen.jwp.common.utils.excel.ExcelReaderUtil;
import com.jiewen.spp.dto.DeviceOsInfoDto;
import com.jiewen.spp.modules.device.dao.DeviceDao;
import com.jiewen.spp.modules.device.entity.Device;
import com.jiewen.spp.modules.rom.dao.DeviceOsInfoDao;
import com.jiewen.spp.modules.rom.dao.OsRomInfoDao;
import com.jiewen.spp.modules.rom.dao.PushRecDao;
import com.jiewen.spp.modules.rom.dao.RecordRomInfoDao;
import com.jiewen.spp.modules.rom.dao.RomDeviceDao;
import com.jiewen.spp.modules.rom.entity.OsRomInfo;
import com.jiewen.spp.modules.upload.dao.SysFileDao;
import com.jiewen.spp.modules.upload.entity.SysFile;
import com.jiewen.spp.utils.LocaleMessageSourceUtil;
import com.jiewen.spp.utils.UploadUtil;
import com.jiewen.utils.StringUtil;

@Service
public class OsRomInfoService extends CrudService<OsRomInfoDao, OsRomInfo> {

	private static DeviceOsInfoDao deviceOsInfoDao;

	public DeviceOsInfoDao getDeviceOsInfoDao() {
		return deviceOsInfoDao;
	}

	@Autowired
	public void setDeviceOsInfoDao(DeviceOsInfoDao deviceOsInfoDao) {
		OsRomInfoService.deviceOsInfoDao = deviceOsInfoDao;
	}

	@Resource
	private LocaleMessageSourceUtil messageSourceUtil;

	@Autowired
	private OsRomInfoDao osRomInfoDao;

	@Autowired
	private SysFileDao sysFileDao;

	@Autowired
	private PushRecDao pushRecDao;

	@Autowired
	private RomDeviceDao romDeviceDao;

	@Autowired
	private RecordRomInfoDao recordRomInfoDao;

	@Autowired
	private DeviceDao deviceDao;

	@Override
	public List<OsRomInfo> findList(OsRomInfo osRomInfo) {
		return dao.findList(osRomInfo);
	}

	@Override
	public PageInfo<OsRomInfo> findPage(OsRomInfo osRomInfo) {
		PageHelper.startPage(osRomInfo);
		return new PageInfo<>(osRomInfoDao.findList(osRomInfo));
	}

	@Transactional(readOnly = false)
	public void saveOsRomInfo(OsRomInfo osRomInfo) {
		String versionAlreadyExist = messageSourceUtil.getMessage("modules.rom.version.already.exist");

		osRomInfo.setStartHardShift(StringUtil.formatVersion(osRomInfo.getStartHard()));
		osRomInfo.setEndHardShift(StringUtil.formatVersion(osRomInfo.getEndHard()));

		OsRomInfo romInfo = osRomInfoDao.getOsRomByVersionType(osRomInfo);
		if (romInfo != null) {
			throw new ServiceException(versionAlreadyExist);
		} else {
			osRomInfo.preInsert(true);
			osRomInfoDao.insert(osRomInfo);
		}
	}

	@Transactional(readOnly = false)
	public void deleteById(OsRomInfo osRomInfo) {

		Device device = new Device();
		device.setId(osRomInfo.getId());
		// device.setClientIdentification(osRomInfo.getClientIdentification());
		device.setDeviceType(osRomInfo.getOsDeviceType());
		List<Device> devices = deviceDao.findNormalAlreayRomDeviceList(device);
		osRomInfoDao.delete(osRomInfo);
		romDeviceDao.deleteRomDeviceByOsId(osRomInfo.getId());
		pushRecDao.deletePushRecByOsId(osRomInfo.getId());
		recordRomInfoDao.deleteRomRecordByOsId(osRomInfo.getId());
		// 开启新线程
		new RebuidCacheThread(devices).start();

	}

	public PageInfo<OsRomInfo> getOsRomByDeviceId(OsRomInfo osRomInfo) {
		PageHelper.startPage(osRomInfo);
		return new PageInfo<>(osRomInfoDao.getOsRomByDeviceId(osRomInfo));
	}

	/**
	 * 根据文件md5值查询是否存在上传进度
	 * 
	 * @param md5
	 * @return
	 */
	public SysFile selectProgressByFileMd5(String md5) {
		SysFile sysFile = new SysFile();
		sysFile.setFileMd5(md5);
		sysFile = sysFileDao.get(sysFile);
		if (sysFile == null) {
			sysFile = new SysFile();
			sysFile.setFileMd5(md5);
			sysFile.setFileProgress("0");
		}
		return sysFile;
	}

	@Transactional(readOnly = false)
	public boolean uploadCheckChunk(HttpServletRequest request) {
		String message = messageSourceUtil.getMessage("modules.rom.Check.merge.file.fail");

		try {
			// 文件名称
			String fileName = request.getParameter("fileName");
			// 文件唯一标识
			String fileMd5 = request.getParameter("fileMd5");
			// 当前分片下标以0开始
			String chunk = request.getParameter("chunk") == null ? "0" : request.getParameter("chunk");
			// 当前进度条数值
			String progress = request.getParameter("progress");
			// 当前分片大小
			String chunkSize = request.getParameter("chunkSize");
			SysFile sysFile = new SysFile();
			sysFile.setFileMd5(fileMd5);
			Timestamp timestamp = new Timestamp(new Date().getTime());
			SysFile chunkSysFile = sysFileDao.get(sysFile);
			String uploadTime = DateTimeUtil.getSystemDate();
			if (chunkSysFile != null) {
				timestamp = chunkSysFile.getUploadTime();
				uploadTime = DateTimeUtil.format(timestamp, "yyyyMMdd");
			}
			// 分片文件
			String tempPath = UploadUtil.getUploadDir(request) + "romfile" + uploadTime + File.separator + "partFile"
					+ File.separator + fileMd5 + File.separator + fileName + "_" + chunk + ".part";
			File checkFile = new File(tempPath);
			if (checkFile.exists() && checkFile.length() == Integer.parseInt(chunkSize)) {
				return true;
			} else {
				SysFile saveFile = new SysFile();
				saveFile.setFileMd5(fileMd5);
				saveFile.setFileProgress(progress);
				if (chunkSysFile == null) {
					saveFile.setUploadTime(timestamp);
					saveFile.preInsert();
					sysFileDao.insert(saveFile);
				} else {
					saveFile.setId(chunkSysFile.getId());
					saveFile.preUpdate();
					sysFileDao.update(saveFile);
				}
				return false;
			}

		} catch (Exception e) {
			logger.error(e.getMessage());
			throw new ServiceException(message);
		}

	}

	@Transactional(readOnly = false)
	public void deleteFile(String fileMd5) {
		SysFile sysFile = new SysFile();
		sysFile.setFileMd5(fileMd5);
		sysFileDao.delete(sysFile);
	}

	/**
	 * 全量处理相关数据缓存
	 * 
	 * @param devices
	 */
	public static void addCache(List<Device> devices) {
		if (devices != null) {
			for (Device device : devices) {
				getCheckVersion(device);
			}
		}
	}

	private static List<DeviceOsInfoDto> getCheckVersion(Device device) {
		DeviceOsInfoDto dto = new DeviceOsInfoDto();
		dto.setDeviceSn(device.getDeviceSn());
		String catchKey = device.getManufacturerNo() + device.getDeviceType() + device.getDeviceSn();
		List<DeviceOsInfoDto> result = OsRomInfoService.deviceOsInfoDao.getCheckVersion(dto);
		cacheRemove(catchKey);
		cachePut(catchKey, result);
		return result;
	}

	/**
	 * 
	 * @author Administrator
	 *
	 */
	public static class RebuidCacheThread extends Thread {

		private List<Device> devices;

		public RebuidCacheThread(List<Device> devices) {
			super(RebuidCacheThread.class.getSimpleName());
			this.devices = devices;
		}

		@Override
		public void run() {
			addCache(devices);
		}
	}

	@Transactional(readOnly = false)
	public Integer getDeviceCount() {
		return osRomInfoDao.getDeviceCount();
	}

	/**
	 * 通过上传设备sn文件，拼接设备sn参数
	 * 
	 * @param file
	 * @param romOrApp
	 * @return
	 * @throws Exception
	 */
	public long uploadDeviceSn(MultipartFile file, String romOrApp) throws Exception {
		String message = messageSourceUtil.getMessage("modules.rom.only.upload.five.thousand");

		StringBuffer deviceSnStr = new StringBuffer();
		List<String[]> deviceSnListAll = ExcelReaderUtil.excelToArrayList(file.getOriginalFilename(),
				file.getInputStream(), 0, null);
		if (deviceSnListAll.size() > 5000) {
			throw new ServiceException(message);
		}

		if (!deviceSnListAll.isEmpty()) {
			for (int i = 0; i < deviceSnListAll.size(); i++) {
				if (i == 0) {
					deviceSnStr.append(deviceSnListAll.get(i)[0]);
				} else {
					deviceSnStr.append("," + deviceSnListAll.get(i)[0]);
				}
			}
		}
		String cacheKey = "";
		String userId = UserUtils.getUser().getId();
		if (Constant.DEVICE_SN_ROM.equals(romOrApp)) {
			cacheKey = Constant.DEVICE_SN_ROM + userId;
		} else {
			cacheKey = Constant.DEVICE_SN_APP + userId;
		}
		CacheUtils.put(cacheKey, deviceSnStr);
		return deviceSnListAll.size();
	}

}
