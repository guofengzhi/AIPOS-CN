
package com.jiewen.base.sys.web;

import java.util.Map;

import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.alibaba.fastjson.JSON;
import com.jiewen.base.config.Global;
import com.jiewen.base.core.web.BaseController;
import com.jiewen.base.core.web.ParamResult;
import com.jiewen.base.core.web.Result;
import com.jiewen.base.core.web.ResultGenerator;
import com.jiewen.base.sys.entity.Role;
import com.jiewen.base.sys.service.SystemService;
import com.jiewen.base.sys.utils.UserUtils;
import com.jiewen.jwp.common.utils.Collections3;
import com.jiewen.jwp.common.utils.StringUtils;

/**
 * 角色Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/role")
public class RoleController extends BaseController {

	@Autowired
	private SystemService systemService;

	@ModelAttribute("role")
	public Role get(@RequestParam(required = false) String id) {
		if (StringUtils.isNotBlank(id)) {
			return systemService.getRole(id);
		} else {
			return new Role();
		}
	}

	@RequestMapping(value = { "index", "" })
	public String index() {
		return "modules/sys/roleIndex";
	}

	@RequiresPermissions("sys:role:view")
	@RequestMapping(value = { "list", "" })
	public @ResponseBody Map<String, Object> list(String reqObj, Role role, Model model) {
		Role roleVal = new ParamResult<Role>(reqObj).getEntity(Role.class);
		return resultMap(roleVal, systemService.findPage(roleVal));
	}

	@RequiresPermissions("sys:role:view")
	@RequestMapping(value = "form")
	public String form(Role role, Model model) {
		model.addAttribute("role", role);
		return "modules/sys/roleForm";
	}

	@RequiresPermissions("sys:role:edit")
	@RequestMapping(value = "save")
	@ResponseBody
	public Result save(Role role, Model model) {
		String overWeigh = messageSourceUtil.getMessage("sys.role.tip.overWeight");
		if (!UserUtils.getUser().isAdmin() && role.getSysData().equals(Global.YES)) {
			return ResultGenerator.genFailResult(overWeigh);
		}
		if (!beanValidator(model, role)) {
			return ResultGenerator.genFailResult((String) model.asMap().get("message"));
		}
		String saveRole = messageSourceUtil.getMessage("sys.role.tip.saveRole");
		String failure = messageSourceUtil.getMessage("common.sys.failure");
		String roleNameExists = messageSourceUtil.getMessage("sys.role.tip.roleNameExists");
		String enameExists = messageSourceUtil.getMessage("sys.role.tip.enameExists");
		String success = messageSourceUtil.getMessage("common.sys.success");
		if (!"true".equals(checkName(role.getOldName(), role.getName()))) {
			return ResultGenerator.genFailResult(saveRole + "'" + role.getName() + "'" + roleNameExists);
		}
		if (!"true".equals(checkEnname(role.getOldEnname(), role.getEnname()))) {
			return ResultGenerator.genFailResult(saveRole + "'" + role.getName() + "'" + failure + "," + enameExists);

		} else {
			systemService.saveRole(role);
			return ResultGenerator.genSuccessResult(saveRole + "'" + role.getName() + "'" + success);
		}
	}

	@RequiresPermissions("sys:role:edit")
	@RequestMapping(value = "delete")
	@ResponseBody
	public Result delete(Role role, RedirectAttributes redirectAttributes) {
		String deleteRoleSuccess = messageSourceUtil.getMessage("common.deleteSuccess");
		String overWeigh = messageSourceUtil.getMessage("sys.role.tip.overWeigh");
		if (!UserUtils.getUser().isAdmin() && role.getSysData().equals(Global.YES)) {
			return ResultGenerator.genFailResult(overWeigh);
		} else {
			systemService.deleteRole(role);
			return ResultGenerator.genSuccessResult(deleteRoleSuccess);
		}
	}

	/**
	 * 角色分配页面
	 * 
	 * @param role
	 * @param model
	 * @return
	 */
	@RequiresPermissions("sys:role:edit")
	@RequestMapping(value = "assign")
	public String assign(Role role, Model model) {
		model.addAttribute("menuIds",
				Collections3.convertToString(systemService.getRole(role.getId()).getMenuIdList(), ","));
		model.addAttribute("roleId", role.getId());
		return "modules/sys/roleAssign";
	}

	/**
	 * 角色分配任务
	 * 
	 * @param role
	 * @param idsArr
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("sys:role:edit")
	@RequestMapping(value = "assignrole")
	@ResponseBody
	public Result assignRole(String roleId, String menuIds) {
		Role role = new Role(roleId);
		String menuIdsVal = Collections3.convertToString(JSON.parseArray(StringEscapeUtils.unescapeHtml4(menuIds)),
				",");
		String roleDistMenuSuccess = messageSourceUtil.getMessage("sys.role.tip.roleDistMenuSuccess");
		role.setMenuIds(menuIdsVal);
		systemService.assignMenuToRole(role);
		return ResultGenerator.genSuccessResult(roleDistMenuSuccess);
	}

	/**
	 * 验证角色名是否有效
	 * 
	 * @param oldName
	 * @param name
	 * @return
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "checkName")
	public String checkName(String oldName, String name) {
		if (name != null && name.equals(oldName)) {
			return "true";
		} else if (name != null && systemService.getRoleByName(name) == null) {
			return "true";
		}
		return "false";
	}

	/**
	 * 验证角色英文名是否有效
	 * 
	 * @param oldName
	 * @param name
	 * @return
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "checkEnname")
	public String checkEnname(String oldEnname, String enname) {
		if (enname != null && enname.equals(oldEnname)) {
			return "true";
		} else if (enname != null && systemService.getRoleByEnname(enname) == null) {
			return "true";
		}
		return "false";
	}

}
