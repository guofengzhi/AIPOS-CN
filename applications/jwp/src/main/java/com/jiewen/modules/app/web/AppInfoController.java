package com.jiewen.modules.app.web;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.github.pagehelper.PageInfo;
import com.jiewen.base.core.web.Result;
import com.jiewen.base.core.web.ResultGenerator;
import com.jiewen.jwp.base.constant.DictConstant;
import com.jiewen.jwp.base.utils.FtpUtils;
import com.jiewen.jwp.base.utils.UploadUtil;
import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.base.web.ParamResult;
import com.jiewen.jwp.common.FileUtils;
import com.jiewen.jwp.common.StringUtils;
import com.jiewen.jwp.common.annotation.RefreshCSRFToken;
import com.jiewen.modules.app.entity.AppDeveloper;
import com.jiewen.modules.app.entity.AppInfo;
import com.jiewen.modules.app.service.AppDeveloperService;
import com.jiewen.modules.app.service.AppInfoService;
import com.jiewen.modules.app.service.AppVersionService;
import com.jiewen.modules.baseinfo.entity.DeviceType;
import com.jiewen.modules.baseinfo.entity.ManuFacturer;
import com.jiewen.modules.baseinfo.service.DeviceTypeService;
import com.jiewen.modules.baseinfo.service.ManuFacturerService;
import com.jiewen.modules.sys.entity.Dict;
import com.jiewen.modules.sys.utils.DictUtils;
import com.jiewen.modules.sys.utils.UserUtils;
import com.jiewen.modules.upload.entity.FileResult;

@Controller
@RequestMapping("${adminPath}/appInfo")
public class AppInfoController extends BaseController {

	@Autowired
	private AppInfoService appInfoService;

	@Autowired
	private AppDeveloperService appDeveloperService;

	@Autowired
	private AppVersionService appVersionService;

	@Autowired
	private ManuFacturerService manuFacturerService;

	@Autowired
	private DeviceTypeService deviceTypeService;

	private static final String DEVICE_TYPE_LIST = "deviceTypeList";

	private static final String MANU_FACT_LIST = "manuFacturerList";

	private static final String INDUSTRY_LIST = "industryList";

	public static final String ROOT = "/appFile";

	@Value("${ftp.pic.path}")
	private String APK_PIC_PATH;

	private static final String APK_ICON = "/apk_ico/";

	public static final String VERTICAL_LINE = ",";

	// 显示图片的方法关键 匹配路径像 localhost:8080/b7c76eb3-5a67-4d41-ae5c-1642af3f8746.png
	@RequestMapping(method = { RequestMethod.GET, RequestMethod.POST }, value = "/{filename:.+}")
	@ResponseBody
	public ResponseEntity<?> getFile(@PathVariable String filename, HttpServletRequest request) {
		try {
			return ResponseEntity.ok(
					UploadUtil.loadFileAsResource(UploadUtil.getUploadDir(request) + ROOT + File.separator + filename));
		} catch (Exception e) {
			return ResponseEntity.notFound().build();
		}
	}

	@RequestMapping(value = "index")
	public String index(Model model) {
		List<Dict> clientIdentifyList = DictUtils.getDictList("client_identify");
		model.addAttribute("clientIdentifyList", clientIdentifyList);
		List<Dict> platformList = DictUtils.getDictList("app_platform");
		model.addAttribute("platformList", platformList);
		List<Dict> categoryList = DictUtils.getDictList("app_category");
		model.addAttribute("categoryList", categoryList);
		return "modules/app/appInfo/appInfoList";
	}

	@RequestMapping(value = "appTelemanagementIndex")
	public String appTelemanagementIndex(Model model) {
		List<Dict> clientIdentifyList = DictUtils.getDictList("client_identify");
		model.addAttribute("clientIdentifyList", clientIdentifyList);
		List<Dict> platformList = DictUtils.getDictList("app_platform");
		model.addAttribute("platformList", platformList);
		List<Dict> categoryList = DictUtils.getDictList("app_category");
		model.addAttribute("categoryList", categoryList);
		return "modules/app/appManage/appTelemanagementList";
	}

	@RequiresPermissions("app:info:view")
	@RequestMapping(value = { "appTelemanagementList", "" })
	@ResponseBody
	public Map<String, Object> appTelemanagementList(String reqObj) throws Exception {
		AppInfo appInfo = new ParamResult<AppInfo>(reqObj).getEntity(AppInfo.class);
		appInfo.setCurrentApproveFlag(DictConstant.AppStatus.ALREADY_ONLINE);
		appInfo.setOrganId(UserUtils.getUser().getOfficeId());
		PageInfo<AppInfo> pageInfo = appInfoService.findPage(appInfo);
		return resultMap(appInfo, pageInfo);
	}

	@ModelAttribute
	public AppInfo get(@RequestParam(required = false) String id) {
		if (!StringUtils.isBlank(id)) {
			AppInfo appInfo = new AppInfo();
			appInfo.setId(id);
			return appInfoService.get(appInfo);
		} else {
			return new AppInfo();
		}
	}

	@RequiresPermissions("app:info:view")
	@RequestMapping(value = { "list", "" })
	@ResponseBody
	public Map<String, Object> list(String reqObj) throws Exception {
		AppInfo appInfo = new ParamResult<AppInfo>(reqObj).getEntity(AppInfo.class);
		appInfo.setOrganId(UserUtils.getUser().getOfficeId());
		PageInfo<AppInfo> pageInfo = appInfoService.findPage(appInfo);
		return resultMap(appInfo, pageInfo);
	}

	@RequiresPermissions("app:info:edit")
	@RequestMapping(value = "delete")
	public @ResponseBody Result delete(AppInfo appInfo) {
		String deleteFail = messageSourceUtil.getMessage("common.deleteFail");
		String deleteSuccess = messageSourceUtil.getMessage("common.deleteSuccess");
		try {
			appInfoService.deleteById(appInfo);
		} catch (Exception e) {
			return ResultGenerator.genFailResult(deleteFail);
		}
		return ResultGenerator.genSuccessResult(deleteSuccess);
	}

	@RequiresPermissions("app:info:edit")
	@RefreshCSRFToken
	@RequestMapping(value = "form/{option}")
	public String form(@PathVariable String option, AppInfo appInfo, Model model) {
		String id = appInfo.getId();
		if (StringUtils.isNotEmpty(id)) {
			appInfo = appInfoService.getAppInfoById(id);
			String appImg = appInfo.getAppImg();
			String[] split = appImg.split(",");
			appInfo.setAppImg1(split[0]);
			appInfo.setAppImg2(split[1]);
			appInfo.setAppImg3(split[2]);
		}
		model.addAttribute("appInfo", appInfo);
		model.addAttribute("option", option);

		List<AppDeveloper> appDeveloperList = appDeveloperService.findList(new AppDeveloper());
		model.addAttribute("appDeveloperList", appDeveloperList);

		List<Dict> platformList = DictUtils.getDictList("app_platform");
		model.addAttribute("platformList", platformList);

		List<Dict> categoryList = DictUtils.getDictList("app_category");
		model.addAttribute("categoryList", categoryList);
		return "modules/app/appInfo/appInfoForm";
	}

	/**
	 * 获取文件
	 * 
	 * @param fileIds
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "getFiles", method = RequestMethod.POST)
	@ResponseBody
	public FileResult getFiles(String fileName, HttpServletRequest request) {
		String aId = request.getParameter("aId");
		AppInfo appInfo = appInfoService.getAppInfoById(aId);
		return UploadUtil.getPreivewSettings(appInfo.getAppLogo(), "你没有上传app logo！");
	}

	@RequestMapping(value = { "getAppInfoByName", "" })
	@ResponseBody
	public Result getAppInfoByName(String appName) throws Exception {
		String searchError = messageSourceUtil.getMessage("common.search.error");
		AppInfo appInfo = new AppInfo();
		try {
			appInfo = appInfoService.findAppInfoByName(appName);
		} catch (Exception e) {
			return ResultGenerator.genFailResult(searchError);
		}
		return ResultGenerator.genSuccessResult(appInfo);
	}

	@RequiresPermissions("app:info:edit")
	@RequestMapping(value = { "save", "" })
	@ResponseBody
	public Result save(AppInfo appInfo, HttpServletRequest request, @RequestParam("logoFile") MultipartFile logoFile,
			@RequestParam("appImage") MultipartFile[] multipartfiles, RedirectAttributes redirectAttributes)
			throws Exception {
		String saveSuccess = messageSourceUtil.getMessage("common.saveSuccess");
		String updateSuccess = messageSourceUtil.getMessage("common.updateSuccess");
		String alreadyExist = messageSourceUtil.getMessage("modules.app.existed.please.update.other");

		appInfo.setCurrentApproveFlag(DictConstant.AppStatus.IN_REVIEW);
		File convert = convert(logoFile);
		boolean dirChangeFlag1 = uploadFtp(convert, APK_PIC_PATH);
		String downloadPath1 = ftpBaseLoadUrl + "/" + convert.getName();
		if (dirChangeFlag1) {
			downloadPath1 = ftpBaseLoadUrl + APK_PIC_PATH + convert.getName();
		}
		FileUtils.deleteFile(convert.getCanonicalPath());
		appInfo.setAppLogo(downloadPath1);
		if (null != multipartfiles && multipartfiles.length > 0) {
			StringBuffer stringBuffer = new StringBuffer();
			// 遍历并保存文件
			for (MultipartFile file : multipartfiles) {
				File convert2 = convert(file);
				boolean dirChangeFlag = uploadFtp(convert2, APK_PIC_PATH);
				String downloadPath = ftpBaseLoadUrl + "/" + convert2.getName();
				if (dirChangeFlag) {
					downloadPath = ftpBaseLoadUrl + APK_PIC_PATH + convert2.getName();
				}
				FileUtils.deleteFile(convert2.getCanonicalPath());
				stringBuffer.append(downloadPath).append(VERTICAL_LINE);
			}
			String appImage = stringBuffer.toString().substring(0, stringBuffer.toString().length() - 1);
			appInfo.setAppImg(appImage);
		}

		if (StringUtils.isBlank(appInfo.getId())) {
			// 通过机构号和包名查找
			AppInfo reAppInfo = appInfoService.findAppInfoByPAndOID(appInfo);
			// 判断包名是否已存在
			if (reAppInfo != null) {
				return ResultGenerator.genFailResult(alreadyExist);
			}
			appInfo.setOrganId(UserUtils.getUser().getOfficeId());
			appInfoService.saveAppInfo(appInfo);
			return ResultGenerator.genSuccessResult(saveSuccess);
		}

		appInfoService.update(appInfo);
		return ResultGenerator.genSuccessResult(updateSuccess);

	}

	/**
	 * 获取应用数量
	 * 
	 * @return
	 */
	@RequestMapping(value = "getAppInfoCount")
	public @ResponseBody Result getDeviceCount() {
		AppInfo appInfo = new AppInfo();
		appInfo.setOrganId(UserUtils.getUser().getOfficeId());
		int count = appInfoService.getDeviceCount(appInfo);
		return ResultGenerator.genSuccessResult(count);
	}

	List<ManuFacturer> getManufacturerList() {
		return manuFacturerService.findList();
	}

	List<DeviceType> getDeviceTypeList() {
		return deviceTypeService.getDeviceTypeList();
	}

	@RequestMapping("telemanagementDevices")
	public String telemanagementDevices(AppInfo appInfo, String type, Model model) {

		model.addAttribute("id", appInfo.getId());
		model.addAttribute("type", type);
		model.addAttribute(DEVICE_TYPE_LIST, getDeviceTypeList());
		model.addAttribute(MANU_FACT_LIST, getManufacturerList());
		List<Dict> industryList = DictUtils.getDictList("40010");
		model.addAttribute(INDUSTRY_LIST, industryList);

		return "modules/app/appManage/releaseDeviceList";
	}

	/**
	 * 文件转换
	 * 
	 * @param file
	 * @return
	 * @throws IOException
	 */
	public static File convert(MultipartFile file) throws IOException {
		String originalFilename = file.getOriginalFilename();
		if (originalFilename.contains("/")) {
			originalFilename = originalFilename.substring(originalFilename.lastIndexOf("/") + 1,
					originalFilename.length());
		}
		File convFile = new File(originalFilename);
		if (convFile.exists()) {
			//FileUtils.deleteQuietly(convFile);
		}
		// convFile.createNewFile();
		try (FileOutputStream fos = new FileOutputStream(convFile)) {
			fos.write(file.getBytes());
			fos.close();
		}
		return convFile;
	}

	private boolean uploadFtp(File file, String filePath) {
		FtpUtils.setHost(ftpHost);
		FtpUtils.setPassword(ftpPassword);
		FtpUtils.setUsername(ftpUsername);
		return FtpUtils.uploadFtp(file, filePath);
	}
}
