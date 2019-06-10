package com.jiewen.modules.sys.web;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.alibaba.fastjson.JSON;
import com.jiewen.jwp.base.config.Global;
import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.base.web.ParamResult;
import com.jiewen.jwp.base.web.Result;
import com.jiewen.jwp.base.web.ResultGenerator;
import com.jiewen.jwp.common.Collections3;
import com.jiewen.modules.sys.entity.Role;
import com.jiewen.modules.sys.service.SystemService;
import com.jiewen.modules.sys.utils.UserUtils;

/**
 * 角色Controller
 */
@Controller
@RequestMapping(value = "/sys/role")
public class RoleController extends BaseController {

    @Autowired
    private SystemService systemService;
    
    @ModelAttribute("role")
    public Role get(@RequestParam(required = false) String id) {
        if (org.apache.commons.lang3.StringUtils.isNotBlank(id)) {
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
    public @ResponseBody Map<String, Object> list(String reqObj, Role role, Model model) throws Exception {
        Role role2 = new ParamResult<Role>(reqObj).getEntity(Role.class);
        return resultMap(role2, systemService.findPage(role2));
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
    	  String overWeigh = messageSourceUtil.getMessage("sys.role.tip.overWeigh");
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
        if ("true".equals(checkName(role.getOldName(), role.getRoleName()))) {
            return ResultGenerator.genFailResult(saveRole+"'" + role.getRoleName() + "'"+roleNameExists);
        }
        if ("true".equals(checkEnname(role.getOldEnname(), role.getEnname()))) {
            return ResultGenerator.genFailResult(saveRole+"'" + role.getEnname() + "'"+failure+","+ enameExists);
        } else {
            systemService.saveRole(role);
            return ResultGenerator.genSuccessResult(saveRole+"'" + role.getRoleName() + "'"+success);
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
        
    	model.addAttribute("menuIds", Collections3.convertToString(
    			systemService.getRole(role.getId()).getMenuIdList(), ","));
        model.addAttribute("roleId", role.getId());
        model.addAttribute("language", LocaleContextHolder.getLocale().toString());
       
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
        String roleDistMenuSuccess = messageSourceUtil.getMessage("sys.role.tip.roleDistMenuSuccess");
        String menuIds2=Collections3.convertToString(JSON.parseArray(StringEscapeUtils.unescapeHtml4(menuIds)),
            ",");
        role.setMenuIds(menuIds2);
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
    public Map<String, Boolean>  checkName(String oldName, String roleName) {
    	boolean flag= false;
    	Map<String, Boolean> map = new HashMap<>();
        if (roleName != null && roleName.equals(oldName)) {
        	flag=true;
        } else if (roleName != null && systemService.getRoleByName(roleName) == null) {
        	flag=true;
        }
        map.put("valid", flag);
        return map;
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
    public Map<String, Boolean>  checkEnname(String oldEnname, String enname) {
    	boolean flag= false;
    	Map<String, Boolean> map = new HashMap<>();
        if (enname != null && enname.equals(oldEnname)) {
        	flag=true;
        } else if (enname != null && systemService.getRoleByEnname(enname) == null) {
        	flag=true;
        }
        map.put("valid", flag);
        return map;
    }
    
    /**
     * 根据Id查询对象
     * @param id
     * @return
     */
    @RequestMapping(value ={"selectRole"})
    @ResponseBody
    public Role selectRole(@RequestParam(required = false) String id) {
	  
    	Role role = new Role();
        if (org.apache.commons.lang3.StringUtils.isNotBlank(id)) {
        	role.setId(id);
        	role = systemService.getRole(id);
        }
        return role;
    }
    
    /**
     * 角色分配信息
     * 
     * @param role
     * @param model
     * @return
     */
    @RequestMapping(value ={"selectRoleIdAssign"})
    @ResponseBody
    public Role selectRoleIdAssign(Role role, Model model) {
    	
    	role.setMenuIds(Collections3.convertToString(systemService.getRole(role.getId()).getMenuIdList(), ","));
    	role.setLanguage(LocaleContextHolder.getLocale().toString());
        
        return role;
    }
}
