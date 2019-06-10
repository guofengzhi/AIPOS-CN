
package com.jiewen.spp.modules.device.service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.jiewen.base.common.constant.JSONConstant;
import com.jiewen.base.core.service.CrudService;
import com.jiewen.base.sys.dao.DeviceMerchantDao;
import com.jiewen.base.sys.dao.MerchantDao;
import com.jiewen.base.sys.dao.StoreDao;
import com.jiewen.base.sys.entity.Merchant;
import com.jiewen.base.sys.entity.Store;
import com.jiewen.base.sys.entity.User;
import com.jiewen.base.sys.utils.UserUtils;
import com.jiewen.commons.util.StringUtil;
import com.jiewen.jwp.common.exception.ServiceException;
import com.jiewen.jwp.common.utils.DateUtils;
import com.jiewen.jwp.common.utils.excel.ExcelReaderUtil;
import com.jiewen.spp.modules.app.dao.AppDeviceDao;
import com.jiewen.spp.modules.app.dao.AppVersionDao;
import com.jiewen.spp.modules.app.entity.AppVersion;
import com.jiewen.spp.modules.baseinfo.dao.ClientEntityDao;
import com.jiewen.spp.modules.baseinfo.dao.ManuFacturerDao;
import com.jiewen.spp.modules.baseinfo.entity.ManuFacturer;
import com.jiewen.spp.modules.device.dao.DeviceDao;
import com.jiewen.spp.modules.device.dao.ProductDao;
import com.jiewen.spp.modules.device.entity.Device;
import com.jiewen.spp.modules.device.entity.Product;
import com.jiewen.spp.modules.rom.dao.PushRecDao;
import com.jiewen.spp.utils.LocaleMessageSourceUtil;

@Service
public class DeviceService extends CrudService<DeviceDao, Device> {

	@Autowired
	private DeviceMerchantDao deviceMerchantDao;

	@Autowired
	private MerchantDao merchantDao;

	@Autowired
	private StoreDao storeDao;

	@Resource
	private LocaleMessageSourceUtil messageSourceUtil;

	@Autowired
	private DeviceDao deviceDao;

	@Autowired
	private ManuFacturerDao manuFacturerDao;

	@Autowired
	private ClientEntityDao clientEntityDao;

	@Autowired
	private PushRecDao pushRecDao;

	@Autowired
	private AppDeviceDao appDeviceDao;

	@Autowired
	private ProductDao productDao;

	@Autowired
	private AppVersionDao appVersionDao;

	@Transactional(readOnly = false)
	public void deleteById(Device device) {

		Device devic = new Device();
		devic.setId(device.getId());
		devic = deviceDao.get(devic);
		pushRecDao.deletePushRecByDeviceId(devic.getId());

		// 删除发布版本记录
		deviceDao.delete(devic);
		// 清除缓存
		String catchKey = devic.getManufacturerNo() + devic.getDeviceType() + devic.getDeviceSn();
		cacheRemove(catchKey);

		AppVersion appVersion = new AppVersion();
		appVersion.setAppDescription(devic.getDeviceSn());
		List<AppVersion> appVersionList = appVersionDao.findAppVersionByDeviceSn(appVersion);
		// 删除应用版本记录
		appDeviceDao.deleteAppDeviceByDeviceSn(devic.getDeviceSn());

		String appCatchKey = "";
		for (AppVersion appVersio : appVersionList) {

			appCatchKey = "APP" + devic.getManufacturerNo() + devic.getDeviceType() + devic.getDeviceSn()
					+ appVersio.getOrganId() + appVersio.getAppPackage();
			cacheRemove(appCatchKey);
		}

	}

	@Transactional(readOnly = false)
	public void update(Device device) {
		device.preUpdate();
		dao.update(device);
	}

	/**
	 * 未发布设备
	 * 
	 * @param device
	 * @return
	 */
	public PageInfo<Device> findNoRomDeviceList(Device device) {
		PageHelper.startPage(device);
		return new PageInfo<>(deviceDao.findNoRomDeviceList(device));
	}

	public PageInfo<Device> findRomDeviceCount(Device device) {
		PageHelper.startPage(device);
		return new PageInfo<>(deviceDao.findRomDeviceCount(device));
	}

	/**
	 * 查询已经发布设备的列表
	 * 
	 * @param device
	 * @return
	 */
	public PageInfo<Device> findAlreayRomDeviceList(Device device) {
		PageHelper.startPage(device);
		return new PageInfo<>(deviceDao.findAlreayRomDeviceList(device));
	}

	/**
	 * 查询已经发布设备的列表
	 * 
	 * @param device
	 * @return
	 */
	public PageInfo<Device> findDeviceList(Device device) {
		PageHelper.startPage(device);
		return new PageInfo<>(deviceDao.getDeviceList(device));
	}

	@Transactional(readOnly = false)
	public void uploadFile(MultipartFile file) throws Exception {

		// String clientName = null;
		// try {
		// String fileName = file.getOriginalFilename();
		// String[] fileNameBlocks = fileName.split("_");
		// clientName = fileNameBlocks[1];
		// } catch (Exception e) {
		// throw new ServiceException("");
		// }
		//
		// ClientEntity clientEntity =
		// clientEntityDao.findClientByName(clientName);
		// if (clientEntity == null) {
		// String message =
		// messageSourceUtil.getMessage("modules.device.upload.filename.error");
		// throw new ServiceException(message);
		// }
		List<String[]> deviceListAll = ExcelReaderUtil.excelToArrayList(file.getOriginalFilename(),
				file.getInputStream(), 0, null);
		if (deviceListAll != null && !deviceListAll.isEmpty()) {
			String[] devices0 = deviceListAll.get(0);
			String message = null;
			if (!"型号*".equals(devices0[0])) {
				message = messageSourceUtil.getMessage("modules.device.upload.file.error");
				throw new ServiceException(message);
			}
			if (!"版本号".equals(devices0[1])) {
				message = messageSourceUtil.getMessage("modules.device.upload.file.error");
				throw new ServiceException(message);
			}
			if (!"P/N".equals(devices0[2])) {
				message = messageSourceUtil.getMessage("modules.device.upload.file.error");
				throw new ServiceException(message);
			}
			if (!"S/N*".equals(devices0[3])) {
				message = messageSourceUtil.getMessage("modules.device.upload.file.error");
				throw new ServiceException(message);
			}
			if (!"厂商代码*".equals(devices0[4])) {
				message = messageSourceUtil.getMessage("modules.device.upload.file.error");
				throw new ServiceException(message);
			}
			if (!"申请日期".equals(devices0[5])) {
				message = messageSourceUtil.getMessage("modules.device.upload.file.error");
				throw new ServiceException(message);
			}
			if (!"安装日期".equals(devices0[6])) {
				message = messageSourceUtil.getMessage("modules.device.upload.file.error");
				throw new ServiceException(message);
			}
			if (!"安装地址".equals(devices0[7])) {
				message = messageSourceUtil.getMessage("modules.device.upload.file.error");
				throw new ServiceException(message);
			}
			if (!"商户号".equals(devices0[8])) {
				message = messageSourceUtil.getMessage("modules.device.upload.file.error");
				throw new ServiceException(message);
			}
			if (!"门店号".equals(devices0[9])) {
				message = messageSourceUtil.getMessage("modules.device.upload.file.error");
				throw new ServiceException(message);
			}

			Map<String, Map<String, Boolean>> merchantMap = constructionMerchantStoreMap();
			List<Device> deviceList = new ArrayList<>();
			for (int i = 1; i < deviceListAll.size(); i++) {

				String[] devices = deviceListAll.get(i);
				Device device = new Device();

				// 校验设备信息是否有误
				valDevice(i, devices, merchantMap);
				// 设备基本信息
				addBatchDevice(devices, device);
				// device.setClientNo(clientEntity.getCustomerId());
				device.preInsert();
				deviceList.add(device);
			}
			// merchantList持久层批量设备基本添加
			saveDeviceList(deviceList);
		}
	}

	/**
	 * 批量新增设备信息
	 * 
	 * @param deviceList
	 */
	@Transactional(readOnly = false)
	public void saveDeviceList(List<Device> deviceList) {

		List<Device> subDeviceList = null;
		for (int i = 0; i < deviceList.size(); i = i + 1000) {
			if (i + 1000 < deviceList.size()) {

				subDeviceList = deviceList.subList(i, i + 1000);
				deviceDao.insertList(subDeviceList);
			} else {
				subDeviceList = deviceList.subList(i, deviceList.size());
				deviceDao.insertList(subDeviceList);
			}
		}
	}

	/**
	 * 新增设备信息
	 * 
	 * @param deviceList
	 */
	@Transactional(readOnly = false)
	public int saveDevice(Device device) {
		device.preInsert(true);
		return dao.insert(device);
	}

	/**
	 * 通过id查设备
	 * 
	 * @param device
	 */
	@Transactional(readOnly = false)
	public Device findDeviceById(Device device) {
		return deviceDao.findDeviceById(device);
	}

	/**
	 * 校验设备信息添加是否有误
	 * 
	 * @param rowNum
	 * @param devices
	 */
	private void valDevice(int rowNum, String[] devices, Map<String, Map<String, Boolean>> merchantMap) {
		String howMany = messageSourceUtil.getMessage("modules.device.how.many");
		String line = messageSourceUtil.getMessage("modules.device.line");
		String snNotEmpty = messageSourceUtil.getMessage("modules.device.sn.not.empty");
		String snAlreadyExist = messageSourceUtil.getMessage("modules.device.sn.already.exist");
		String typeNotEmpty = messageSourceUtil.getMessage("modules.device.type.not.empty");
		String verdorNoNotEmpty = messageSourceUtil.getMessage("modules.device.vendor.no.not.empty");
		String vendorNoNotExist = messageSourceUtil.getMessage("modules.device.vendor.no.not.exist");
		String errorMerId = messageSourceUtil.getMessage("modules.device.error.merid");
		String errorStoreId = messageSourceUtil.getMessage("modules.device.error.storeid");
		String errorApplyDate = messageSourceUtil.getMessage("modules.device.error.applydate");
		String errorInstallDate = messageSourceUtil.getMessage("modules.device.error.installdate");
		if (devices != null) {

			/* 注释的代码先没有必要验证 */

			String deviceType = devices[0];
			String deviceSn = devices[3];
			String manufacturerNo = devices[4];

			if (StringUtil.isEmpty(deviceSn)) {
				throw new ServiceException(howMany + (rowNum + 1) + line + snNotEmpty);
			} else {
				Device device = new Device();
				device.setDeviceSn(deviceSn);
				Device deviceGet = deviceDao.findDeviceByDeviceSn(device);
				if (deviceGet != null) {
					throw new ServiceException(howMany + (rowNum + 1) + line + deviceSn + snAlreadyExist);
				}
			}
			if (StringUtil.isEmpty(deviceType)) {
				throw new ServiceException(howMany + (rowNum + 1) + line + typeNotEmpty);
			}

			if (StringUtil.isEmpty(manufacturerNo)) {
				throw new ServiceException(howMany + (rowNum + 1) + line + verdorNoNotEmpty);
			} else {
				ManuFacturer manuFacturer = manuFacturerDao.findManuFacturerByNo(manufacturerNo);
				if (manuFacturer == null) {
					throw new ServiceException(howMany + (rowNum + 1) + line + vendorNoNotExist);
				}
			}

			String applyDateStr = devices[5];
			String installDateStr = devices[6];
			if (applyDateStr != null && !("".equals(applyDateStr))) {
				if (!applyDateStr
						.matches("^(20[01]\\d|1\\d{3}|[1-9]\\d\\d?|\\d)\\/([1-9]|1[0-2])\\/(3[01]|[1-2]\\d|\\d)$")) {
					throw new ServiceException(howMany + (rowNum + 1) + line + errorApplyDate);
				}
			}
			if (installDateStr != null && !("".equals(installDateStr))) {
				if (!installDateStr
						.matches("^(20[01]\\d|1\\d{3}|[1-9]\\d\\d?|\\d)\\/([1-9]|1[0-2])\\/(3[01]|[1-2]\\d|\\d)$")) {
					throw new ServiceException(howMany + (rowNum + 1) + line + errorInstallDate);
				}
			}

			String installLocation = devices[7];
			String merId = devices[8];
			String storeId = devices[9];
			// 验证商户是否存在
			if (merId == null || "".equals(merId)) {
				if (storeId != null && !("".equals(storeId))) {
					throw new ServiceException(howMany + (rowNum + 1) + line + errorStoreId);
				}
			} else {
				if (merchantMap.get(merId) == null) {
					throw new ServiceException(howMany + (rowNum + 1) + line + errorMerId);
				} else {
					if (storeId != null && !("".equals(storeId))) {
						if (merchantMap.get(merId).get(storeId) == null) {
							throw new ServiceException(howMany + (rowNum + 1) + line + errorStoreId);
						}
					}
				}
			}

		}
	}

	/**
	 * 批量添加设备基本信息
	 * 
	 * @param devices
	 * @param device
	 */
	public void addBatchDevice(String[] devices, Device device) {

		if (devices != null) {
			String deviceTypeStr = devices[0];
			String reg = "[\u4e00-\u9fa5]";
			Pattern pat = Pattern.compile(reg);
			Matcher mat = pat.matcher(deviceTypeStr);
			String deviceType = mat.replaceAll("");
			deviceType = deviceType.replaceAll("\\(", "");
			deviceType = deviceType.replaceAll("\\)", "");
			deviceType = deviceType.replaceAll("\\（", "");
			deviceType = deviceType.replaceAll("\\）", "");

			String deviceVersion = devices[1];
			String devicePn = devices[2];
			String deviceSn = devices[3];
			String manufacturerNo = devices[4];
			String applyDateStr = devices[5];
			String installDateStr = devices[6];

			if (applyDateStr != null && !("".equals(applyDateStr))) {
				String[] params = applyDateStr.split("/");
				Calendar calendar = Calendar.getInstance();
				calendar.set(Integer.parseInt(params[0]), Integer.parseInt(params[1]), Integer.parseInt(params[2]));
				calendar.set(Integer.parseInt(params[0]), Integer.parseInt(params[1]), Integer.parseInt(params[2]));
				Date applyDate = calendar.getTime();
				device.setApplyDate(applyDate);
			}
			if (installDateStr != null && !("".equals(installDateStr))) {
				String[] params = installDateStr.split("/");
				Calendar calendar = Calendar.getInstance();
				calendar.set(Integer.parseInt(params[0]), Integer.parseInt(params[1]), Integer.parseInt(params[2]));
				Date installDate = calendar.getTime();
				device.setInstallDate(installDate);
			}
			String installLocation = devices[7];
			String merId = devices[8];
			String shopId = devices[9];
			// 设备基本信息添加
			if (deviceType.trim().contains("A90-1")) {
				device.setDeviceType("A90");
			} else {
				device.setDeviceType(deviceType.trim());
			}
			device.setDeviceVersion(deviceVersion);
			device.setDevicePn(devicePn);
			device.setDeviceSn(deviceSn);
			device.setManufacturerNo(manufacturerNo);
			device.setInstallLocation(installLocation);

			device.setMerId(merId);
			device.setShopId(shopId);
			User currentUser = UserUtils.getUser();
			device.setOrganId(currentUser.getOfficeId());
		}
	}

	public Device findDeviceByDeviceSn(Device device) {
		return deviceDao.findDeviceByDeviceSn(device);
	}

	public PageInfo<Device> findNoAppDeviceList(Device device) {
		PageHelper.startPage(device);
		return new PageInfo<>(deviceDao.findNoAppDeviceListByTypesManus(device));
	}

	public PageInfo<Device> findAlreayAppDeviceList(Device device) {
		PageHelper.startPage(device);
		return new PageInfo<>(deviceDao.findAlreayAppDeviceList(device));
	}

	public PageInfo<Device> getAppRecordDeviceList(Device device) {
		PageHelper.startPage(device);
		List<Device> list = deviceDao.getAppRecordDeviceList(device);
		for (Device deviceRecord : list) {
			if (deviceRecord.getAppInfo() != null) {
				JSONArray appInfoArray = null;
				appInfoArray = JSONArray.parseArray(String.valueOf(deviceRecord.getAppInfo()));
				Iterator<Object> it = appInfoArray.iterator();
				while (it.hasNext()) {
					JSONObject ob = (JSONObject) it.next();
					if (ob.getString(JSONConstant.AppInfo.APP_PACKAGE).equals(deviceRecord.getAppPackage())) {
						String currentAppVersion = ob.getString(JSONConstant.AppInfo.APP_VERSION);
						deviceRecord.setCurrentAppVersion(currentAppVersion);
						String currentAppVersionShifter = com.jiewen.utils.StringUtil.formatVersion(currentAppVersion);
						String appVersionShifter = com.jiewen.utils.StringUtil
								.formatVersion(deviceRecord.getAppVersion());
						int version_compare_value = StringUtils.compare(currentAppVersionShifter, appVersionShifter);
						deviceRecord.setVersionCompareValue(String.valueOf(version_compare_value));
					} else {
						if (deviceRecord.getUpgradeType().equals("1")) {
							deviceRecord.setVersionCompareValue("0");
						}
					}
				}
			}
		}
		return new PageInfo<>(list);
	}

	/**
	 * 通过id查设备
	 * 
	 * @param device
	 */
	@Transactional(readOnly = false)
	public Device findDeviceInfoById(Device device) {
		return deviceDao.findDeviceInfoById(device);
	}

	/**
	 * 根据id批量导入设备
	 * 
	 * @param ids
	 */
	@Transactional(readOnly = false)
	public void importDevice(String ids) {

		List<String> idList = new ArrayList<>();
		String[] idArray = StringUtils.split(ids, ',');
		for (String id : idArray) {
			idList.add(id);
		}
		List<Product> products = productDao.findProductListByIds(idList);
		convertDeviceList(products);
	}

	/**
	 * 根据查询条件批量导入设备
	 * 
	 * @param product
	 */
	@Transactional(readOnly = false)
	public void importAllDevice(Product product) {

		List<Product> products = productDao.findNoImportDeviceList(product);
		convertDeviceList(products);
	}

	private void convertDeviceList(List<Product> products) {
		List<Device> devices = new ArrayList<>();
		for (Product product : products) {
			Device device = new Device();
			device.setDeviceSn(product.getSn());
			device.setDevicePn(product.getPn());
			device.setDeviceType("A90");
			device.setManufacturerNo(product.getVendorCode());
			device.setClientNo(product.getCustomerId());
			device.setDeviceVersion(product.getVersion());
			device.setTusn(product.getUnionPayTermId());
			device.preInsert();
			devices.add(device);
		}
		// 批量保存
		saveDeviceList(devices);
	}

	/**
	 * 获得指定日期的后一天
	 * 
	 * @param specifiedDay
	 * @return
	 */
	private String getSpecifiedDayAfter(String specifiedDay, int days) {

		Calendar c = Calendar.getInstance();
		Date date = null;
		try {
			date = new SimpleDateFormat("yyyy-MM-dd").parse(specifiedDay);
		} catch (ParseException e) {
		}
		c.setTime(date);
		int day = c.get(Calendar.DATE);
		c.set(Calendar.DATE, day + days);
		String dayAfter = new SimpleDateFormat("yyyy-MM-dd").format(c.getTime());
		return dayAfter;
	}

	/**
	 * 获取设备总数量 及最近 一天、一周、一月内活跃数量
	 * 
	 * @param type
	 * @return
	 */
	@Transactional(readOnly = false)
	public Integer getDeviceCount(String type) {
		Device device = new Device();
		String endDate = getSpecifiedDayAfter(DateUtils.getDate(), 1);
		User user = UserUtils.getUser();
		if(user != null){
			device.setOrganId(user.getOfficeId());
		}
		String startDate = "";
		if ("day".equals(type)) {
			startDate = getSpecifiedDayAfter(endDate, -1);
		} else if ("week".equals(type)) {
			startDate = getSpecifiedDayAfter(endDate, -7);
		} else if ("month".equals(type)) {
			startDate = getSpecifiedDayAfter(endDate, -30);
		} else {
			return deviceDao.getDeviceCount(device);
		}
		device.setBeginDateStr(startDate);
		device.setEndDateStr(endDate);
		return deviceDao.getDeviceCount(device);
	}

	/**
	 * 获取客户设备总数量 及最近 一天、一周、一月内活跃数量
	 * 
	 * @param type
	 * @return
	 */
	@Transactional(readOnly = false)
	public Integer getCustomerDeviceCount(String type) {
		Device device = new Device();
		User currentUser = UserUtils.getUser();
		device.setClientNo(currentUser.getOfficeId());
		String endDate = getSpecifiedDayAfter(DateUtils.getDate(), 1);
		String startDate = "";
		if ("day".equals(type)) {
			startDate = getSpecifiedDayAfter(endDate, -1);
		} else if ("week".equals(type)) {
			startDate = getSpecifiedDayAfter(endDate, -7);
		} else if ("month".equals(type)) {
			startDate = getSpecifiedDayAfter(endDate, -30);
		} else {
			return deviceDao.getCustomerDeviceCount(device);
		}
		device.setBeginDateStr(startDate);
		device.setEndDateStr(endDate);
		return deviceDao.getCustomerDeviceCount(device);
	}

	public List<Device> getOrgDevices(Device device) {
		return deviceDao.getOrgDevices(device);
	}

	public PageInfo<Device> findDevicePage(Device device) {
		PageHelper.startPage(device);
		List<Device> selectMerchantList = deviceDao.getOrgDevices(device);
		return new PageInfo<>(selectMerchantList);
	}

	private Map<String, Map<String, Boolean>> constructionMerchantStoreMap() {
		Merchant merchant = new Merchant();
		User user = UserUtils.getUser();
		merchant.setOrgId(user.getOfficeId());
		// List<Merchant> merchantList=merchantDao.selectMerchantList(merchant);
		List<Merchant> merchantList = merchantDao.getAllMerchantWithStores(user.getOfficeId());
		if (merchantList == null || merchantList.isEmpty()) {
			throw new ServiceException("该用户所属机构下无商户信息");
		}
		HashMap<String, Map<String, Boolean>> merchantMap = new HashMap<String, Map<String, Boolean>>();
		Map<String, Boolean> storeMap;
		List<Store> stores;
		for (int i = 0; i < merchantList.size(); i++) {
			merchant = merchantList.get(i);
			if (merchant == null) {
				// merchantMap.put(merchant.getMerId(), null);
			} else if (merchant.getStores().isEmpty()) {
				merchantMap.put(merchant.getMerId(), new HashMap<String, Boolean>());
			} else {
				storeMap = new HashMap<String, Boolean>();
				stores = merchant.getStores();
				for (int j = 0; j < stores.size(); j++) {
					storeMap.put(stores.get(j).getStoreId(), true);
				}
				merchantMap.put(merchant.getMerId(), storeMap);
			}
			// merchantMap.put(merchantList.get(i).getMerId(),
			// merchantList.get(i));
		}
		return merchantMap;
	}
}
