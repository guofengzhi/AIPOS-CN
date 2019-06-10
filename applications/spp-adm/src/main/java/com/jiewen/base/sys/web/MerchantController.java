
package com.jiewen.base.sys.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.github.pagehelper.PageInfo;
import com.jiewen.base.common.constant.Constant;
import com.jiewen.base.core.web.BaseController;
import com.jiewen.base.core.web.ParamResult;
import com.jiewen.base.core.web.Result;
import com.jiewen.base.core.web.ResultGenerator;
import com.jiewen.base.sys.entity.DeviceMerchant;
import com.jiewen.base.sys.entity.Merchant;
import com.jiewen.base.sys.entity.Office;
import com.jiewen.base.sys.service.OfficeService;
import com.jiewen.base.sys.service.SystemService;
import com.jiewen.base.sys.utils.UserUtils;
import com.jiewen.commons.util.IOUtil;
import com.jiewen.jwp.common.utils.StringUtils;
import com.jiewen.jwp.common.utils.csrf.annotation.RefreshCSRFToken;
import com.jiewen.jwp.common.utils.csrf.annotation.VerifyCSRFToken;
import com.jiewen.spp.modules.device.entity.Device;

/**
 * 商户Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/merchant")
public class MerchantController extends BaseController {

	private static final String CN = "cn";
	
	@Autowired
	private SystemService systemService;
	
	@Autowired
	private OfficeService officeService;

	@RequiresPermissions("sys:merchant:view")
	@RequestMapping(value = { "index" })
	public String index(Merchant merchant, Model model) {
		return "modules/sys/merchantList";
	}

	@RequiresPermissions("sys:merchant:view")
	@RequestMapping(value = { "list", "" })
	public @ResponseBody Map<String, Object> list(String reqObj) throws Exception {
		Merchant merchant = new ParamResult<Merchant>(reqObj).getEntity(Merchant.class);
		String orgId = merchant.getOrgId();
		if(StringUtils.isEmpty(orgId)||StringUtils.equals("0", orgId)){
			orgId = UserUtils.getUser().getOfficeId();
			merchant.setOrgId(orgId);
		}
		PageInfo<Merchant> findMerchantPage = systemService.findMerchantPage(merchant);
		return resultMap(merchant, findMerchantPage);
	}
	
	@RequiresPermissions("sys:merchant:view")
	@RequestMapping(value = "merchants")
	public @ResponseBody Result merchants(String reqObj,HttpServletRequest request) throws Exception {
		String orgId = request.getParameter("orgId");
		Merchant merchant = new Merchant();
		merchant.setOrgId(orgId);
		List<Merchant> allMerchant = systemService.getAllMerchant(merchant);
		return ResultGenerator.genSuccessResult(allMerchant);
	}

	@RequiresPermissions("sys:merchant:view")
	@RequestMapping(value = "boundTermList")
	public @ResponseBody Map<String, Object> boundTermList(String reqObj, HttpServletRequest reqeust) throws Exception {
		String officeId = UserUtils.getUser().getOfficeId();
		PageInfo<DeviceMerchant> findDeviceMerchantPage = null;
		DeviceMerchant deviceMerchant = new ParamResult<DeviceMerchant>(reqObj).getEntity(DeviceMerchant.class);
		deviceMerchant.setOrgId(officeId);
		String boundState = deviceMerchant.getBoundState();
		if (StringUtils.equals(boundState, "0")) {
			findDeviceMerchantPage = systemService.findDeviceUnBoundPage(deviceMerchant);
		} else if (StringUtils.equals(boundState, "1")) {
			findDeviceMerchantPage = systemService.findDeviceMerchantPage(deviceMerchant);
		} else {
			findDeviceMerchantPage = systemService.boundAndUnBound(deviceMerchant);
		}
		return resultMap(deviceMerchant, findDeviceMerchantPage);
	}

	@RefreshCSRFToken
	@RequiresPermissions("sys:merchant:view")
	@RequestMapping(value = "form")
	public String form(Merchant merchant, Model model, HttpServletRequest request) {
		String id = request.getParameter("id");
		String updateflag = "false";
		if (StringUtils.isNotEmpty(id)) {
			updateflag = "true";
			merchant = systemService.getMerchantById(id);
		}
		Office officeParam = new Office();
		officeParam.setId(merchant.getOrgId());
		Office office = officeService.getOffice(officeParam);
		if (office != null) {
			merchant.setOrgName(office.getName());
		}
		model.addAttribute("updateflag", updateflag);
		model.addAttribute("id", id);
		model.addAttribute("merchant", merchant);
		if(StringUtils.isNotEmpty(mapType)){
			if(StringUtils.equals(mapType, "google")){
				return "modules/sys/merchantFormEn";
			}
		}
		return "modules/sys/merchantForm";
	}
	@ResponseBody
	@RequiresPermissions("sys:merchant:view")
	@RequestMapping(value = "baiduMap")
	public String baiduMap(Merchant merchant, Model model, HttpServletRequest request) {
		return "common/baiduMap";
	}


	@RequiresPermissions("sys:merchant:edit")
	@RequestMapping(value = "add")
	@VerifyCSRFToken
	public @ResponseBody Result addMerchant(Merchant merchant, Model model) {
		if (merchant != null && StringUtils.isNotEmpty(merchant.getMerId())
				&& StringUtils.isNotEmpty(merchant.getOrgId())) {
			systemService.addMerchant(merchant);
		}
		return ResultGenerator.genSuccessResult();
	}

	@ResponseBody
	@RequiresPermissions("sys:merchant:edit")
	@RequestMapping(value = "checkMerId")
	public Map<String, Boolean> checkMerId(String merId) {
		Merchant merchant = systemService.getMerchantByMerId(merId);
		Map<String, Boolean> map = new HashMap<String, Boolean>();
		boolean valid = false;
		if (merchant == null) {
			valid = true;
		}
		map.put("valid", valid);
		return map;
	}

	@RequiresPermissions("sys:merchant:edit")
	@RequestMapping(value = "update")
	@VerifyCSRFToken
	public @ResponseBody Result updateMerchant(Merchant merchant, Model model, HttpServletRequest request) {
		String id = request.getParameter("id");
		merchant.setId(id);
		systemService.updateMerchant(merchant);
		return ResultGenerator.genSuccessResult();
	}

	@RequiresPermissions("sys:merchant:edit")
	@RequestMapping(value = "boundOneTerm")
	@VerifyCSRFToken
	public @ResponseBody Result boundOneTerm(Model model, HttpServletRequest request) {
		String merId = request.getParameter("merId");
		String sn = request.getParameter("sn");
		if (StringUtils.isEmpty(sn)) {
			return ResultGenerator.genFailResult("sn号为空");
		}
		if (StringUtils.isEmpty(merId)) {
			return ResultGenerator.genFailResult("商户号为空");
		}
		systemService.boundOneTerm(merId, sn, null);
		return ResultGenerator.genSuccessResult();
	}

	@RequiresPermissions("sys:merchant:edit")
	@RequestMapping(value = "batchBoundTerm")
	@VerifyCSRFToken
	public @ResponseBody Result batchBoundTerm(Model model, HttpServletRequest request) {
		String merId = request.getParameter("merId");
		String sn = request.getParameter("sn");
		if (StringUtils.isEmpty(sn)) {
			return ResultGenerator.genFailResult("sn号为空");
		}
		if (StringUtils.isEmpty(merId)) {
			return ResultGenerator.genFailResult("商户号为空");
		}
		systemService.boundOneTerm(merId, sn, null);
		return ResultGenerator.genSuccessResult();
	}

	@RequiresPermissions("sys:merchant:edit")
	@RequestMapping(value = "delete")
	@ResponseBody
	public Result delete(String id) {
		systemService.deleteMerchant(id);
		String deleteSuccess = messageSourceUtil.getMessage("sys.merchant.promt.delete.success");
		return ResultGenerator.genSuccessResult(deleteSuccess);
	}

	@RefreshCSRFToken
	@RequiresPermissions("sys:merchant:view")
	@RequestMapping(value = "toBoundTerm")
	public String toBoundTerm(Model model, HttpServletRequest request) {
		String officeId = UserUtils.getUser().getOfficeId();
		Device device = new Device();
		List<Device> unBoundTerms = systemService.getUnBoundTerms(device);
		Merchant merchant = new Merchant();
		merchant.setOrgId(officeId);
		List<Merchant> merchants = systemService.getAllMerchant(merchant);
		model.addAttribute("unBoundTerms", unBoundTerms);
		model.addAttribute("merchants", merchants);
		return "modules/sys/boundTermList";
	}

	@RefreshCSRFToken
	@RequiresPermissions("sys:merchant:view")
	@RequestMapping(value = "toBatchAddMerchant")
	public String toBatchAddMerchant(Model model, HttpServletRequest request) {
		return "modules/sys/batchAddMerchant";
	}

	@RefreshCSRFToken
	@RequiresPermissions("sys:merchant:view")
	@RequestMapping(value = "toBatchBoundTerm")
	public String toBatchBoundTerm(Model model, HttpServletRequest request) {
		return "modules/sys/batchBoundTerm";
	}

	@RefreshCSRFToken
	@RequiresPermissions("sys:merchant:view")
	@RequestMapping(value = "toBatchUnBoundTerm")
	public String toBatchUnBoundTerm(Model model, HttpServletRequest request) {
		return "modules/sys/batchUnBoundTerm";
	}

	@RefreshCSRFToken
	@RequiresPermissions("sys:merchant:edit")
	@RequestMapping(value = "downloadBoundTermTemplate")
	public void downloadBoundTermTemplate(HttpServletRequest request, HttpServletResponse response) {

		String downloadFileError = messageSourceUtil.getMessage("modules.device.download.file.error");
		String fileName = "boundTerm_template.xlsx";
		FileInputStream is = null;
		ServletOutputStream os = null;
		try {
			File file = new ClassPathResource("moudle/templateFile/boundTerm/" + fileName).getFile();
			is = new FileInputStream(file);
			response.reset();
			response.setCharacterEncoding(Constant.CHARACTER_ENCODING_UTF8);
			response.setContentType(Constant.CONTENT_TYPE_VND_EXCEL);
			response.setHeader(Constant.HEADER_CONTENT_DISPOSITION, "attachment; filename=" + fileName);
			os = response.getOutputStream();
			byte[] buffer = new byte[1024];
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

	@RefreshCSRFToken
	@RequiresPermissions("sys:merchant:edit")
	@RequestMapping(value = "downloadUnBoundTermTemplate")
	public void downloadUnBoundTermTemplate(HttpServletRequest request, HttpServletResponse response) {

		String downloadFileError = messageSourceUtil.getMessage("modules.device.download.file.error");
		String fileName = "unBoundTerm_template.xlsx";
		InputStream is = null;
		ServletOutputStream os = null;
		try {
			is = new ClassPathResource("moudle/templateFile/boundTerm/" + fileName).getInputStream();
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

	@RefreshCSRFToken
	@RequiresPermissions("sys:merchant:edit")
	@RequestMapping(value = "downloadMerchantTemplate")
	public void downloadMerchantTemplate(HttpServletRequest request, HttpServletResponse response) {

		String downloadFileError = messageSourceUtil.getMessage("modules.device.download.file.error");
		String fileName = "merchant_template.xlsx";
		InputStream is = null;
		ServletOutputStream os = null;
		try {
			is = new ClassPathResource("moudle/templateFile/merchant/" + fileName).getInputStream();
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
	 * 批量上传设备信息
	 * 
	 * @param file
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("merChantBatchBound")
	public @ResponseBody Result merChantBatchBound(@PathVariable("file") MultipartFile file,
			HttpServletResponse response) {
		String transfinite = messageSourceUtil.getMessage("modules.device.upload.file.transfinite");
		String batchImportSuccess = messageSourceUtil.getMessage("modules.device.batch.import.success");
		if (file.getSize() > 3 * 1024 * 1024) { // 大于1M
			return ResultGenerator.genFailResult(transfinite);
		} else {
			try {
				systemService.uploadBoundFile(file);
			} catch (Exception e) {
				return ResultGenerator.genFailResult(e.getMessage());
			}
		}
		return ResultGenerator.genSuccessResult(batchImportSuccess);
	}

	/**
	 * 批量上传设备信息
	 * 
	 * @param file
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("merchantBatchUnBound")
	public @ResponseBody Result merchantBatchUnBound(@PathVariable("file") MultipartFile file,
			HttpServletResponse response) {
		String transfinite = messageSourceUtil.getMessage("modules.device.upload.file.transfinite");
		String batchImportSuccess = messageSourceUtil.getMessage("modules.device.batch.import.success");
		if (file.getSize() > 3 * 1024 * 1024) { // 大于1M
			return ResultGenerator.genFailResult(transfinite);
		} else {
			try {
				systemService.uploadUnBoundFile(file);
			} catch (Exception e) {
				return ResultGenerator.genFailResult(e.getMessage());
			}
		}
		return ResultGenerator.genSuccessResult(batchImportSuccess);
	}

	/**
	 * 批量上传设备信息
	 * 
	 * @param file
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("batchAddMerchant")
	public @ResponseBody Result batchAddMerchant(@PathVariable("file") MultipartFile file,
			HttpServletResponse response) {
		String transfinite = messageSourceUtil.getMessage("modules.device.upload.file.transfinite");
		String batchImportSuccess = messageSourceUtil.getMessage("modules.device.batch.import.success");
		if (file.getSize() > 3 * 1024 * 1024) { // 大于1M
			return ResultGenerator.genFailResult(transfinite);
		} else {
			try {
				systemService.uploadMerchantFile(file);
			} catch (Exception e) {
				return ResultGenerator.genFailResult(e.getMessage());
			}
		}
		return ResultGenerator.genSuccessResult(batchImportSuccess);
	}

}
