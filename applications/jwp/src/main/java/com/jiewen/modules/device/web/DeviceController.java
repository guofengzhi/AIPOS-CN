package com.jiewen.modules.device.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import cn.jpush.api.push.PushResult;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageInfo;
import com.jiewen.base.core.web.Result;
import com.jiewen.base.core.web.ResultGenerator;
import com.jiewen.commons.ServerException;
import com.jiewen.commons.util.IOUtil;
import com.jiewen.commons.util.StringUtil;
import com.jiewen.constant.ControlCommand;
import com.jiewen.jwp.base.constant.Constant;
import com.jiewen.jwp.base.constant.DictConstant;
import com.jiewen.jwp.base.constant.JSONConstant;
import com.jiewen.jwp.base.utils.CacheUtils;
import com.jiewen.jwp.base.utils.RemotePushUtils;
import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.base.web.ParamResult;
import com.jiewen.jwp.common.DateUtils;
import com.jiewen.jwp.common.StringUtils;
import com.jiewen.jwp.common.annotation.RefreshCSRFToken;
import com.jiewen.modules.app.entity.AppDeviceType;
import com.jiewen.modules.app.entity.AppInfo;
import com.jiewen.modules.app.service.AppDeviceTypeService;
import com.jiewen.modules.app.service.AppInfoService;
import com.jiewen.modules.baseinfo.entity.DeviceType;
import com.jiewen.modules.baseinfo.entity.ManuFacturer;
import com.jiewen.modules.baseinfo.service.DeviceTypeService;
import com.jiewen.modules.baseinfo.service.ManuFacturerService;
import com.jiewen.modules.device.entity.Device;
import com.jiewen.modules.device.entity.DeviceInfo;
import com.jiewen.modules.device.entity.FileInfo;
import com.jiewen.modules.device.entity.Location;
import com.jiewen.modules.device.entity.LogFile;
import com.jiewen.modules.device.entity.Product;
import com.jiewen.modules.device.entity.RecordInfo;
import com.jiewen.modules.device.service.DeviceService;
import com.jiewen.modules.device.service.LogFileService;
import com.jiewen.modules.device.service.RecordInfoService;
import com.jiewen.modules.entity.Merchant;
import com.jiewen.modules.entity.Store;
import com.jiewen.modules.rom.entity.OsRomInfo;
import com.jiewen.modules.rom.entity.PushRec;
import com.jiewen.modules.rom.service.OsRomInfoService;
import com.jiewen.modules.rom.service.PushRecService;
import com.jiewen.modules.sys.entity.Dict;
import com.jiewen.modules.sys.entity.User;
import com.jiewen.modules.sys.service.SystemService;
import com.jiewen.modules.sys.utils.DictUtils;
import com.jiewen.modules.sys.utils.UserUtils;

import edu.emory.mathcs.backport.java.util.Arrays;

@Controller
@RequestMapping("${adminPath}/device")
public class DeviceController extends BaseController {

	private static final String DEVICE_TYPE_LIST = "deviceTypeList";

	private static final String MANU_FACT_LIST = "manuFacturerList";

	private static final String INDUSTRY_LIST = "industryList";

	private static final String CLIENT_ID_LIST = "clientIdentifyList";

	private static final String DEVICE = "device";

	private static final String DEVICE_INFO = "deviceInfo";
	
	private static final String DEVICE_LOCATION = "deviceLocation";

	private static final String DICT_LIST = "dictList";

	private static final String INDUSTRY_CODE = "40010";
	
	private static final String MERCHANTS = "merchants";
	
	private static final String STORES = "stores";
	
	private static final String LOCATION = "location";

	@Value("${log.download.path}")
	private String dowloadLogPath;

	@Autowired
	private OsRomInfoService osRomInfoService;

	@Autowired
	private DeviceService deviceService;

	@Autowired
	private ManuFacturerService manuFacturerService;

	@Autowired
	private DeviceTypeService deviceTypeService;

	@Autowired
	private AppDeviceTypeService appDeviceTypeService;

	@Autowired
	private AppInfoService appInfoService;

	@Autowired
	private LogFileService logFileService;
	
	@Autowired
	private SystemService systemService;

	@Autowired
	private RecordInfoService recordInfoService;

	@Autowired
	private PushRecService pushRecService;
	
	@ModelAttribute
	public Device get(String id, Model model) {
		Device device = new Device();
		if (StringUtils.isNotBlank(id)) {
			device.setId(id);
			device = deviceService.get(device);
		}
		return device;
	}

	private List<DeviceType> getDevTypeList() {
		return deviceTypeService.getDeviceTypeList();
	}

	private List<ManuFacturer> getManuFacturerList() {
		return manuFacturerService.findList();
	}

	private List<Dict> getClientIdeList() {
		return DictUtils.getDictList("client_identify");
	}
	
	 /**
		 * 新增修改
		 * 
		 * @param option
		 * @param manuFacturer
		 * @param model
		 * @return
		 */
	    @RequiresPermissions("device:edit")
		@RequestMapping(value = "DeviceEditOrAdd")
		@ResponseBody
		public Device DeviceEditOrAddform(String id, Model model) {
    	Device device = new Device();
			if (org.apache.commons.lang3.StringUtils.isNotBlank(id)) {
				device.setId(id);
				device =  deviceService.findDeviceById(device);
			}
			Store store=new Store();
			if(device.getMerId() != null) {
				store.setMerId(device.getMerId());
				device.setListStore(systemService.findStoreList(store));
			}
			if( device.getLocation() != null) {
				JSONObject parse = (JSONObject) JSONObject.parse((String) device.getLocation());
				String longitude = parse.getString("longitude");
				String latitude = parse.getString("latitude");
				model.addAttribute("deviceLo", longitude);
				model.addAttribute("deviceLa", latitude);
			}
			return device;
		}
	    

	@RequestMapping(value = "index")
	public String index(Model model,HttpServletRequest request) {
		User user = UserUtils.getUser();
		Merchant mer=new Merchant();
		mer.setOrgId(user.getOfficeId());
		model.addAttribute(MERCHANTS,systemService.getMerchants(mer));
		model.addAttribute(DEVICE, new Device());
		model.addAttribute(STORES, "");
		model.addAttribute(DEVICE_TYPE_LIST, getDevTypeList());
		model.addAttribute(MANU_FACT_LIST, getManuFacturerList());
		model.addAttribute(CLIENT_ID_LIST, getClientIdeList());
		List<Dict> industryList = DictUtils.getDictList(INDUSTRY_CODE);
		model.addAttribute(INDUSTRY_LIST, industryList);
		String mId = request.getParameter("mId");
		model.addAttribute("mId", mId);
		return "modules/device/deviceList";
	}

	@RequestMapping(value = "recordIndex")
	public String recordIndex(Model model) {
		model.addAttribute(DEVICE_TYPE_LIST, getDevTypeList());
		model.addAttribute(MANU_FACT_LIST, getManuFacturerList());
		return "modules/device/recordDeviceList";
	}

	@RequestMapping(value = "romDeviceCountIndex")
	public String romDeviceCountIndex(Model model) {
		model.addAttribute(CLIENT_ID_LIST, getClientIdeList());
		return "modules/device/romDeviceCountList";
	}

	/**
	 * 获取版本对应的设备数量
	 * 
	 * @param reqObj
	 * @return
	 */
	@RequestMapping(value = { "romDeviceCount", "" })
	@ResponseBody
	public Map<String, Object> romDeviceCount(String reqObj) {
		Device device = new ParamResult<Device>(reqObj).getEntity(Device.class);
		PageInfo<Device> pageInfo = deviceService.findRomDeviceCount(device);
		return resultMap(device, pageInfo);
	}

    /**
     * 正常列表
     * 
     * @param deviceType
     * @param reqObj
     * @return
     * @throws Exception
     */
    @RequiresPermissions("device:view")
    @RequestMapping(value = { "list", "" })
    @ResponseBody
    public Map<String, Object> list(String reqObj,HttpServletRequest request) {
    	String mId = request.getParameter("mId");
        Device device = new ParamResult<Device>(reqObj).getEntity(Device.class);
        User user = UserUtils.getUser();
        device.setOrganId(user.getOfficeId());
        device.setmId(mId);
        PageInfo<Device> pageInfo = deviceService.findPage(device);
        return resultMap(device, pageInfo);
    }


	/**
	 * 未发布rom的设备
	 * 
	 * @param deviceType
	 * @param reqObj
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = { "noPublishlist", "" })
	@ResponseBody
	public Map<String, Object> noPublishlist(String romId, String industry, String reqObj) {
		Device device = new ParamResult<Device>(reqObj).getEntity(Device.class);
		String cacheKey = Constant.DEVICE_SN_ROM + UserUtils.getUser().getId();
		Object deviceSnObj = CacheUtils.get(cacheKey);
		// 1: 按文件SN查找设备 2: 全部设备
		if (deviceSnObj != null) {
			device.setDeviceSnStr(deviceSnObj.toString());
		}
		OsRomInfo osRomInfo = osRomInfoService.get(romId);
		device.setDeviceType(osRomInfo.getOsDeviceType());
		device.setStartHard(osRomInfo.getStartHardShift());
		device.setEndHard(osRomInfo.getEndHardShift());
		device.setId(romId);
		device.setIndustry(industry);
		device.setOrganId(osRomInfo.getClientIdentification());
		PageInfo<Device> pageInfo = deviceService.findNoRomDeviceList(device);
		return resultMap(device, pageInfo);
	}

	/**
	 * 已发布rom的设备
	 * 
	 * @param deviceType
	 * @param reqObj
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = { "alreayPublishlist", "" })
	@ResponseBody
	public Map<String, Object> alreayPublishlist(String id, String reqObj) {
		Device device = new ParamResult<Device>(reqObj).getEntity(Device.class);
		OsRomInfo osRomInfo = osRomInfoService.get(id);
		device.setStartHard(osRomInfo.getStartHardShift());
		device.setEndHard(osRomInfo.getEndHardShift());
		device.setDeviceType(osRomInfo.getOsDeviceType());
		device.setId(id);
		PageInfo<Device> pageInfo = deviceService.findAlreayRomDeviceList(device);
		return resultMap(device, pageInfo);
	}

	/**
	 * 未发布app的设备
	 * 
	 * @param deviceType
	 * @param reqObj
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = { "noPublishAppDeviceList", "" })
	@ResponseBody
	public Map<String, Object> noPublishAppDeviceList(String reqObj) {

		Device device = new ParamResult<Device>(reqObj).getEntity(Device.class);
		String cacheKey = Constant.DEVICE_SN_APP + UserUtils.getUser().getId();
		Object deviceSnObj = CacheUtils.get(cacheKey);
		if (deviceSnObj != null) {
			device.setDeviceSnStr(deviceSnObj.toString());
		}
		PageInfo<Device> pageInfo = deviceService.findPage(device);
		return resultMap(device, pageInfo);

	}

	/**
	 * 已发布app的设备
	 * 
	 * @param deviceType
	 * @param reqObj
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = { "alreayPublishAppDeviceList", "" })
	@ResponseBody
	public Map<String, Object> alreayPublishAppDeviceList(String appId, String clientIdentification, String reqObj) {
		Device device = new ParamResult<Device>(reqObj).getEntity(Device.class);
		List<AppDeviceType> appDeviceTypeList = appDeviceTypeService.getAppDeviceTypeByApkId(appId);
		device.setId(appId);
		device.setOrganId(clientIdentification);
		device.setAppDeviceTypeList(appDeviceTypeList);
		PageInfo<Device> pageInfo = deviceService.findAlreayAppDeviceList(device);
		return resultMap(device, pageInfo);
	}

	/**
	 * @param deviceType
	 * @param reqObj
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = { "getDeviceList", "" })
	@ResponseBody
	public Map<String, Object> getDeviceList(String id, String reqObj) {
		Device device = new ParamResult<Device>(reqObj).getEntity(Device.class);
		device.setId(id);
		PageInfo<Device> pageInfo = deviceService.findDeviceList(device);
		return resultMap(device, pageInfo);
	}

	/**
	 * @param deviceType
	 * @param reqObj
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = { "getAppRecordDeviceList", "" })
	@ResponseBody
	public Map<String, Object> getAppRecordDeviceList(String id, String reqObj) {
		Device device = new ParamResult<Device>(reqObj).getEntity(Device.class);
		device.setId(id);
		PageInfo<Device> pageInfo = deviceService.getAppRecordDeviceList(device);
		return resultMap(device, pageInfo);
	}

	@RefreshCSRFToken
	@RequestMapping(value = "form")
	public String form(Model model, Device device) {
		model.addAttribute(DEVICE_TYPE_LIST, getDevTypeList());
		model.addAttribute(MANU_FACT_LIST, getManuFacturerList());
		model.addAttribute(CLIENT_ID_LIST, getClientIdeList());
		List<Dict> industryList = DictUtils.getDictList(INDUSTRY_CODE);
		model.addAttribute(INDUSTRY_LIST, industryList);
		String location = (String) device.getLocation();
		if(StringUtils.isNotEmpty(location)){
			JSONObject parse = (JSONObject) JSONObject.parse(location);
			String longitude = parse.getString("longitude");
			String latitude = parse.getString("latitude");
			model.addAttribute("deviceLo", longitude);
			model.addAttribute("deviceLa", latitude);
		}
		
		if(device.getId() != null) {
			device=deviceService.get(device);
		}else {
			device = new Device();
		}
		//获取当前用户所属机构下的商户列表
		User user = UserUtils.getUser();
		Merchant mer=new Merchant();
		mer.setOrgId(user.getOfficeId());
		model.addAttribute(DEVICE, device);
		model.addAttribute(MERCHANTS,systemService.getMerchants(mer));
		//获取该商户下所有门店列表
		Store store=new Store();
		if(device.getMerId() != null) {
			store.setMerId(device.getMerId());
			model.addAttribute(STORES,systemService.findStoreList(store));
		}
		if(StringUtils.isNotEmpty(mapType)){
			if(StringUtils.equals(mapType, "google")){
				return "modules/device/deviceFormEn";
			}
		}
		return "modules/device/deviceForm";
	}

	@RequestMapping(value = { "save", "" })
	@ResponseBody
	public Result save(Device device) {
		String snAlreadyExist = messageSourceUtil.getMessage("modules.device.sn.already.exist");
		String saveSuccess = messageSourceUtil.getMessage("common.saveSuccess");
		String updateSuccess = messageSourceUtil.getMessage("common.updateSuccess");
		if (device.getId() == null) {
			Device deviceGet = deviceService.findDeviceByDeviceSn(device);
			if (deviceGet != null) {
				return ResultGenerator.genFailResult(snAlreadyExist);
			}
			if(device.getOrganId() == null) {
				device.setOrganId(device.getCurrentUser().getOfficeId());
			}
			String locationString = device.getLocationString();
			if(StringUtils.isNotEmpty(locationString)){
				locationString=locationString.replaceAll("'", "\"");
				device.setLocation(locationString);
			}
			deviceService.saveDevice(device);
			return ResultGenerator.genSuccessResult(saveSuccess);
		}
		deviceService.update(device);
		return ResultGenerator.genSuccessResult(updateSuccess);
	}

	@RequestMapping(value = { "delete", "" })
	@ResponseBody
	public Result delete(Device device) {
		String deleteFail = messageSourceUtil.getMessage("common.deleteFail");
		String deleteSuccess = messageSourceUtil.getMessage("common.deleteSuccess");
		try {
			deviceService.deleteById(device);
		} catch (Exception e) {
			return ResultGenerator.genFailResult(deleteFail);
		}
		return ResultGenerator.genSuccessResult(deleteSuccess);
	}

	@RequestMapping("batImportProduct")
	public String batImportProduct(Model model) {

		model.addAttribute(DEVICE_TYPE_LIST, getDevTypeList());
		model.addAttribute(MANU_FACT_LIST, getManuFacturerList());
		List<Dict> industryList = DictUtils.getDictList(INDUSTRY_CODE);
		model.addAttribute(INDUSTRY_LIST, industryList);

		return "modules/device/devBatchImport";
	}

	@RequestMapping("batImportFile")
	public String batImportFile(Model model) {

		return "modules/device/devAddBatch";
	}

	/**
	 * 批量上传设备信息
	 * 
	 * @param file
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("addDeviceInfo")
	public @ResponseBody Result deviceAddBatch(@PathVariable("file") MultipartFile file,
			HttpServletResponse response) {
		String transfinite = messageSourceUtil.getMessage("modules.device.upload.file.transfinite");
		String batchImportSuccess = messageSourceUtil.getMessage("modules.device.batch.import.success");
		if (file.getSize() > 3 * 1024 * 1024) { // 大于1M
			return ResultGenerator.genFailResult(transfinite);
		} else {
			try {
				deviceService.uploadFile(file);
			} catch (Exception e) {
				return ResultGenerator.genFailResult(e.getMessage());
			}
		}
		return ResultGenerator.genSuccessResult(batchImportSuccess);
	}

	@RequestMapping(value = "download")
	public void importFileTemplate(HttpServletResponse response, String type) {

		String downloadFileError = messageSourceUtil.getMessage("modules.device.download.file.error");
		String fileName = "";
		if (StringUtils.equalsIgnoreCase("releaseType", type)) {
			fileName = "device_sn_template.xlsx";
		} else if (StringUtils.equalsIgnoreCase(DEVICE, type)) {
			fileName = "device_template.xlsx";
		}
		InputStream is = null;
		ServletOutputStream os = null;
		try {
			is = new ClassPathResource("moudle/templateFile/device/" + fileName).getInputStream();
			response.setCharacterEncoding(Constant.CHARACTER_ENCODING_UTF8);
			response.setContentType(Constant.CONTENT_TYPE_VND_EXCEL);
			response.setHeader(Constant.HEADER_CONTENT_DISPOSITION, "attachment; filename=" + fileName);
			os = response.getOutputStream();
			byte[] buffer = new byte[4 * 1024];
			int read;
			while ((read = is.read(buffer)) > 0) {
				os.write(buffer, 0, read);
				os.flush();
			}

		} catch (Exception e) {
			logger.error(downloadFileError);
		} finally {
			IOUtil.closeQuietly(is);
			IOUtil.closeQuietly(os);

		}
	}

	/**
	 * 设备信息
	 * 
	 * @author Pang.M
	 */
	@RequestMapping(value = "deviceInfo")
	public String checkDeviceInfo(Model model, Device device) {
		List<DeviceType> deviceTypeList = deviceTypeService.getDeviceTypeList();
		model.addAttribute(DEVICE_TYPE_LIST, deviceTypeList);
		List<ManuFacturer> manuFacturerList = manuFacturerService.findList();
		model.addAttribute(MANU_FACT_LIST, manuFacturerList);
		device=deviceService.get(device);
		model.addAttribute(DEVICE, device);

		DeviceInfo deviceInfo = new DeviceInfo();
		if (device.getDeviceInfo() != null) {
			deviceInfo = JSON.parseObject(device.getDeviceInfo().toString(), DeviceInfo.class);
		}
		model.addAttribute(DEVICE_INFO, deviceInfo);
		
		Location location=null;
		if(device.getLocation() != null) {
			location = JSON.parseObject(device.getLocation().toString(),Location.class);
		}
		
		model.addAttribute(LOCATION,location);

		// 设备硬件状状态
		List<Dict> dictList = DictUtils.getDictList(DictConstant.DEVICE_STATUS);
		//设备网络状态
		List<Dict> dictList2 = DictUtils.getDictList(DictConstant.DEVICE_INTERNET_STATUS);
		List<Dict> deviceInfoStatus=DictUtils.getDictList(DictConstant.DEVICE_INFO_STATUS);
		model.addAttribute(DICT_LIST, dictList);
		model.addAttribute("dictList2",dictList2);
		model.addAttribute("statusList",deviceInfoStatus);
		if(StringUtils.isNotEmpty(mapType)){
			if(StringUtils.equals(mapType, "google")){
				return "modules/device/deviceInfoEn";
			}
		}
		return "modules/device/deviceInfo";
	}

	/**
	 * 获取日志文件列表
	 * 
	 * @author Pang.M
	 * 
	 */
	@RequestMapping(value = "getLogFileList/{deviceSn}")
	public @ResponseBody Map<String, Object> getLogFileList(String reqObj, @PathVariable("deviceSn") String deviceSn) {
		LogFile logFile = new ParamResult<LogFile>(reqObj).getEntity(LogFile.class);
		logFile.setSn(deviceSn);
		PageInfo<LogFile> pageInfo = logFileService.findPage(logFile);
		return resultMap(logFile, pageInfo);
	}

	/**
	 * 设备应用列表
	 * 
	 * @author Pang.M
	 */
	@RequestMapping(value = "checkDeviceAppList")
	public @ResponseBody Result checkDeviceAppList(String deviceId) {
		Device device = new Device();
		if (!StringUtils.isBlank(deviceId)) {
			device.setId(deviceId);
			device = deviceService.findDeviceById(device);
		}
		List<AppInfo> appInfoList = new ArrayList<>();
		if (device.getAppInfo() != null) {
			appInfoList = appInfoService.findAppInfoListConverDevolper(device.getAppInfo().toString(),
					device.getOrganId());
		}
		return ResultGenerator.genSuccessResult(appInfoList);
	}

	/**
	 * 激光推送，获取日志
	 * 
	 * @author Pang.M 2017年11月15日
	 */
	@RequestMapping(value = "checkLog")
	@ResponseBody
	public Result checkLog(@RequestParam String check, String deviceSn) {
		String notOnline = messageSourceUtil.getMessage("modules.device.not.online");
		String requestSuccess = messageSourceUtil.getMessage("modules.device.request.success");
		String requestFail = messageSourceUtil.getMessage("modules.device.request.fail");

		// 先记录推送信息
		PushRec pushRec = this.recordPushRec(deviceSn, "文件上传");

		List<String> alias = new ArrayList<>();
		alias.add(deviceSn);

		String jsonStr = StringEscapeUtils.unescapeHtml4(check);
		JSONObject jsonObject = JSONObject.parseObject(jsonStr);

		JSONObject message = new JSONObject();
		message.put(JSONConstant.JPush.OPTION, ControlCommand.Option.OPTION_L);
		message.put(JSONConstant.JPush.APP_PATH, jsonObject.getString(JSONConstant.ZtreeNode.TREE_NAME));
		message.put(JSONConstant.JPush.TRANS_ID, pushRec.getId());
		if (StringUtils.isNotEmpty(jsonObject.getString(JSONConstant.ZtreeNode.TREE_TARGET))) {
			if (jsonObject.getString(JSONConstant.ZtreeNode.TREE_TARGET).equals("1")) {
				// 如果为APP包，只上送包名
				message.put(JSONConstant.JPush.APP_PACKAGE, jsonObject.getString(JSONConstant.ZtreeNode.TREE_NAME));
				message.remove(JSONConstant.JPush.APP_PATH);
			} else {
				RecordInfo recordInfo = recordInfoService
						.findById(jsonObject.getString(JSONConstant.ZtreeNode.TREE_TARGET));
				message.put(JSONConstant.JPush.APP_PACKAGE, recordInfo.getPackageName());
			}
		}

		try {
			// 设备序列号列表、执行动作、消息内容（APP包名）
			PushResult result = RemotePushUtils.push(alias, ControlCommand.REMOTE_ACCESS_LOG, message.toJSONString());
			if (result == null) {
				return ResultGenerator.genFailResult(notOnline);
			}
		} catch (Exception e) {
			logger.info(e.getMessage(), e);
			return ResultGenerator.genFailResult(requestFail);
		}
		return ResultGenerator.genSuccessResult(requestSuccess);
	}

	/**
	 * 记录推送信息
	 */
	private PushRec recordPushRec(String deviceSn, String message) {
		Device device = new Device();
		device.setDeviceSn(deviceSn);
		device = deviceService.findDeviceByDeviceSn(device);
		PushRec pushRec = new PushRec();
		pushRec.setOsId(device.getDeviceOsVersion());
		pushRec.setMessageContent(message);
		pushRec.setDeviceId(device.getId());
		pushRec.setCreateBy(UserUtils.getUser());
		pushRec.setCreateDate(new Date());
		pushRec.setUpdateBy(UserUtils.getUser());
		pushRec.setUpdateDate(new Date());
		pushRec.setDelFlag(Constant.CONSTANT_SATUS_ZERO);
		pushRecService.insert(pushRec);

		return pushRec;
	}

	/**
	 * 获取app目录
	 * 
	 * @author Pang.M 2017年11月15日
	 */
	@RequestMapping(value = "getAppDirectory")
	public String getAppDirectory(Model model, String id) {
		Device device = new Device();
		if (StringUtils.isNotEmpty(id)) {
			device.setId(id);
			device = deviceService.findDeviceById(device);
		}
		model.addAttribute(device);
		return "modules/device/deviceLogList";
	}

	/**
	 * 创建设备应用菜单树
	 * 
	 * @author Pang.M 2017年11月15日
	 */
	@RequestMapping(value = "createDeviceAppTree")
	@ResponseBody
	public String createDeviceAppTree(@RequestParam String deviceId) {
		Device device = new Device();
		if (!StringUtils.isBlank(deviceId)) {
			device.setId(deviceId);
			device = deviceService.findDeviceById(device);
		}
		return recordInfoService.getDeviceAppTreeString(device);
	}

	/**
	 * 极光推送 获取文件目录
	 * 
	 * @author Pang.M 2017年11月14日
	 * 
	 */
	@RequestMapping(value = "recDirectory")
	@ResponseBody
	public Result recDirectory(@RequestParam(required = false) String deviceSn, String packageName, String id) {
		String notOnline = messageSourceUtil.getMessage("modules.device.not.online");
		String requestFail = messageSourceUtil.getMessage("modules.device.request.fail");
		if (StringUtils.isEmpty(deviceSn) || StringUtils.isEmpty(packageName)) {
			return null;
		}
		RecordInfo recordInfo = recordInfoService.recOperationRecord(id, packageName);

		List<String> alias = new ArrayList<>();
		alias.add(deviceSn);
		JSONObject message = new JSONObject();
		message.put(JSONConstant.JPush.OPTION, ControlCommand.Option.OPTION_F);
		message.put(JSONConstant.JPush.TRANS_ID, recordInfo.getId());
		message.put(JSONConstant.JPush.APP_PACKAGE, recordInfo.getPackageName());
		message.put(JSONConstant.JPush.APP_PATH, recordInfo.getPackagePath());
		try {
			PushResult result = RemotePushUtils.push(alias, ControlCommand.REMOTE_ACCESS_LOG, message.toJSONString());
			if (result == null) {
				return ResultGenerator.genFailResult(notOnline);
			}
		} catch (Exception e) {
			logger.info(e.getMessage(), e);
			return ResultGenerator.genFailResult(requestFail);
		}
		return ResultGenerator.genSuccessResult(recordInfo);
	}

	/**
	 * 创建文件目录节点
	 * 
	 * @author Pang.M 2017年11月15日
	 */
	@RequestMapping(value = "createDirectoryNode")
	@ResponseBody
	public Result createDirectoryNode(String recordId) {
		String getFileError = messageSourceUtil.getMessage("modules.device.getfile.error");

		RecordInfo recordInfo = this.checkRecordInfo(recordId);
		if (recordInfo == null) {
			return ResultGenerator.genFailResult(getFileError);
		}
		List<JSONObject> lstTree = new ArrayList<>();
		JSONArray appInfoArray = JSONArray.parseArray(recordInfo.getPackageInfo());
		Iterator<Object> it = appInfoArray.iterator();
		// 设置自增id,用于子目录ID
		int id = 0;
		while (it.hasNext()) {
			JSONObject ob = (JSONObject) it.next();
			JSONObject directory = new JSONObject();
			id++;
			directory.put(JSONConstant.ZtreeNode.TREE_ID,
					recordInfo.getParentId() + StringUtil.leftPad0ToBytes(String.valueOf(id), 4));
			directory.put(JSONConstant.ZtreeNode.TREE_PID, recordInfo.getParentId());
			directory.put(JSONConstant.ZtreeNode.TREE_NAME, ob.get(JSONConstant.Flie.FILE_NAME));
			directory.put(JSONConstant.ZtreeNode.TREE_TARGET, recordInfo.getId());
			if (ob.get(JSONConstant.Flie.FILE_FLAG).equals(Constant.CONSTANT_SATUS_ZERO)) {
				directory.put(JSONConstant.ZtreeNode.NODE_IS_PARENT, JSONConstant.Result.TRUE);
			}
			lstTree.add(directory);
		}
		return ResultGenerator.genSuccessResult(lstTree);
	}

	/**
	 * 获取设备信息
	 * 
	 * @author Pang.M
	 */
	@RequestMapping(value = "getDeviceInfo")
	@ResponseBody
	public Result getDeviceInfo(@RequestParam String deviceId) {
		String notOnline = messageSourceUtil.getMessage("modules.device.not.online");
		String requestSuccess = messageSourceUtil.getMessage("modules.device.request.success");
		String requestFail = messageSourceUtil.getMessage("modules.device.request.fail");

		Device device = new Device();
		if (!StringUtils.isBlank(deviceId)) {
			device.setId(deviceId);
			device = deviceService.findDeviceById(device);
		}
		try {
			List<String> alias = new ArrayList<>();
			alias.add(device.getDeviceSn());

			JSONArray appArray = new JSONArray();

			PushResult result = RemotePushUtils.push(alias, ControlCommand.GET_DEVICE_INFO, appArray.toJSONString());
			if (result == null) {
				return ResultGenerator.genFailResult(notOnline);
			}
		} catch (Exception e) {
			logger.info(e.getMessage(), e);
			return ResultGenerator.genFailResult(requestFail);
		}
		return ResultGenerator.genSuccessResult(requestSuccess);
	}

	/**
	 * 下载日志文件
	 * 
	 * @author Pang.M
	 */
	@RequestMapping(value = "downloadLogFile")
	public void downloadLogFile(HttpServletResponse response, HttpServletRequest request) {
		String id = request.getParameter("logId");
		FileInputStream fis = null;
		OutputStream os = null;
		try {
			if (StringUtils.isEmpty(id)) {
				throw new ServerException();
			}
			LogFile logInfo = logFileService.findById(id);
			File file = new File(dowloadLogPath + logInfo.getFilePath());

			response.setCharacterEncoding(Constant.CHARACTER_ENCODING_UTF8);
			response.setContentType(Constant.CONTENT_TYPE_OCTET);
			response.setContentLength((int) file.length());
			response.setHeader(Constant.HEADER_CONTENT_DISPOSITION,
					"attachment; filename=" + new String(logInfo.getLogName().getBytes("ISO8859-1"), "UTF-8"));

			fis = new FileInputStream(file);
			os = response.getOutputStream();

			byte[] buffer = new byte[2048 * 4];
			int read;
			while ((read = fis.read(buffer)) > 0) {
				os.write(buffer, 0, read);
				os.flush();
			}

		} catch (Exception e) {
			logger.error("下载文件出错!", e.getMessage());
		} finally {
			IOUtil.closeQuietly(fis);
			IOUtil.closeQuietly(os);
		}
	}

	/**
	 * 导入设备通过设备id
	 * 
	 * @param ids
	 * @return
	 */

	@RequestMapping(value = "importDevice")
	public @ResponseBody Result saveRomDevice(String ids) {
		String importSuccess = messageSourceUtil.getMessage("modules.device.import.success");
		String importFail = messageSourceUtil.getMessage("modules.device.import.fail");

		if (ids != null) {
			try {
				deviceService.importDevice(ids);
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
				return ResultGenerator.genFailResult(importFail);
			}
		}
		return ResultGenerator.genSuccessResult(importSuccess);
	}

	/**
	 * 所有页全选
	 * 
	 * @param device
	 * @param jPushDes
	 * @return
	 */
	@RequestMapping(value = "importAllDevice")
	public @ResponseBody Result importAllDevice(Product product) {
		String importSuccess = messageSourceUtil.getMessage("modules.device.import.success");
		String importFail = messageSourceUtil.getMessage("modules.device.import.fail");

		if (product != null) {
			try {
				deviceService.importAllDevice(product);
			} catch (Exception e) {
				logger.info(e.getMessage());
				return ResultGenerator.genFailResult(importFail);
			}
		}
		return ResultGenerator.genSuccessResult(importSuccess);
	}

	/**
	 * 极光推送。获取文件目录信息，等待信息返回展示到页面上
	 * 
	 * @author Pang.M 2017年11月21日
	 */
	@RequestMapping(value = "getFileList")
	@ResponseBody
	public Result getFileList(Device device, String filePath) {
		String notOnline = messageSourceUtil.getMessage("modules.device.not.online");
		String requestFail = messageSourceUtil.getMessage("modules.device.request.fail");
		String getFileError = messageSourceUtil.getMessage("modules.device.getfile.error");

		List<FileInfo> fileInfoList = new ArrayList<>();
		RecordInfo recordInfo = recordInfoService.recOperationRecord("", filePath);
		List<String> alias = new ArrayList<>();
		alias.add(device.getDeviceSn());

		JSONObject message = new JSONObject();
		message.put(JSONConstant.JPush.OPTION, ControlCommand.Option.OPTION_F);
		message.put(JSONConstant.JPush.TRANS_ID, recordInfo.getId());
		message.put(JSONConstant.JPush.APP_PATH, recordInfo.getPackageName());
		try {
			PushResult result = RemotePushUtils.push(alias, ControlCommand.REMOTE_ACCESS_LOG, message.toJSONString());
			if (result == null) {
				return ResultGenerator.genFailResult(notOnline);
			}
		} catch (Exception e) {
			logger.info(e.getMessage(), e);
			return ResultGenerator.genFailResult(requestFail);
		}

		recordInfo = this.checkRecordInfo(recordInfo.getId());
		if (recordInfo == null) {
			return ResultGenerator.genFailResult(getFileError);
		}

		JSONArray fileInfoArray = JSONArray.parseArray(recordInfo.getPackageInfo());
		Iterator<Object> it = fileInfoArray.iterator();
		while (it.hasNext()) {
			JSONObject ob = (JSONObject) it.next();
			FileInfo fileInfo = JSON.toJavaObject(ob, FileInfo.class);
			// 将以秒为单位的日期转成yyyy-MM-dd hh:mm:ss的日期格式
			long time = Long.parseLong(fileInfo.getFileTimes());
			String dateTime = DateUtils.formatDateTime(new Date(time));
			fileInfo.setFileTimes(dateTime);
			fileInfo.setFileFlag(fileInfo.getFileFlag().equals("0") ? "目录" : "文件");
			fileInfo.setLength(fileInfo.getLength() + " B");
			fileInfoList.add(fileInfo);
		}

		return ResultGenerator.genSuccessResult(fileInfoList);
	}

	/**
	 * 循环获取记录信息
	 * 
	 * @param recordInfo
	 * @return
	 */
	public RecordInfo checkRecordInfo(String recordId) {
		String getFileError = messageSourceUtil.getMessage("modules.device.getfile.error");

		RecordInfo recordInfo = new RecordInfo();
		// 设置定时器，定时执行任务，如果查询一分钟还没返回结果，则通知页面查询失败
		// 定义计量器，如果满足条件跳出
		int i = 0;
		do {
			i++;
			if (i > 1) {
				try {
					TimeUnit.MILLISECONDS.sleep(6000); // 毫秒
				} catch (InterruptedException e) {
					logger.error(getFileError, e.getMessage());
					Thread.currentThread().interrupt();
					return null;
				}
			}
			if (i > 10) {
				return null;
			}
			recordInfo = recordInfoService.findById(recordId);
		} while (StringUtils.isBlank(recordInfo.getPackageInfo()));

		return recordInfo;
	}
	
	@RequiresPermissions("device:view")
	@RequestMapping(value = "toBoundDevice")
	public String toBoundTerm(Model model, HttpServletRequest request,String mId) {
		String officeId = UserUtils.getUser().getOfficeId();
		Merchant merchant = new Merchant();
		merchant.setOrgId(officeId);
		merchant.setId(mId);
		List<Merchant> merchants = systemService.getAllMerchant(merchant);
		Device device = new Device();
		device.setOrganId(officeId);
		List<Device> devices = deviceService.getOrgDevices(device);
		model.addAttribute("merchants", merchants);
		model.addAttribute("devices", devices);
		model.addAttribute("mId", mId);
		model.addAttribute("boundStatus", "1");
		return "modules/device/deviceBundList";
	}
	
	@RequiresPermissions("device:view")
	@RequestMapping(value = "toBoundStoreDevice")
	public String toBoundStoreDevice(Model model, HttpServletRequest request,String sId) {
		Store store = systemService.getStoreById(sId);
		Merchant merchant = systemService.getMerchantByMerId(store.getMerId());
		String officeId = UserUtils.getUser().getOfficeId();
		merchant.setOrgId(officeId);
		List<Merchant> merchants = systemService.getAllMerchant(merchant);
		Device device = new Device();
		device.setOrganId(officeId);
		device.setDeviceBundState("1");
		List<Device> unbunds = deviceService.getOrgDevices(device);
		model.addAttribute("merchants", merchants);
		model.addAttribute("unbunds", unbunds);
		model.addAttribute("sId", sId);
		model.addAttribute("boundStatus", "1");
		return "modules/device/deviceBundList";
	}
	
	@RequiresPermissions("device:view")
	@RequestMapping(value = "deviceBundList")
	public @ResponseBody Map<String, Object> listS(String reqObj,HttpServletRequest request) throws Exception {
		String mId = request.getParameter("mId");
		String sId = request.getParameter("sId");
		Device device = new ParamResult<Device>(reqObj).getEntity(Device.class);
		String deviceBundState = device.getDeviceBundState();
		String officeId = UserUtils.getUser().getOfficeId();
		device.setOrganId(officeId);
		device.setmId(mId);
		device.setsId(sId);
		PageInfo<Device> findMerchantPage = deviceService.findDevicePage(device);
		request.setAttribute("boundStatus", deviceBundState);
		return resultMap(device, findMerchantPage);
	}
	
	

	/**
	 * 获取设备数量
	 * 
	 * @return
	 */
	@RequestMapping(value = "getDeviceCount")
	public @ResponseBody Result getDeviceCount(String type) {
		Integer deviceCount = deviceService.getDeviceCount(type);
		return ResultGenerator.genSuccessResult(deviceCount);
	}
	
	/**
	 * 绑定单个设备
	 * 
	 * @return
	 */
	@RequiresPermissions("device:edit")
	@RequestMapping(value = "boundOneTerm")
	public @ResponseBody Result boundOneTerm(Model model, HttpServletRequest request) {
		String merId = request.getParameter("merId");
		String deviceId = request.getParameter("deviceId");
		String storeId = request.getParameter("storeId");
		if (StringUtils.isEmpty(deviceId)) {
			return ResultGenerator.genFailResult("请选择设备");
		}
		if (StringUtils.isEmpty(merId)) {
			return ResultGenerator.genFailResult("请选择商户");
		}
		systemService.boundOneTerm(merId, deviceId, storeId);
		return ResultGenerator.genSuccessResult();
	}
	
	@RequiresPermissions("device:edit")
	@RequestMapping(value = "unBoundOneTerm")
	@ResponseBody
	public Result unBoundOneTerm(String id) {
		Device device = new Device();
		device.setId(id);
		systemService.updateBoundState(device);
		String deleteSuccess = messageSourceUtil.getMessage("sys.merchant.unBoundTerm.success");
		return ResultGenerator.genSuccessResult(deleteSuccess);
	}
	
	@RequiresPermissions("device:edit")
	@RequestMapping(value = "unBoundBatchTerm")
	@ResponseBody
	public Result unBoundBatchTerm(String[] ids) {
		List asList = Arrays.asList(ids);
		systemService.updateBatchBoundState(asList);
		String deleteSuccess = messageSourceUtil.getMessage("sys.merchant.unBoundTerm.success");
		return ResultGenerator.genSuccessResult(deleteSuccess);
	}
	
	@RequiresPermissions("device:edit")
	@RequestMapping(value = "boundBatchTerm")
	@ResponseBody
	public Result boundBatchTerm(String[] ids,String merId,String storeId) {
		List<Device> deviceList = new ArrayList<Device>();
		for (String id : ids) {
			Device device = new Device();
			device.setId(id);
			device.setMerId(merId);
			device.setShopId(storeId);
			deviceList.add(device);
		}
		systemService.batchBundDevice(deviceList);
		String deleteSuccess = messageSourceUtil.getMessage("sys.merchant.boundTerm.success");
		return ResultGenerator.genSuccessResult(deleteSuccess);
	}

	
	@RequestMapping(value="storeList")
	public @ResponseBody Result storeList(String merId) {
		Store store=new Store();
		store.setMerId(merId);
		//List<Store> list=systemService.findStoreList(store);
		return ResultGenerator.genSuccessResult(systemService.findStoreList(store));
	}
}
