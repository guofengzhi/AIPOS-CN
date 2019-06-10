package com.jiewen.modules.sys.web;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.github.pagehelper.PageInfo;
import com.jiewen.jwp.base.web.Result;
import com.jiewen.jwp.base.web.ResultGenerator;
//import com.jiewen.base.core.web.Result;
//import com.jiewen.base.core.web.ResultGenerator;
import com.jiewen.jwp.base.utils.FileUtils;
import com.jiewen.jwp.base.utils.FtpUtils;
import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.base.web.ParamResult;
import com.jiewen.modules.sys.entity.App;
import com.jiewen.modules.sys.entity.AppDeveloper;
import com.jiewen.modules.sys.entity.AppVersion;
import com.jiewen.modules.sys.entity.Dict;
import com.jiewen.modules.sys.entity.User;
import com.jiewen.modules.sys.service.AppDeveloperService;
import com.jiewen.modules.sys.service.AppService;
import com.jiewen.modules.sys.service.AppVersionService;
import com.jiewen.modules.sys.utils.DictUtils;
import com.jiewen.modules.sys.utils.UserUtils;

/**
 * 应用Controller
 * @author hehansong
 */
 
@Controller
@RequestMapping("app")
public class AppController extends BaseController {

	@Autowired
	private AppService appService;
	
	@Autowired
	private AppDeveloperService appDeveloperService;
	
	@Autowired
	private AppVersionService appVersionService;
	
	@Value("${ftp.pic.path}")
	private String APK_PIC_PATH;
	
	@Value("${ftp.apk.path}")
	private String APP_APK_PATH;
	
	@RequiresPermissions("app:view")
	@RequestMapping(value = "index")
	public String index(HttpServletRequest request) {
	    return "modules/app/appList";
	}
	
	@RequiresPermissions("app:view")
	@RequestMapping(value = "list")
	public @ResponseBody Map<String, Object> list(String reqObj) throws Exception {
		ParamResult<App> paramResult = new ParamResult<App>(reqObj);
		App app = paramResult.getEntity(App.class);
		User user = UserUtils.getUser();
		app.setCreateBy(user);
		PageInfo<App> findAppPage = appService.findAppPage(app);
		return resultMap(app, findAppPage);
	}
	
	@RequiresPermissions("app:view")
	@RequestMapping(value = "form")
	public String form(HttpServletRequest request,Model model,App app) {
		List<AppDeveloper> appDeveloperList = appDeveloperService.findList(new AppDeveloper());
		model.addAttribute("appDeveloperList", appDeveloperList);

		List<Dict> platformList = DictUtils.getDictList("app_platform");
		model.addAttribute("platformList", platformList);
		
		List<Dict> categoryList = DictUtils.getDictList("app_category");
		model.addAttribute("categoryList", categoryList);
		
		String updateFlag = request.getParameter("update");
		String id = request.getParameter("id");
		if(StringUtils.isNotEmpty(id)){
			app = appService.getAppInfoById(id);
			request.getSession().setAttribute("appId", id);
		}
		request.getSession().setAttribute("update", updateFlag);
		model.addAttribute("app", app);
	    return "modules/app/appForm";
	}
	
	@RequiresPermissions("app:edit")
	@RequestMapping(value = "release")
	@ResponseBody
	public Result release(HttpServletRequest request,Model model,App app) {
		String id = request.getParameter("id");
		if(StringUtils.isNotEmpty(id)){
			app.setCurrentApproveFlag("1");
			app.setId(id);
			appService.update(app);
			String releaseSuccess = messageSourceUtil.getMessage("application.published.successfully");
			return ResultGenerator.genSuccessResult(releaseSuccess);
		}
		String releaseFail = messageSourceUtil.getMessage("application.publishing.failed");
		return ResultGenerator.genFailResult(releaseFail);
	}
	
	@RequiresPermissions("app:edit")
	@RequestMapping(value = "delete")
	@ResponseBody
	public Result delete(HttpServletRequest request, Model model) {
		String id = request.getParameter("id");
		App app = new App();
		app.setId(id);
		appService.delete(app);
		String deleteSuccess = messageSourceUtil.getMessage("sys.merchant.promt.delete.success");
		return ResultGenerator.genSuccessResult(deleteSuccess);
	}
	
	@RequiresPermissions("app:edit")
	@RequestMapping(value = { "save", "" })
	@ResponseBody
	public Result save(App app, HttpServletRequest request, @RequestParam("logoFile") MultipartFile logoFile,
			@RequestParam("apkFile") MultipartFile apkFile, RedirectAttributes redirectAttributes)
			throws Exception {
		String saveSuccess = messageSourceUtil.getMessage("common.saveSuccess");
		String updateSuccess = messageSourceUtil.getMessage("common.updateSuccess");
		String updateFlag = (String) request.getSession().getAttribute("update");
		app.setCurrentApproveFlag("4");//审核中
		
		File convertLogo = convert(logoFile);
		boolean dirChangeFlag1 = uploadFtp(convertLogo, APK_PIC_PATH);
		String downloadPath1 = ftpBaseLoadUrl + "/" + convertLogo.getName();
		if (dirChangeFlag1) {
			downloadPath1 = ftpBaseLoadUrl + APK_PIC_PATH + convertLogo.getName();
		}
		FileUtils.deleteFile(convertLogo.getCanonicalPath());
		app.setAppLogo(downloadPath1);
		File convertAppFile = convert(apkFile);
		boolean dirChangeFlag = uploadFtp(convertAppFile, APP_APK_PATH);
		String downloadPath2 = ftpBaseLoadUrl + "/" + convertAppFile.getName();
		if (dirChangeFlag) {
			downloadPath2 = ftpBaseLoadUrl + APP_APK_PATH + convertAppFile.getName();
		}
		AppVersion appVersion = new AppVersion();
		appVersion.setAppFile(downloadPath2);
		appVersion.setAppName(app.getAppName());
		appVersion.setAppPackage(app.getAppPackage());
		appVersion.setOrganId(app.getOrganId());
		appVersionService.save(appVersion);
		if(StringUtils.isNotEmpty(updateFlag)&&StringUtils.equals(updateFlag, "update")){
			String appId = (String) request.getSession().getAttribute("appId");
			app.setId(appId);
			appService.update(app);
			return ResultGenerator.genSuccessResult(updateSuccess);
		}
		appService.save(app);
		return ResultGenerator.genSuccessResult(saveSuccess);

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
			FileUtils.deleteQuietly(convFile);
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
