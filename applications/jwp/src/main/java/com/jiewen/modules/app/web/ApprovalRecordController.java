package com.jiewen.modules.app.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageInfo;
import com.jiewen.base.core.web.Result;
import com.jiewen.base.core.web.ResultGenerator;
import com.jiewen.jwp.base.constant.DictConstant;
import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.base.web.ParamResult;
import com.jiewen.jwp.common.StringUtils;
import com.jiewen.modules.app.entity.AppDeveloper;
import com.jiewen.modules.app.entity.AppInfo;
import com.jiewen.modules.app.entity.AppVersion;
import com.jiewen.modules.app.entity.ApprovalRecord;
import com.jiewen.modules.app.service.AppDeveloperService;
import com.jiewen.modules.app.service.AppInfoService;
import com.jiewen.modules.app.service.AppVersionService;
import com.jiewen.modules.app.service.ApprovalRecordService;
import com.jiewen.modules.sys.entity.Dict;
import com.jiewen.modules.sys.entity.User;
import com.jiewen.modules.sys.utils.DictUtils;
import com.jiewen.modules.sys.utils.UserUtils;

@Controller
@RequestMapping("${adminPath}/approvalRecord")
public class ApprovalRecordController extends BaseController {

	@Autowired
	private ApprovalRecordService approvalRecordService;

	@Autowired
	private AppInfoService appInfoService;

	@Autowired
	private AppVersionService appVersionService;

	@Autowired
	private AppDeveloperService appDeveloperService;

	public static final String VERTICAL_LINE = ",";

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

	@RequestMapping(value = "approveIndex")
	public String approveIndex(Model model) {
		List<Dict> clientIdentifyList = DictUtils.getDictList("client_identify");
		model.addAttribute("clientIdentifyList", clientIdentifyList);
		List<Dict> platformList = DictUtils.getDictList("app_platform");
		model.addAttribute("platformList", platformList);
		List<Dict> categoryList = DictUtils.getDictList("app_category");
		model.addAttribute("categoryList", categoryList);
		return "modules/app/appInfo/approveList";
	}

	@RequiresPermissions("app:approval:view")
	@RequestMapping(value = { "approveList", "" })
	@ResponseBody
	public Map<String, Object> approveList(String reqObj) throws Exception {
		AppInfo appInfo = new ParamResult<AppInfo>(reqObj).getEntity(AppInfo.class);
		appInfo.setOrganId(UserUtils.getUser().getOfficeId());
		PageInfo<AppInfo> pageInfo = appInfoService.findApprovalPage(appInfo);
		return resultMap(appInfo, pageInfo);
	}

	@RequiresPermissions("app:info:edit")
	@RequestMapping(value = "approveForm")
	public String approveForm(AppInfo appInfo, Model model, HttpServletRequest request) {
		String logoUrl = appInfo.getAppLogo();
		String appImg1 = appInfo.getAppImg().split(VERTICAL_LINE)[0];
		String appImg2 = appInfo.getAppImg().split(VERTICAL_LINE)[1];
		String appImg3 = appInfo.getAppImg().split(VERTICAL_LINE)[2];
		appInfo.setAppLogo(logoUrl);
		appInfo.setAppImg1(appImg1);
		appInfo.setAppImg2(appImg2);
		appInfo.setAppImg3(appImg3);
		model.addAttribute("appInfo", appInfo);

		List<AppDeveloper> appDeveloperList = appDeveloperService.findList(new AppDeveloper());
		model.addAttribute("appDeveloperList", appDeveloperList);

		List<Dict> platformList = DictUtils.getDictList("app_platform");
		model.addAttribute("platformList", platformList);

		List<Dict> categoryList = DictUtils.getDictList("app_category");
		model.addAttribute("categoryList", categoryList);

		List<AppVersion> appVersionList = appVersionService.findAppVerByVersion(appInfo.getAppPackage());
		if (appVersionList.size() > 0) {
			AppVersion appVersion = appVersionList.get(0);
			appInfo.setAppVersion(appVersion.getAppVersion());
			appInfo.setVersionId(appVersion.getId());
			appInfo.setAppFile(appVersion.getAppFile());
			appInfo.setAppDescription(appVersion.getAppDescription());
		}

		return "modules/app/appInfo/approveForm";
	}

	@RequestMapping(value = { "approveValidator", "" })
	@ResponseBody
	public Result approveValidator(AppInfo appInfo) {
		String approvalNotPass = messageSourceUtil.getMessage("app.approval.not.pass");
		String approvalPass = messageSourceUtil.getMessage("app.approval.pass");
		List<AppVersion> appVersionList = appVersionService.findAppVerByVersion(appInfo.getAppPackage());
		if (appVersionList == null || appVersionList.size() == 0) {
			return ResultGenerator.genFailResult(approvalNotPass);
		}
		return ResultGenerator.genSuccessResult(approvalPass);
	}

	/**
	 * 应用审核详情
	 * 
	 * @return
	 */
	@RequestMapping(value = "approveDetailIndex")
	public String approveDetailIndex(Model model, String id) {
		model.addAttribute("id", id);
		return "modules/app/appInfo/approveDetailList";
	}

	@RequiresPermissions("app:approval:view")
	@RequestMapping(value = { "approveDetailList", "" })
	@ResponseBody
	public Map<String, Object> approveDetailList(String reqObj, String id) throws Exception {
		ApprovalRecord approvalRecord = new ParamResult<ApprovalRecord>(reqObj).getEntity(ApprovalRecord.class);
		approvalRecord.setAppId(id);
		PageInfo<ApprovalRecord> pageInfo = approvalRecordService.findApprovalDetailPage(approvalRecord);
		return resultMap(approvalRecord, pageInfo);
	}

	/**
	 * 应用审核详情
	 * 
	 * @return
	 */
	@RequestMapping(value = "approveDetail")
	public String approveDetail(Model model) {
		List<Dict> approveFlagList = DictUtils.getDictList("approve_flag");
		model.addAttribute("approveFlagList", approveFlagList);
		List<Dict> appDataScopeList = DictUtils.getDictList("app_data_scope");
		model.addAttribute("appDataScopeList", appDataScopeList);
		return "modules/app/appInfo/approveDetail";
	}

	@RequestMapping(value = "saveApprovalRecord")
	public @ResponseBody Result saveApprovalRecord(String id, String flag, String appDataScope, String approveRemarks) {
		String approvalSuccess = messageSourceUtil.getMessage("app.approval.success");
		String appInfoNotNull = messageSourceUtil.getMessage("app.approval.app.information.not.null");
		AppInfo rtAppInfo = appInfoService.get(id);
		if (rtAppInfo == null) {
			return ResultGenerator.genFailResult(appInfoNotNull);
		}
		User user = UserUtils.getUser();
		String approveFlag = DictConstant.AppStatus.IN_REVIEW;
		if (user.getOffice().getGrade().equals("1") && flag.equals("0")) {
			approveFlag = DictConstant.AppStatus.ALREADY_ONLINE;
		}
		if (flag.equals("1")) {
			approveFlag = DictConstant.AppStatus.UNAPPROVE;
		}

		approvalRecordService.saveApprovalRecord(rtAppInfo, user, approveFlag, appDataScope, approveRemarks);
		return ResultGenerator.genSuccessResult(approvalSuccess);
	}

}
