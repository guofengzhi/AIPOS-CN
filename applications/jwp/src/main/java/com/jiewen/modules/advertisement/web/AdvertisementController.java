package com.jiewen.modules.advertisement.web;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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

import com.github.pagehelper.util.StringUtil;
import com.jiewen.base.core.web.Result;
import com.jiewen.base.core.web.ResultGenerator;
import com.jiewen.commons.util.DateTimeUtil;
import com.jiewen.jwp.base.constant.DictConstant;
import com.jiewen.jwp.base.utils.FtpUtils;
import com.jiewen.jwp.base.utils.IdGen;
import com.jiewen.jwp.base.utils.UploadUtil;
import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.base.web.ParamResult;
import com.jiewen.jwp.common.StringUtils;
import com.jiewen.jwp.common.annotation.RefreshCSRFToken;
import com.jiewen.jwp.common.annotation.VerifyCSRFToken;
import com.jiewen.modules.advertisement.entity.Advertisement;
import com.jiewen.modules.advertisement.service.AdvertisementService;
import com.jiewen.modules.sys.utils.UserUtils;
import com.jiewen.modules.upload.entity.FileResult;


/**
 * 广告管理Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/advertisement")
public class AdvertisementController extends BaseController {

	@Autowired
	private AdvertisementService advertisementService;

	List<String> typeList = Collections.unmodifiableList(Arrays.asList("I", "V", "VO"));

	public static final String ROOT = "/advertisementImg";

	@Value("${ftp.advertisment.path}")
	private String ADVERTISMENT_PATH;

	// 显示图片的方法关键 匹配路径像 localhost:8080/b7c76eb3-5a67-4d41-ae5c-1642af3f8746.png
	@RequestMapping(method = { RequestMethod.GET, RequestMethod.POST }, value = "/{filename:.+}")
	@ResponseBody
	public ResponseEntity<?> getFile(@PathVariable String filename, HttpServletRequest request) {
		try {
			String OfficeId = UserUtils.getUser().getOfficeId();
			return ResponseEntity.ok(UploadUtil.loadFileAsResource(
					UploadUtil.getUploadDir(request) + ROOT + File.separator + OfficeId + File.separator + filename));
		} catch (Exception e) {
			return ResponseEntity.notFound().build();
		}
	}

	@ModelAttribute("advertisement")
	public Advertisement get(@RequestParam(required = false) String id) {
		if (org.apache.commons.lang3.StringUtils.isNotBlank(id)) {
			Advertisement Advertisement = new Advertisement();
			Advertisement.setAdId(id);
			Advertisement orlAdvert = advertisementService.selectByAdId(Advertisement);
			return orlAdvert;
		} else {
			return new Advertisement();
		}
	}

	@RequiresPermissions("sys:advertisement:view")
	@RequestMapping(value = { "index" })
	public String index(Advertisement advertisement, Model model) {
		return "modules/advertisement/advertisementList";
	}

	@RequestMapping(value = "approveIndex")
	public String approveIndex(Advertisement advertisement, Model model) {
		return "modules/advertisement/advertisementApproveList";
	}

	@RequestMapping(value = { "approveList", "" })
	public @ResponseBody Map<String, Object> approveList(String reqObj) throws Exception {
		String OfficeId = UserUtils.getUser().getOfficeId();
		String approvalStatus = "0"; // 审核状态 未审核
		Advertisement advertisement = new ParamResult<Advertisement>(reqObj).getEntity(Advertisement.class);
		advertisement.setOrganId(OfficeId);
		/*
		 * advertisement.setAdStartTime(new Date());
		 * advertisement.setAdEndTime(new Date());
		 */
		advertisement.setApprovalStatus(approvalStatus);
		return resultMap(advertisement, advertisementService.findPage(advertisement));
	}

	@RequiresPermissions("sys:advertisement:view")
	@RequestMapping(value = { "list", "" })
	public @ResponseBody Map<String, Object> list(String reqObj) throws Exception {
		String OfficeId = UserUtils.getUser().getOfficeId();
		Advertisement advertisement = new ParamResult<Advertisement>(reqObj).getEntity(Advertisement.class);
		advertisement.setOrganId(OfficeId);
		/*
		 * advertisement.setAdStartTime(new Date());
		 * advertisement.setAdEndTime(new Date());
		 */
		if (advertisement.getAdStartTime1() == null && advertisement.getAdEndTime1() == null) {
			advertisement.setAdStartTime(org.apache.commons.lang3.time.DateUtils.addDays(new Date(), -30));
			// advertisement.setAdEndTime(new Date());
		} else {
			advertisement.setAdStartTime(advertisement.getAdStartTime1());
			advertisement.setAdEndTime(advertisement.getAdEndTime1());
		}
		return resultMap(advertisement, advertisementService.findPageAdvertisement(advertisement));
	}

	@RefreshCSRFToken
	@RequiresPermissions("sys:advertisement:view")
	@RequestMapping(value = "form")
	public String form(Advertisement advertisement, Model model) {

		model.addAttribute("advertisement", advertisement);

		return "modules/advertisement/advertisementForm";
	}

	@RefreshCSRFToken
	@RequestMapping(value = "advertisementApproveForm")
	public String advertisementApproveForm(Advertisement advertisement, Model model) {
		String adTypeName = "";
		String adType = advertisement.getAdType();
		String id = advertisement.getId();
		Advertisement selectAdvertisementByPrimaryKey = advertisementService.selectAdvertisementByPrimaryKey(id);
		// 广告类型，T-文字、I-图片、V-视频、VO-语音
		if (adType.equals(DictConstant.AdvertisementStatus.AD_TEXT)) {
			adTypeName = "文字";
		} else if (adType.equals(DictConstant.AdvertisementStatus.AD_PICTURE)) {
			adTypeName = "图片";
		} else if (adType.equals(DictConstant.AdvertisementStatus.AD_VOICE)) {
			adTypeName = "视频";
		} else {
			adTypeName = "语音";
		}

		advertisement.setAdTypeName(adTypeName);
		advertisement.setAdImg(selectAdvertisementByPrimaryKey.getAdImg());
		model.addAttribute("advertisement", advertisement);

		return "modules/advertisement/advertisementApproveForm";
	}

	@RefreshCSRFToken
	@RequiresPermissions("sys:advertisement:view")
	@RequestMapping(value = "advertisementForm")
	public @ResponseBody Result advertisementForm(String id) {

		String updateSuccess = messageSourceUtil.getMessage("sys.advertisement.promt.update.success");
		Advertisement advertisement = new Advertisement();
		String adStatus = "0";
		advertisement.setAdId(id);
		advertisement.setAdStatus(adStatus); // 设置为无效
		advertisementService.updateAdvertisementAdStatus(advertisement);
		return ResultGenerator.genSuccessResult(updateSuccess);
	}

	@RequiresPermissions("sys:advertisement:edit")
	@RequestMapping(value = "save")
	@VerifyCSRFToken
	public @ResponseBody Result save(@RequestParam("file") MultipartFile advertisementFile, Advertisement advertisement,
			HttpServletRequest request, Model model) throws IOException {

		// String adStatus = "1";
		String approvalStatus = "0";
		String organId = UserUtils.getUser().getOfficeId();
		// Map<String, String> map = UploadUtil.uploadAdvertisementFile(request,
		// advertisementFile, organId);
		// String adImg = UploadUtil.uploadLogoFile(request, advertisementFile);
		// String fileNameImg = map.get("fileNameImg");
		// String fileName = map.get("fileName");
		File convert = convert(advertisementFile);
		boolean dirChangeFlag = fileUpload(convert, ADVERTISMENT_PATH);
		String fileName = convert.getName();
		String message = "";
		String saveFailed = messageSourceUtil.getMessage("sys.advertisement.saveFailed");
		String saveSuccess = messageSourceUtil.getMessage("sys.advertisement.success");
		String pictureFailed = messageSourceUtil.getMessage("sys.advertisement.pictureFailed");

		// 根据主键判定，如果为空就新增，否则修改
		try {
			message = saveSuccess;
			advertisement.setAdTitle(advertisement.getAdName());
			if (StringUtils.isBlank(advertisement.getAdId())) {
				advertisement.setOrganId(organId);
				advertisement.setAdId(IdGen.uuid()); // 通过Random数字生成主键
				// advertisement.setAdStatus(adStatus); // 广告有效
				advertisement.setCreator(UserUtils.getUser().getId());
				advertisement.setCreateTime(new Date());
				if (StringUtil.isNotEmpty(fileName)) {
					String imgPath = ftpBaseLoadUrl + "/" + fileName;
					if (dirChangeFlag) {
						imgPath = ftpBaseLoadUrl + ADVERTISMENT_PATH + fileName;
					}
					advertisement.setAdImg(imgPath);// url
					advertisement.setAdImg1(fileName);// 名字
				} else {
					message = pictureFailed;
					return ResultGenerator.genFailResult(message);
				}
				advertisement.setApprovalStatus(approvalStatus); // 广告未审核
				advertisementService.insertAdvertisementSelective(advertisement);
			} else {
				advertisement.setUpdator(UserUtils.getUser().getId());
				advertisement.setUpdateTime(new Date());
				if (StringUtil.isNotEmpty(fileName)) {
					String imgPath = ftpBaseLoadUrl + "/" + fileName;
					if (dirChangeFlag) {
						imgPath = ftpBaseLoadUrl + ADVERTISMENT_PATH + fileName;
					}
					advertisement.setAdImg(imgPath);// url
					advertisement.setAdImg1(fileName);// 名字
				}
				advertisement.setApprovalStatus(approvalStatus); // 广告未审核
				advertisementService.updateAdvertisementByPrimaryKeySelective(advertisement);
			}
			//FileUtils.deleteQuietly(convert);
			//FileUtils.deleteDirectory(convert);
		} catch (Exception e) {
			message = saveFailed;
			return ResultGenerator.genFailResult(message);
		}
		return ResultGenerator.genSuccessResult(message);
	}

	@RequiresPermissions("sys:advertisement:edit")
	@RequestMapping(value = "delete")
	@ResponseBody
	public Result delete(String id) {
		String message = "";
		String deleteCurrentFailed = messageSourceUtil.getMessage("sys.advertisement.promt.delete.current.failed");
		String deleteSuccess = messageSourceUtil.getMessage("sys.advertisement.promt.delete.success");
		try {
			message = deleteSuccess;
			advertisementService.deleteAdvertisementByPrimaryKey(id);
		} catch (Exception e) {
			message = deleteCurrentFailed;
			return ResultGenerator.genFailResult(message);
		}

		return ResultGenerator.genSuccessResult(message);
	}

	@RefreshCSRFToken
	@ResponseBody
	@RequestMapping(value = "advertisementCountValidator")
	public String advertisementCountValidator(Advertisement advertisement, HttpServletRequest request,
			HttpServletResponse response) {

		ServletOutputStream pw = null;
		String organId = UserUtils.getUser().getOfficeId();
		String flag = "0";
		advertisement.setOrganId(organId);
		advertisement.setAdEndTime(new Date());
		advertisement.setAdStartTime(new Date());
		List<Advertisement> record = advertisementService.findListAdvertisementCount(advertisement);
		int length = record.size();
		if (length >= 3) {
			flag = "1";
		}
		try {
			pw = response.getOutputStream();
			pw.write(flag.getBytes("utf-8"));
			pw.flush();
			pw.close();
		} catch (IOException e) {

		}

		return flag;
	}

	@RefreshCSRFToken
	@ResponseBody
	@RequestMapping(value = "advertisementValidator")
	public String advertisementValidator(Advertisement advertisement, HttpServletRequest request,
			HttpServletResponse response) {

		ServletOutputStream pw = null;
		String flag = null;
		Advertisement record = advertisementService.selectByAdId(advertisement);
		if (record != null) {
			flag = record.getAdStatus();
			try {
				pw = response.getOutputStream();
				pw.write(flag.getBytes("utf-8"));
				pw.flush();
				pw.close();
			} catch (IOException e) {

			}
		}

		return flag;
	}

	/**
	 * 验证广告发布开始时间和结束时间是否在五年范围内
	 * 
	 * @param adStartTime
	 * @param adEndTime
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "checkDate")
	public Map<String, Boolean> checkDate(String adStartTime, String adEndTime) {
		Map<String, Boolean> map = new HashMap<>();

		String limitDate = DateTimeUtil.addYears(adStartTime, 5);
		// String limitDate = DateTimeUtil.addMonth(adStartTime, 60);
		int limitSize = limitDate.compareTo(adEndTime);
		if (limitSize > 0) {
			map.put("valid", true);
		} else {
			map.put("valid", false);
		}
		/*
		 * Boolean ffBoolean = validAdName(oldAdName, adName); map.put("valid",
		 * validAdName(oldAdName, adName));
		 */
		return map;
	}

	/**
	 * 验证登录名是否有效
	 * 
	 * @param oldAdName
	 * @param adName
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "checkAdName")
	public Map<String, Boolean> checkAdName(String oldAdName, String adName) {
		Map<String, Boolean> map = new HashMap<>();
		map.put("valid", validAdName(oldAdName, adName));
		return map;
	}

	/**
	 * 检查广告名称是否重复
	 * 
	 * @param oldLoginName
	 * @param loginName
	 * @return
	 */
	public Boolean validAdName(String oldAdName, String adName) {
		if (adName != null) {
			if (StringUtils.equals(adName, oldAdName)) {
				return true;
			}
			Advertisement advertisement = new Advertisement();
			String OfficeId = UserUtils.getUser().getOfficeId();
			advertisement.setOrganId(OfficeId);
			advertisement.setAdName(adName);
			Advertisement record = advertisementService.getAdvertisementByAdName(advertisement);
			if (record == null) {
				return true;
			}
		}
		return false;
	}

	@RequestMapping(value = { "advertisementPass", "" })
	@ResponseBody
	public Result advertisementPass(Advertisement advertisement) {
		String message = "";
		String passFailed = messageSourceUtil.getMessage("sys.advertisement.passFailed");
		String passSuccess = messageSourceUtil.getMessage("sys.advertisement.passSuccess");
		String approvalOpinionNotEmpty = messageSourceUtil.getMessage("sys.advertisement.approvalOpinion.notEmpty");
		try {
			String approvalOpinion = advertisement.getApprovalOpinion();
			if (StringUtils.isEmpty(approvalOpinion)) {
				message = approvalOpinionNotEmpty;
				return ResultGenerator.genFailResult(message);
			}
			message = passSuccess;
			advertisement.setApprovalStatus(DictConstant.AdvertisementStatus.ALREADY_DOWNLINE);
			advertisementService.updateAdvertisementApprovalStatus(advertisement);
		} catch (Exception e) {
			message = passFailed;
			return ResultGenerator.genFailResult(message);
		}
		return ResultGenerator.genSuccessResult(message);
	}

	@RequestMapping(value = { "advertisementNotPass", "" })
	@ResponseBody
	public Result advertisementNotPass(Advertisement advertisement) {

		String message = "";
		String passFailed = messageSourceUtil.getMessage("sys.advertisement.passFailed");
		String notPassSuccess = messageSourceUtil.getMessage("sys.advertisement.notPassSuccess");
		String approvalOpinionNotEmpty = messageSourceUtil.getMessage("sys.advertisement.approvalOpinion.notEmpty");
		try {
			String approvalOpinion = advertisement.getApprovalOpinion();
			if (StringUtils.isEmpty(approvalOpinion)) {
				message = approvalOpinionNotEmpty;
				return ResultGenerator.genFailResult(message);
			}
			message = notPassSuccess;
			advertisement.setApprovalStatus(DictConstant.AdvertisementStatus.ALREADY_REFUSED);
			advertisementService.updateAdvertisementApprovalStatus(advertisement);
		} catch (Exception e) {
			message = passFailed;
			return ResultGenerator.genFailResult(message);
		}
		return ResultGenerator.genSuccessResult(message);
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
		Advertisement advertisement = advertisementService.selectAdvertisementByPrimaryKey(aId);
		return UploadUtil.getPreivewSettings(advertisement.getAdImg(), "您沒有上传广告图片！");
	}

	private boolean fileUpload(File file, String path) {
		FtpUtils.setHost(ftpHost);
		FtpUtils.setPassword(ftpPassword);
		FtpUtils.setUsername(ftpUsername);
		return FtpUtils.uploadFtp(file, path);
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

	/**
	 * 获取广告数量
	 * 
	 * @return
	 */
	@RequestMapping(value = "getAdInfoCount")
	public @ResponseBody Result getAdInfoCount() {
		Advertisement ad = new Advertisement();
		ad.setOrganId(UserUtils.getUser().getOfficeId());
		int count = advertisementService.getAdCount(ad);
		return ResultGenerator.genSuccessResult(count);
	}

}
