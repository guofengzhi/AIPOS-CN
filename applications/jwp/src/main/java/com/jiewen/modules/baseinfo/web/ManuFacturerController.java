package com.jiewen.modules.baseinfo.web;

import java.util.HashMap;
import java.util.Map;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageInfo;
import com.jiewen.base.core.web.Result;
import com.jiewen.base.core.web.ResultGenerator;
import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.base.web.ParamResult;
import com.jiewen.jwp.common.StringUtils;
import com.jiewen.modules.baseinfo.entity.ManuFacturer;
import com.jiewen.modules.baseinfo.service.ManuFacturerService;

@Controller
@RequestMapping("${adminPath}/manuFacturer")
public class ManuFacturerController extends BaseController {

	@Autowired
	private ManuFacturerService manuFacturerService;

	@RequestMapping(value = "index")
	public String index() {
		return "modules/manuFacturer/manuFacturerList";
	}

	@ResponseBody
	@RequiresPermissions("maun:view")
	@RequestMapping(value = "checkManufacturerNo")
	public Map<String, Boolean> checkManufacturerNo(String manufacturerNo) {
		ManuFacturer findManuFacturerByNo = manuFacturerService
				.findManuFacturerByNo(manufacturerNo);
		Map<String, Boolean> map = new HashMap<String, Boolean>();
		boolean valid = false;
		if (findManuFacturerByNo == null) {
			valid = true;
		}
		map.put("valid", valid);
		return map;
	}

	@ModelAttribute
	public ManuFacturer get(@RequestParam(required = false) String id) {
		if (!StringUtils.isBlank(id)) {
			ManuFacturer manuFacturer = new ManuFacturer();
			manuFacturer.setId(id);
			return manuFacturerService.getManuFacturerById(manuFacturer);
		} else {
			return new ManuFacturer();
		}
	}

	@RequiresPermissions("maun:view")
	@RequestMapping(value = { "list", "" })
	@ResponseBody
	public Map<String, Object> list(String reqObj) throws Exception {
		ManuFacturer manuFacturer = new ParamResult<ManuFacturer>(reqObj)
				.getEntity(ManuFacturer.class);
		PageInfo<ManuFacturer> pageInfo = manuFacturerService
				.findPage(manuFacturer);
		return resultMap(manuFacturer, pageInfo);
	}

	@RequiresPermissions("maun:edit")
	@RequestMapping(value = "delete")
	public @ResponseBody
	Result delete(ManuFacturer manuFacturer) {
		String deleteFail = messageSourceUtil.getMessage("common.deleteFail");
		String deleteSuccess = messageSourceUtil
				.getMessage("common.deleteSuccess");
		try {
			manuFacturerService.deleteById(manuFacturer);
		} catch (Exception e) {
			return ResultGenerator.genFailResult(deleteFail);
		}
		return ResultGenerator.genSuccessResult(deleteSuccess);
	}

	/**
	 * 新增修改
	 * 
	 * @param option
	 * @param manuFacturer
	 * @param model
	 * @return
	 */
	@RequiresPermissions("maun:edit")
	@RequestMapping(value = "editOrAdd")
	@ResponseBody
	public ManuFacturer form(String id, Model model) {

		ManuFacturer manuFacturerReturn = new ManuFacturer();
		if (org.apache.commons.lang3.StringUtils.isNotBlank(id)) {
			manuFacturerReturn.setId(id);
			manuFacturerReturn = manuFacturerService.getManuFacturerById(manuFacturerReturn);
		}
		return manuFacturerReturn;
	}

	
	@ResponseBody
	@RequiresPermissions("maun:edit")
	@RequestMapping(value = "checkNameOrNo")
	public Map<String, Boolean> checkNameOrNo(String oldValue, String newValue,String flag) {
		Map<String, Boolean> map = new HashMap<>();
		map =checkManufacturerNoAddOrUpdate(oldValue,newValue,flag);
		return map;
	}
	
	/**
	 * 验证尝试编号或者编号是否存在
	 * @param oldManufacturerNo
	 * @param manufacturerNo
	 * @return
	 */
	public Map<String, Boolean> checkManufacturerNoAddOrUpdate(String oldValue, String newValue,String  flag) {
		
		Map<String, Boolean> map = new HashMap<>();
		
		ManuFacturer findManuFacturerByNo= new ManuFacturer();
		
		if(flag.equals("1")){//校验编号
			findManuFacturerByNo = manuFacturerService.findManuFacturerByNo(newValue);
		}else{//校验名称
			//校验名称
			findManuFacturerByNo = manuFacturerService.findManuFacturerByName(newValue);
		}
		if (findManuFacturerByNo != null) {
			if(oldValue !=null && !"".equals(oldValue)){//修改判断
				if(oldValue.equals(newValue)){//厂商编号未修改，可以插入
					  map.put("valid", true);
				}else{//修改后的厂商编号存在
					map.put("valid", false);
				}
			}else{//新增，并且输入的厂商编号存在
				map.put("valid", false);
			}
		}else{//厂商编号不存在
			    map.put("valid", true);
		}
		return map;
	}
	
	
	@RequiresPermissions("maun:edit")
	@RequestMapping(value = { "save", "" })
	@ResponseBody
	public Result save(ManuFacturer manuFacturer) throws Exception {
		
		String saveSuccess = messageSourceUtil.getMessage("common.saveSuccess");
		String updateSuccess = messageSourceUtil.getMessage("common.updateSuccess");
		
		if (manuFacturer.getId() == null) {
			ManuFacturer findManuFacturerByNo = manuFacturerService.findManuFacturerByNo(manuFacturer.getManufacturerNo());
			if (findManuFacturerByNo != null) {
				String message = messageSourceUtil.getMessage("modules.baseinfo.vendor.sn.exist");
				return ResultGenerator.genFailResult(message);
			}

			ManuFacturer findManuFacturerByName = manuFacturerService.findManuFacturerByName(manuFacturer.getManufacturerName());
			if (findManuFacturerByName != null) {
				String message = messageSourceUtil.getMessage("modules.baseinfo.vendor.name.exist");
				return ResultGenerator.genFailResult(message);
			}

			manuFacturerService.saveManuFacturer(manuFacturer);
			return ResultGenerator.genSuccessResult(saveSuccess);
		}
		manuFacturerService.update(manuFacturer);
		return ResultGenerator.genSuccessResult(updateSuccess);
	}

}
