package com.jiewen.modules.workflow.web;

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
import com.jiewen.commons.util.StringUtil;
import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.base.web.ParamResult;
import com.jiewen.jwp.base.web.Result;
import com.jiewen.jwp.base.web.ResultGenerator;
import com.jiewen.modules.workflow.entity.TblActModule;
import com.jiewen.modules.workflow.service.TblActModuleService;

/**
 * 业务定义Controller
 * 
 * @author Pang.M 2018年1月15日
 *
 */
@Controller
@RequestMapping(value = "/workflow/module")
public class ModuleController extends BaseController {

	@Autowired
	private TblActModuleService tblActModuleService;

	@RequestMapping(value = "/list")
	public String list() {
		return "modules/workflow/module_list";
	}

	@RequiresPermissions("workflow:define:view")
	@RequestMapping(value = "/edit")
	public String form(Model model, TblActModule tblActModule) {
		model.addAttribute("module", tblActModule);
		return "modules/workflow/module_edit";
	}

	@ModelAttribute
	public TblActModule get(@RequestParam(required = false) String id) {
		TblActModule module = new TblActModule();
		if (StringUtil.isNotEmpty(id)) {
			module.setId(id);
			return tblActModuleService.get(module);
		} else {
			return module;
		}
	}

	@RequiresPermissions("workflow:define:edit")
	@RequestMapping(value = "/save")
	@ResponseBody
	public Result save(TblActModule module, Model model) {
		String moduleSave = messageSourceUtil.getMessage("workflow.module.promt.save");
		String success = messageSourceUtil.getMessage("workflow.module.promt.success");
		if (!beanValidator(model, module)) {
			return ResultGenerator.genFailResult((String) model.asMap().get("message"));
		} else {
			tblActModuleService.save(module);
		}
		return ResultGenerator.genSuccessResult(moduleSave + module.getName() + success);
	}

	@RequiresPermissions("workflow:define:edit")
	@RequestMapping(value = "/delete/{id}")
	@ResponseBody
	public Result delete(TblActModule module) {
		try {
			String deleteSuccess = messageSourceUtil.getMessage("workflow.module.promt.del.success");
			tblActModuleService.delete(module);
			return ResultGenerator.genSuccessResult(deleteSuccess);
		} catch (Exception e) {
			String deleteError = messageSourceUtil.getMessage("workflow.module.delete.error.info");
			return ResultGenerator.genFailResult(deleteError);
		}
	}

	@RequestMapping(value = "getByCode/{code}")
	@ResponseBody
	public TblActModule getByCode(@PathVariable("code") String code) {
		return tblActModuleService.getByCode(code);
	}

	@RequiresPermissions("workflow:define:view")
	@RequestMapping(value = "findList")
	public @ResponseBody Map<String, Object> findList(String reqObj) throws Exception {
		TblActModule module = new ParamResult<TblActModule>(reqObj).getEntity(TblActModule.class);
		PageInfo<TblActModule> pageInfo = tblActModuleService.findPage(module);
		return resultMap(module, pageInfo);
	}

}
