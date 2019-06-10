package com.jiewen.modules.app.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.MessageFormat;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang3.ObjectUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.github.pagehelper.PageInfo;
import com.jiewen.apkutils.packinfo.bean.ApkInfo;
import com.jiewen.base.core.web.Result;
import com.jiewen.base.core.web.ResultGenerator;
import com.jiewen.constant.ControlCommand;
import com.jiewen.jwp.base.utils.ApkInfoUtil;
import com.jiewen.jwp.base.utils.FtpUtils;
import com.jiewen.jwp.base.utils.UploadUtil;
import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.base.web.ParamResult;
import com.jiewen.jwp.common.Collections3;
import com.jiewen.jwp.common.FileUtils;
import com.jiewen.jwp.common.StringUtils;
import com.jiewen.jwp.common.annotation.RefreshCSRFToken;
import com.jiewen.modules.app.entity.AppDeviceType;
import com.jiewen.modules.app.entity.AppInfo;
import com.jiewen.modules.app.entity.AppVersion;
import com.jiewen.modules.app.service.AppDeviceTypeService;
import com.jiewen.modules.app.service.AppInfoService;
import com.jiewen.modules.app.service.AppVersionService;
import com.jiewen.modules.baseinfo.entity.DeviceType;
import com.jiewen.modules.baseinfo.entity.ManuFacturer;
import com.jiewen.modules.baseinfo.service.DeviceTypeService;
import com.jiewen.modules.baseinfo.service.ManuFacturerService;
import com.jiewen.modules.device.entity.Device;
import com.jiewen.modules.device.service.DeviceService;
import com.jiewen.modules.sys.entity.Dict;
import com.jiewen.modules.sys.utils.DictUtils;
import com.jiewen.modules.sys.utils.UserUtils;
import com.jiewen.modules.upload.entity.FileResult;

@Controller
@RequestMapping("${adminPath}/appVersion")
public class AppVersionController extends BaseController {

	private static final String MESSAGE = "message";

	@Value("${ftp.apk.path}")
	private String APK_PATH;

	@Autowired
	private AppVersionService appVersionService;

	@Autowired
	private AppInfoService appInfoService;

	@Autowired
	private ManuFacturerService manuFacturerService;

	@Autowired
	private DeviceTypeService deviceTypeService;

	@Autowired
	private AppDeviceTypeService appDeviceTypeService;

	@Autowired
	private DeviceService deviceService;

	private static final String DEVICE_TYPE_LIST = "deviceTypeList";

	private static final String MANU_FACT_LIST = "manuFacturerList";

	private static final String INDUSTRY_LIST = "industryList";

	private static final String C_ID = "clientIdentification";

	@RequestMapping(value = "index")
	public String index() {
		return "modules/app/version/appVersionList";
	}

	@ModelAttribute
	public Model propeMode(Model model) {
		model.addAttribute(DEVICE_TYPE_LIST, getDeviceTypeList());
		model.addAttribute(MANU_FACT_LIST, getManufacturerList());
		return model;
	}

	@RequestMapping(value = "deviceAppIndex")
	public String deviceAppIndex(Model model) {
		return "modules/app/deviceRecord/recordDeviceList";
	}

	@RequestMapping(value = "alreadyReleaseIndex")
	public String alreadyReleaseIndex(Model model) {
		return "modules/app/release/alreadyAppVersionList";
	}

	@RequestMapping(value = "passiveReleaseIndex")
	public String passiveReleaseIndex(Model model) {
		// type: 0 被动 1 主动
		model.addAttribute("type", "0");
		return "modules/app/release/releaseAppVersionList";
	}

	@RequestMapping(value = "activeReleaseIndex")
	public String activeReleaseIndex(Model model) {
		// type: 0 被动 1 主动
		model.addAttribute("type", "1");
		return "modules/app/release/releaseAppVersionList";
	}

	/**
	 * 没有被这个版本发布的设备列表 主动
	 * 
	 * @param id
	 * @param osDeviceType
	 * @param model
	 * @return
	 */
	@RequestMapping("noReleaseDevices")
	public String noReleaseDevices(AppVersion appVersion, String type, Model model) {

		model.addAttribute("id", appVersion.getId());
		List<Dict> industryList = DictUtils.getDictList("40010");
		model.addAttribute(INDUSTRY_LIST, industryList);
		model.addAttribute("type", type);
		// 1:按照类型发布 2:按照sn发布
		if ("1".equals(appVersion.getReleaseType())) {
			return "modules/app/release/releaseByTypeDeviceList";
		} else {
			return "modules/app/release/releaseDeviceList";
		}
	}

	/**
	 * 上传设备SN信息
	 * 
	 * @param id
	 * @param osDeviceType
	 * @param model
	 * @return
	 */
	@RequestMapping("alreadyReleaseDeviceList")
	public String releaseAlreadyEdition(AppVersion appVersion, Model model) {

		model.addAttribute("id", appVersion.getId());

		model.addAttribute(DEVICE_TYPE_LIST, getDeviceTypeList());
		model.addAttribute(MANU_FACT_LIST, getManufacturerList());
		List<Dict> industryList = DictUtils.getDictList("40010");
		model.addAttribute(INDUSTRY_LIST, industryList);

		return "modules/app/release/alreadyDeviceList";
	}

	@ModelAttribute
	public AppVersion get(@RequestParam(required = false) String id) {
		AppVersion appVersion = new AppVersion();
		if (!StringUtils.isBlank(id)) {
			appVersion.setId(id);
			appVersion = appVersionService.getAppVersionById(appVersion);
		}
		return appVersion;
	}

	@RequiresPermissions("app:version:view")
	@RequestMapping(value = { "list", "" })
	@ResponseBody
	public Map<String, Object> list(String reqObj) throws Exception {
		AppVersion appVersion = new ParamResult<AppVersion>(reqObj).getEntity(AppVersion.class);
		PageInfo<AppVersion> pageInfo = appVersionService.findPage(appVersion);
		return resultMap(appVersion, pageInfo);
	}

	/**
	 * 去已发布系统版本页面
	 * 
	 * @param id
	 * @param osDeviceType
	 * @param model
	 * @return
	 */
	@RequestMapping("toRecordAppVersionIndex")
	public String toRecordAppVersionIndex(String id, Model model) {
		Device params = new Device();
		params.setId(id);
		Device device = deviceService.findDeviceById(params);
		if (device == null) {
			device = new Device();
		}
		model.addAttribute("deviceSn", device.getDeviceSn());
		return "modules/app/deviceRecord/appRecordList";
	}

	@RequestMapping(value = { "findAppVersionByDeviceSn", "" })
	@ResponseBody
	public Map<String, Object> findAppVersionByDeviceSn(String reqObj, String deviceSn) throws Exception {
		AppVersion appVersion = new ParamResult<AppVersion>(reqObj).getEntity(AppVersion.class);
		appVersion.setAppDescription(deviceSn);
		return resultMap(appVersion, appVersionService.findAppVersionByDeviceSn(appVersion));
	}

	@RequiresPermissions("app:version:edit")
	@RequestMapping(value = "delete")
	public @ResponseBody Result delete(AppVersion appVersion) {
		String deleteSuccess = messageSourceUtil.getMessage("common.deleteSuccess");
		String deleteFail = messageSourceUtil.getMessage("common.deleteFail");
		try {
			appVersionService.deleteById(appVersion);
		} catch (Exception e) {
			return ResultGenerator.genFailResult(deleteFail);
		}
		return ResultGenerator.genSuccessResult(deleteSuccess);
	}

	List<ManuFacturer> getManufacturerList() {
		return manuFacturerService.findList();
	}

	List<DeviceType> getDeviceTypeList() {
		return deviceTypeService.getDeviceTypeList();
	}

	@RequiresPermissions("app:version:edit")
	@RefreshCSRFToken
	@RequestMapping(value = "form/{option}")
	public String form(@ModelAttribute AppVersion appVersion, Model model, @PathVariable String option,
			String appInfoId) {

		List<Dict> dictList = DictUtils.getDictList("app_upgrade_type");
		model.addAttribute("dictList", dictList);

		AppInfo appInfo = appInfoService.get(appInfoId);
		model.addAttribute("appInfo", appInfo);

		if (option.equals("add")) {
			AppInfo appinfo = new AppInfo();
			appinfo.setId(appInfoId);
			appinfo = appInfoService.get(appinfo);
			appVersion.setAppName(appinfo.getAppName());
			appVersion.setAppPackage(appinfo.getAppPackage());
		} else {
			List<AppDeviceType> appDeviceTypeList = appDeviceTypeService.getAppDeviceTypeByApkId(appVersion.getId());
			StringBuilder manuNoSb = new StringBuilder();
			if (!Collections3.isEmpty(appDeviceTypeList)) {
				manuNoSb.append(Collections3.extractToString(appDeviceTypeList, "manuNo", ","));
			}
			model.addAttribute("manuNoString", manuNoSb);
		}
		model.addAttribute("appVersion", appVersion);
		model.addAttribute("option", option);
		return "modules/app/version/appVersionForm";
	}

	@RequiresPermissions("app:version:edit")
	@RequestMapping(value = { "save", "" })
	@ResponseBody
	public Result save(@RequestParam("file") MultipartFile file, AppVersion appVersion, HttpServletRequest request,
			Model model) throws Exception {
		String saveSuccess = messageSourceUtil.getMessage("common.saveSuccess");
		String updateSuccess = messageSourceUtil.getMessage("common.updateSuccess");
		String versionFile = messageSourceUtil.getMessage("modules.app.version.select.app.version.file");
		String addErrorMsg = messageSourceUtil.getMessage("app.varsion.add.error.msg");
		String fileName = file.getOriginalFilename();
		ApkInfo apkInfo = new ApkInfo();
		ApkInfoUtil.getApkInfo(convert(file), apkInfo);
		appVersion.setAppPackage(apkInfo.getPackageName());
		appVersion.setAppVersionNumber(apkInfo.getVersionCode());

		AppInfo appInfoParam = new AppInfo();
		appInfoParam.setAppPackage(appVersion.getAppPackage());
		AppInfo appInfo = appInfoService.getByPackageName(appInfoParam);
		if (appInfo == null) {
			return ResultGenerator.genFailResult(MessageFormat.format(addErrorMsg, appVersion.getAppPackage()));
		}

		if (StringUtils.isNotBlank(fileName)) {

			verifyFileName(appVersion, file, model);
			if (model.asMap().get(MESSAGE) != null) {
				return ResultGenerator.genFailResult(StringUtils.toString(model.asMap().get(MESSAGE), ""));
			}

			if (!StringUtils.equalsIgnoreCase(ControlCommand.SECURE_ELEMENT_PACKAGE, appVersion.getAppPackage())) {
				verifyFile(appVersion, file, model);
				if (model.asMap().get(MESSAGE) != null) {
					return ResultGenerator.genFailResult(StringUtils.toString(model.asMap().get(MESSAGE), ""));
				}
			}
			uploadFile(file, appVersion, request);
		} else {
			return ResultGenerator.genFailResult(versionFile);
		}
		if (appVersion.getIsNewRecord()) {
			appVersion.setOrganId(UserUtils.getUser().getOfficeId());
			appVersionService.saveAppVersion(appVersion);
			return ResultGenerator.genSuccessResult(saveSuccess);
		}

		appVersionService.update(appVersion);
		return ResultGenerator.genSuccessResult(updateSuccess);
	}

	/**
	 * 验证上传apk文件name格式是否正确
	 * 
	 * @param appVersion
	 * @param file
	 * @param model
	 */
	private void verifyFileName(AppVersion appVersion, MultipartFile file, Model model) {
		String fileName = file.getOriginalFilename();
		if (!StringUtils.endsWithIgnoreCase(fileName, ".bin") && !StringUtils.endsWithIgnoreCase(fileName, ".apk")) {
			String message = messageSourceUtil.getMessage("modules.app.upload.bin");
			String message1 = messageSourceUtil.getMessage("modules.app.upload.apk");
			addMessage(model, message + "   " + message1);
		}
		/*
		 * if (!StringUtils.endsWithIgnoreCase(fileName, ".apk")) { String
		 * message = messageSourceUtil.getMessage("modules.app.upload.apk");
		 * addMessage(model, message); }
		 */
	}

	/**
	 * 验证包文件中属性和上传填写属性是否一致
	 * 
	 * @param appVersion
	 * @param file
	 * @param model
	 * @throws IOException
	 */
	private void verifyFile(AppVersion appVersion, MultipartFile file, Model model) throws IOException {
		File apkFile = convert(file);
		ApkInfo apkInfo = new ApkInfo();
		ApkInfoUtil.getApkInfo(apkFile, apkInfo);
		if (ObjectUtils.allNotNull(appVersion, apkInfo)) {
			String versionName = StringUtils.removeAll(String.valueOf(appVersion.getAppVersionNumber()), "[A-Za-z]");
			if (!StringUtils.equalsIgnoreCase(versionName, apkInfo.getVersionCode())) {
				String message = messageSourceUtil.getMessage("modules.app.version.different");
				addMessage(model, message);
			} else if (!StringUtils.equalsIgnoreCase(appVersion.getAppPackage(), apkInfo.getPackageName())) {
				String message = messageSourceUtil.getMessage("modules.app.package.different");
				addMessage(model, message);
			}
			if (apkFile.exists()) {
				//FileUtils.deleteQuietly(apkFile);
			}
		}
	}

	/**
	 * 上传到ftp保存文件
	 * 
	 * @param file
	 * @param appVersion
	 * @param request
	 * @throws IOException
	 * @throws Exception
	 */
	private void uploadFile(MultipartFile file, AppVersion appVersion, HttpServletRequest request) throws IOException {
		// String organId = StringUtils.replaceAll(appVersion.getOrganId(), ",",
		// "");
		File convert = convert(file);
		boolean dirChangeFlag = uploadFtp(convert, APK_PATH);
		String downloadPath = ftpBaseLoadUrl + "/" + convert.getName();
		if (dirChangeFlag) {
			downloadPath = ftpBaseLoadUrl + APK_PATH + convert.getName();
		}
		FileInputStream in = new FileInputStream(convert);
		String md5Hex = DigestUtils.md5Hex(in);
		appVersion.setAppFile(downloadPath);
		appVersion.setAppMd5(md5Hex);
		appVersion.setAppFileSize(String.valueOf(file.getSize()));
		String canonicalPath = convert.getCanonicalPath();
		in.close();
		FileUtils.deleteFile(canonicalPath);
	}

	/**
	 * 文件转换
	 * 
	 * @param file
	 * @return
	 * @throws IOException
	 */
	public static File convert(MultipartFile file) throws IOException {

		File convFile = new File(file.getOriginalFilename());
		if (convFile.exists()) {
			//FileUtils.deleteQuietly(convFile);
		}
		convFile.createNewFile();
		try (FileOutputStream fos = new FileOutputStream(convFile)) {
			fos.write(file.getBytes());
			fos.close();
		}
		return convFile;
	}

	@RequestMapping(value = { "deviceTypelist/{appId}", "" })
	@ResponseBody
	public Map<String, Object> deviceTypelist(@PathVariable("appId") String appId, String reqObj) throws Exception {
		AppDeviceType appDeviceType = new ParamResult<AppDeviceType>(reqObj).getEntity(AppDeviceType.class);
		appDeviceType.setApkId(new Long(appId));
		PageInfo<AppDeviceType> pageInfo = appDeviceTypeService.findPage(appDeviceType);
		return resultMap(appDeviceType, pageInfo);
	}

	/**
	 * 获取文件
	 * 
	 * @param fileIds
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "getFiles/{field}/{appInfoId}", method = RequestMethod.POST)
	@ResponseBody
	public FileResult getFiles(@PathVariable("field") String field, @PathVariable("appInfoId") String appInfoId,
			HttpServletRequest request) {
		AppVersion appVersionById = appVersionService.get(appInfoId);
		request.setAttribute("type", "file");
		return UploadUtil.getPreivewSettings(appVersionById.getAppFile(), "您没有上传apk文件！");
	}

	private boolean uploadFtp(File file, String filePath) throws IOException {
		FtpUtils.setHost(ftpHost);
		FtpUtils.setPassword(ftpPassword);
		FtpUtils.setUsername(ftpUsername);
		return FtpUtils.uploadFtp(file, filePath);
	}
}
