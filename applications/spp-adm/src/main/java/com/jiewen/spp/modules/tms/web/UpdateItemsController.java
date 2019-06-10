package com.jiewen.spp.modules.tms.web;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
import com.jiewen.base.core.web.BaseController;
import com.jiewen.base.core.web.ParamResult;
import com.jiewen.base.core.web.Result;
import com.jiewen.base.core.web.ResultGenerator;
import com.jiewen.base.sys.entity.User;
import com.jiewen.jwp.common.utils.FileUtils;
import com.jiewen.jwp.common.utils.StringUtils;
import com.jiewen.jwp.common.utils.csrf.annotation.RefreshCSRFToken;
import com.jiewen.spp.modules.baseinfo.entity.ManuFacturer;
import com.jiewen.spp.modules.baseinfo.service.ManuFacturerService;
import com.jiewen.spp.modules.tms.entity.UpdateItems;
import com.jiewen.spp.modules.tms.service.UpdateItemsService;
import com.jiewen.spp.modules.upload.entity.FileResult;
import com.jiewen.spp.utils.FtpUtils;
import com.jiewen.spp.utils.UploadUtil;

/**
 * 更新物控制层
 * 
 * @author guofengzhi
 */
@Controller
@RequestMapping(value = "${adminPath}/tms/updateItems")
public class UpdateItemsController extends BaseController {

	private Logger logger = LoggerFactory.getLogger(UpdateItemsController.class);

	@Autowired
	private UpdateItemsService updateItemsService;

	@Autowired
	private ManuFacturerService manuFacturerService;

	@Value("${ftp.tms.path}")
	private String TMS_PATH;

	@ModelAttribute
	public UpdateItems get(@RequestParam(required = false) String id) {
		if (!StringUtils.isBlank(id)) {
			UpdateItems updateItems = new UpdateItems();
			updateItems.setId(id);
			updateItems = updateItemsService.get(updateItems);
			return updateItems;
		} else {
			return new UpdateItems();
		}
	}

	/**
	 * 显示主界面
	 * 
	 * @param model
	 * @return
	 */
	@RequiresPermissions("tms:updateItems:view")
	@RequestMapping(value = { "index" })
	public String index(Model model) {
		List<ManuFacturer> manufacturerList = manuFacturerService.findList();
		model.addAttribute("manufacturerList", manufacturerList);
		return "modules/tms/updateItemsList";
	}

	/**
	 * 条件查询
	 * 
	 * @param reqObj
	 * @return
	 * @throws Exception
	 */
	@RequiresPermissions("tms:updateItems:view")
	@RequestMapping(value = { "list", "" })
	@ResponseBody
	public Map<String, Object> list(String reqObj) throws Exception {
		UpdateItems updateItems = new ParamResult<UpdateItems>(reqObj).getEntity(UpdateItems.class);
		PageInfo<UpdateItems> pageInfo = updateItemsService.findPage(updateItems);
		return resultMap(updateItems, pageInfo);
	}

	/**
	 * 获取所有未被关联的更新物，用于策略界面选择更新物进行关联操作
	 * 
	 * @param reqObj
	 * @return
	 * @throws Exception
	 */
	@RequiresPermissions("tms:updateItems:view")
	@RequestMapping(value = { "notConfigList" })
	@ResponseBody
	public Map<String, Object> notConfigList(String maunNo, String strategyId, String reqObj)
			throws Exception {
		UpdateItems updateItems = new ParamResult<UpdateItems>(reqObj).getEntity(UpdateItems.class);
		updateItems.setManufactureNo(maunNo);
		updateItems.setStrategyId(strategyId);
		PageInfo<UpdateItems> pageInfo = updateItemsService.findNotConfigList(updateItems);
		return resultMap(updateItems, pageInfo);
	}

	/**
	 * 新增/修改 更新物
	 * 
	 * @param updateItems
	 * @param model
	 * @return
	 */
	@RefreshCSRFToken
	@RequiresPermissions("tms:updateItems:edit")
	@RequestMapping(value = "form")
	public String form(@ModelAttribute UpdateItems updateItems, Model model) {
		List<ManuFacturer> manufacturerList = manuFacturerService.findList();
		User user = updateItems.getCurrentUser();
		updateItems.setOrganId(user.getOfficeId());
		model.addAttribute("manufacturerList", manufacturerList);
		model.addAttribute(updateItems);
		return "modules/tms/updateItemsForm";
	}

	/**
	 * 逻辑删除
	 * 
	 * @param updateItems
	 * @return
	 */
	@RequiresPermissions("tms:updateItems:edit")
	@RequestMapping(value = "delete")
	public @ResponseBody Result delete(UpdateItems updateItems) {
		String deleteFail = messageSourceUtil.getMessage("common.deleteFail");
		String deleteSuccess = messageSourceUtil.getMessage("common.deleteSuccess");
		try {
			updateItemsService.deleteById(updateItems);
		} catch (Exception e) {
			logger.error(e.toString());
			return ResultGenerator.genFailResult(deleteFail);
		}
		return ResultGenerator.genSuccessResult(deleteSuccess);
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
	/**
	 * 格式化文件大小
	 * 
	 * @return
	 */
	// private String getFileSize(long fileSize) {
	// DecimalFormat df = new DecimalFormat("0.00");
	// Character unit = 'B';
	// double tempSize = 0.00;
	// if (fileSize >= 1024) {
	// tempSize = Double.valueOf(df.format(Double.valueOf(fileSize)/1024));
	// unit = 'K';
	// if (tempSize >= 1024) {
	// tempSize = Double.valueOf(df.format(Double.valueOf(tempSize)/1024));
	// unit = 'M';
	// if (tempSize >= 1024) {
	// tempSize = Double.valueOf(df.format(Double.valueOf(tempSize)/1024));
	// unit = 'G';
	// }
	// }
	// }
	// return String.valueOf(tempSize) + unit;
	// }

	/**
	 * 获取文件
	 * 
	 * @param fileIds
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "getFiles/{updateItemsId}", method = RequestMethod.POST)
	@ResponseBody
	public FileResult getFiles(@PathVariable("updateItemsId") String updateItemsId,
			HttpServletRequest request) {
		UpdateItems updateItemsById = updateItemsService.get(updateItemsId);
		request.setAttribute("type", "file");
		return UploadUtil.getPreivewSettings(updateItemsById.getFilePath(), "您没有上传更新物文件！");
	}

	@RequiresPermissions("tms:updateItems:edit")
	@RequestMapping(value = "save")
	@ResponseBody
	public Result save(UpdateItems updateItems, @RequestParam("file") MultipartFile file)
			throws Exception {
		String saveSuccess = messageSourceUtil.getMessage("common.saveSuccess");
		String updateSuccess = messageSourceUtil.getMessage("common.updateSuccess");
		File convert = convert(file);

		UpdateItems updateItemsByMerTypeVersion = updateItemsService.findByCondition(updateItems);
		String manufactureNo = updateItems.getManufactureNo();
		String fileType = updateItems.getFileType();
		String fileVersion = updateItems.getFileVersion();

		StringBuffer path = new StringBuffer("/" + TMS_PATH);
		path.append("/" + manufactureNo);
		path.append("/" + fileType);
		path.append("/" + fileVersion + "/");
		boolean dirChangeFlag1 = uploadFtp(convert, path.toString());
		String downloadPath1 = ftpBaseLoadUrl + "/" + convert.getName();
		if (dirChangeFlag1) {
			downloadPath1 = ftpBaseLoadUrl + path.toString() + convert.getName();
		}
		FileUtils.deleteFile(convert.getCanonicalPath());
		updateItems.setFilePath(downloadPath1);
		updateItems.setFileName(convert.getName());
		updateItems.setFileSize(String.valueOf(file.getSize()));
		// long fileSize = file.getSize();
		// updateItems.setFileSize(getFileSize(fileSize));
		if (updateItemsByMerTypeVersion != null && StringUtils.isEmpty(updateItems.getId())) {
			String message = messageSourceUtil.getMessage("modules.baseinfo.model.already.exist");
			return ResultGenerator.genFailResult(message);
		}
		if (StringUtils.isEmpty(updateItems.getId())) {
			User user = updateItems.getCurrentUser();
			updateItems.setOrganId(user.getOfficeId());
			updateItemsService.save(updateItems);
			return ResultGenerator.genSuccessResult(saveSuccess);
		}
		updateItemsService.save(updateItems);
		return ResultGenerator.genSuccessResult(updateSuccess);
	}

}
