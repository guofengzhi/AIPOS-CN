package com.jiewen.modules.sys.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.alibaba.fastjson.JSON;
import com.github.pagehelper.PageInfo;
import com.google.common.collect.Lists;
import com.jiewen.jwp.base.config.Global;
import com.jiewen.jwp.base.utils.BeanValidators;
import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.base.web.ParamResult;
import com.jiewen.jwp.base.web.Result;
import com.jiewen.jwp.base.web.ResultGenerator;
import com.jiewen.jwp.common.DateUtils;
import com.jiewen.jwp.common.annotation.RefreshCSRFToken;
import com.jiewen.jwp.common.annotation.VerifyCSRFToken;
import com.jiewen.jwp.common.excel.ExportExcel;
import com.jiewen.jwp.common.excel.ImportExcel;
import com.jiewen.modules.sys.entity.Office;
import com.jiewen.modules.sys.entity.Role;
import com.jiewen.modules.sys.entity.SysUserRole;
import com.jiewen.modules.sys.entity.User;
import com.jiewen.modules.sys.service.SystemService;
import com.jiewen.modules.sys.utils.UserUtils;
import com.jiewen.modules.upload.service.UploaderService;

/**
 * 个人信息Controller
 */
@Controller
@RequestMapping(value = "/developer")
public class DeveloperController extends BaseController {

	@Autowired
	private SystemService systemService;
	
	@Autowired
	private UploaderService uploaderService;

	@ModelAttribute
	public User get(@RequestParam(required = false) String id) {
		if (org.apache.commons.lang3.StringUtils.isNotBlank(id)) {
			return systemService.getUser(id);
		} else {
			return new User();
		}
	}

	@RequiresPermissions("developer:view")
	@RequestMapping(value = { "index" })
	public String index(User user, Model model) {
		user = UserUtils.getUser();
		model.addAttribute("user", user);
		return "modules/sys/developer";
	}

    @RequestMapping(value ={"selectUser"})
    @ResponseBody
    public User selectUser(@RequestParam(required = false) String id) {
	  
    	User user = new User();
        if (org.apache.commons.lang3.StringUtils.isNotBlank(id)) {
        	user = systemService.getUser(id);
        	user.setSysUserRoleList(systemService.findUserRoleList(user));
        }
        return user;
    }
	   
	@RequiresPermissions("sys:user:edit")
	@RequestMapping(value = "save")
	@VerifyCSRFToken
	public @ResponseBody Result save(User user, HttpServletRequest request, Model model) {
		user.setOffice(new Office(request.getParameter("officeId")));
		if (!beanValidator(model, user)) {
			return ResultGenerator.genFailResult((String) model.asMap().get("message"));
		}
		if (!validLoginName(user.getOldLoginName(), user.getLoginName())) {
			String saveUser = messageSourceUtil.getMessage("sys.user.promt.save");
			String saveUserFailed = messageSourceUtil.getMessage("sys.user.promt.save.failed");
			return ResultGenerator.genFailResult(saveUser + user.getLoginName() + saveUserFailed);
		}
		// 保存用户信息
		user.setCompanyId(request.getParameter("officeId"));
		systemService.saveUser(user);
		// 清除当前用户缓存
		if (user.getLoginName().equals(UserUtils.getUser().getLoginName())) {
			UserUtils.clearCache();
		}
		return ResultGenerator.genSuccessResult();
	}

	@RequiresPermissions("sys:user:edit")
	@RequestMapping(value = "delete")
	@ResponseBody
	public Result delete(String id) {
		String message = "";
		String deleteCurrentFailed = messageSourceUtil.getMessage("sys.user.promt.delete.current.failed");
		String deleteSuperFailed = messageSourceUtil.getMessage("sys.user.promt.delete.super.failed");
		String deleteSuccess = messageSourceUtil.getMessage("sys.user.promt.delete.success");
		if (UserUtils.getUser().getId().equals(id)) {
			message = deleteCurrentFailed;
			return ResultGenerator.genFailResult(message);
		} else if (User.isAdmin(id)) {
			message = deleteSuperFailed;
			return ResultGenerator.genFailResult(message);
		} else {
			systemService.deleteUser(id);
			message = deleteSuccess;
			return ResultGenerator.genSuccessResult(message);
		}
	}

	/**
	 * 用户选择
	 * 
	 * @return
	 */
	@RequestMapping(value = { "selectUserRole" })
	private String select(String roleId, Model model) {
		model.addAttribute("roleId", roleId);
		return "modules/sys/userrole_select";
	}
	
	/**
	 * 角色选择
	 * 
	 * @return
	 */
	@RequestMapping(value = { "selectRole" })
	private String selectRole(String userId, Model model) {
		model.addAttribute("userId", userId);
		return "modules/sys/user_selectRole";
	}
	
	
	/**
	 * 根据查询角色
	 * 
	 * @param reqObj
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = { "findRoleList" })
	public @ResponseBody Map<String, Object> findRoleList(String reqObj , 
			String selectedType , String userId , String addAndUpdate)
			throws Exception {
		Role role =  new ParamResult<Role>(reqObj).getEntity(Role.class);
		if(addAndUpdate.equals("add")){ // 新增
			   // 查询系统下的所有角色 左侧列表查询数据
			    role.setSelectedType(selectedType);
			    role.setAddAndUpdate(addAndUpdate);
		        return resultMap(role, systemService.findRoleList(role));
		}else{ //修改
			User user = new User();
			user.setId(userId);
			role.setUser(user);
			role.setSelectedType(selectedType);
			return resultMap(role, systemService.findRoleList(role));	
		}
	}
	
	
	/**
	 * 根据角色Id查询该角色下的用户
	 * 
	 * @param reqObj
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = { "findRoleUserList" })
	public @ResponseBody Map<String, Object> findRoleUserList(String reqObj, String selectedType, String roleId)
			throws Exception {
		User user = new ParamResult<User>(reqObj).getEntity(User.class);
		SysUserRole sysUserRole = new SysUserRole();
		if (selectedType.equals("3")) {
			sysUserRole.setSelectedType("2");
			sysUserRole.setRoleId(user.getRoleId());
			user.setSysUserRole(sysUserRole);
		} else {
			sysUserRole.setSelectedType(selectedType);
			sysUserRole.setRoleId(roleId);
			user.setSysUserRole(sysUserRole);
		}
		return resultMap(user, systemService.findRoleUserList(user));
	}

	/**
	 * 
	 * @param userId
	 * @param roleId
	 * @return
	 */
	@RequestMapping(value = "deleteUR")
	@ResponseBody
	public Result deleteUserRoleA(String userId, String roleId) {
		String message = "";
		String deleteSuccess = messageSourceUtil.getMessage("sys.user.promt.delete.success");
		Role role = new Role();
		role.setId(roleId);
		User user = new User();
		user.setId(userId);
		user.setRole(role);
		if (null != roleId && !"".equals(roleId) && null != userId && !"".equals(userId)) {
			systemService.deleteUserRoleA(user);
			message = deleteSuccess;
			return ResultGenerator.genSuccessResult(message);
		} else {
			return ResultGenerator.genFailResult(messageSourceUtil.getMessage("common.userIdAndroleIdNotEmpty"));

		}
	}

	/**
	 * 角色用户表中批量删除与添加用户
	 */
	@RequestMapping(value = "insertUserRoleAddDelete")
	@ResponseBody
	public Result insertUserRoleAddDelete(String urlist, String flag) {
		String newJson = StringEscapeUtils.unescapeHtml4(urlist);
		List<SysUserRole> urs = JSON.parseArray(newJson, SysUserRole.class);
		if (flag.equals("add")) {
			User user = new User();
			user.setSysUserRoleList(urs);
			if (null != urs && null != user.getSysUserRoleList() && user.getSysUserRoleList().size() > 0) {
				systemService.insertUserRoleA(user);
				return ResultGenerator.genSuccessResult(messageSourceUtil.getMessage("common.AddSuccess"));
			} else {
				return ResultGenerator.genFailResult(messageSourceUtil.getMessage("common.PleaseUserAdd"));
			}
		} else {
			boolean dFlag = true;
			for (int i = 0; i < urs.size(); i++) {
				SysUserRole sy = urs.get(i);
				User user = new User();
				user.setId(sy.getUserId());
				Role role = new Role();
				role.setId(sy.getRoleId());
				user.setRole(role);
				systemService.deleteUserRoleA(user);

			}
			return ResultGenerator.genSuccessResult(messageSourceUtil.getMessage("common.deleteSuccess"));
		}

	}

	/**
	 * 导出用户数据
	 * 
	 * @param user
	 * @param request
	 * @param response
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("sys:user:view")
	@RequestMapping(value = "export", method = RequestMethod.POST)
	public String exportFile(User user, HttpServletRequest request, HttpServletResponse response,
			RedirectAttributes redirectAttributes) {
		String userData = messageSourceUtil.getMessage("sys.user.promt.data");
		String exportFailed = messageSourceUtil.getMessage("sys.user.promt.export.failed");
		try {
			String fileName = userData + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";
			PageInfo<User> page = systemService.findPage(user);
			new ExportExcel(userData, User.class).setDataList(page.getList()).write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, exportFailed + e.getMessage());
		}
		return "redirect:" + "/sys/user/list?repage";
	}

	/**
	 * 导入用户数据
	 * 
	 * @param file
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("sys:user:edit")
	@RequestMapping(value = "import", method = RequestMethod.POST)
	public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		String importFailed = messageSourceUtil.getMessage("sys.user.promt.import.failed");
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<User> list = ei.getDataList(User.class);

			String loginName = messageSourceUtil.getMessage("sys.user.login.name");
			String existed = messageSourceUtil.getMessage("sys.user.promt.existed");
			String importFail = messageSourceUtil.getMessage("sys.user.promt.import.fail");
			String importSuccess = messageSourceUtil.getMessage("sys.user.promt.import.success");
			String fail = messageSourceUtil.getMessage("common.sys.failure");
			String userNumber = messageSourceUtil.getMessage("sys.user.promt.number");
			for (User user : list) {
				try {
					if ("true".equals(checkLoginName("", user.getLoginName()))) {
						user.setPassword(SystemService.encryptPassword("123456"));
						BeanValidators.validateWithException(validator, user);
						systemService.saveUser(user);
						successNum++;
					} else {
						failureMsg.append("<br/>" + loginName + user.getLoginName() + existed);
						failureNum++;
					}
				} catch (ConstraintViolationException ex) {
					failureMsg.append("<br/>" + loginName + user.getLoginName() + importFail);
					List<String> messageList = BeanValidators.extractPropertyAndMessageAsList(ex, ": ");
					for (String message : messageList) {
						failureMsg.append(message + "; ");
						failureNum++;
					}
				} catch (Exception ex) {
					failureMsg.append("<br/>" + loginName + user.getLoginName() + importFail + ex.getMessage());
				}
			}
			if (failureNum > 0) {
				failureMsg.insert(0, "，" + fail + failureNum + userNumber);
			}
			addMessage(redirectAttributes, importSuccess + successNum + userNumber + failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, importFailed + e.getMessage());
		}
		return "redirect:" + "/sys/user/list?repage";
	}

	/**
	 * 下载导入用户数据模板
	 * 
	 * @param response
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("sys:user:view")
	@RequestMapping(value = "import/template")
	public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		String userData = messageSourceUtil.getMessage("sys.user.promt.data");
		String templateFailed = messageSourceUtil.getMessage("sys.user.import.template.failed");
		try {
			String fileName = messageSourceUtil.getMessage("sys.user.import.template.name");
			List<User> list = Lists.newArrayList();
			list.add(UserUtils.getUser());
			new ExportExcel(userData, User.class, 2).setDataList(list).write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, templateFailed + e.getMessage());
		}
		return "redirect:" + "/sys/user/list?repage";
	}

	/**
	 * 验证登录名是否有效
	 * 
	 * @param oldLoginName
	 * @param loginName
	 * @return
	 */
	@ResponseBody
	@RequiresPermissions("sys:user:edit")
	@RequestMapping(value = "checkLoginName")
	public Map<String, Boolean> checkLoginName(String oldLoginName, String loginName) {
		Map<String, Boolean> map = new HashMap<>();
		map.put("valid", validLoginName(oldLoginName, loginName));
		return map;
	}

	/**
	 * 检查用户名是否重复
	 * 
	 * @param oldLoginName
	 * @param loginName
	 * @return
	 */
	public Boolean validLoginName(String oldLoginName, String loginName) {
		if (loginName != null) {
			if (loginName.equals(oldLoginName)) {
				return true;
			}
			if (systemService.getUserByLoginName(loginName) == null) {
				return true;
			}
		}
		return false;

	}

	/**
	 * 用户信息显示及保存
	 * 
	 * @param user
	 * @param model
	 * @return
	 */
	@RequiresPermissions("user")
	@RequestMapping(value = "info")
	public String info(User user, HttpServletResponse response, Model model) {
		User currentUser = UserUtils.getUser();
		String saveSuccess = messageSourceUtil.getMessage("sys.user.promt.save.success");
		if (org.apache.commons.lang3.StringUtils.isNotBlank(user.getName())) {
			currentUser.setEmail(user.getEmail());
			currentUser.setPhone(user.getPhone());
			currentUser.setMobile(user.getMobile());
			currentUser.setRemarks(user.getRemarks());
			currentUser.setPhoto(user.getPhoto());
			systemService.updateUserInfo(currentUser);
			model.addAttribute("message", saveSuccess);
		}
		model.addAttribute("user", currentUser);
		model.addAttribute("Global", Global.getInstance());
		return "modules/sys/userInfo";
	}

	/**
	 * 返回用户信息
	 * 
	 * @return
	 */
	@RequiresPermissions("user")
	@RequestMapping(value = "infoData")
	public String infoData() {
		return "modules/sys/modifyPwd";
	}

	/**
	 * 返回头像编辑
	 * 
	 * @return
	 */
	@RequiresPermissions("user")
	@RequestMapping(value = "editPhoto")
	public String editPhoto() {
		return "modules/sys/userphoto_edit";
	}

	/**
	 * 修改个人用户密码
	 * 
	 * @param oldPassword
	 * @param newPassword
	 * @param model
	 * @return
	 */
	@RequiresPermissions("user")
	@RequestMapping(value = "modifyPwd")
	public @ResponseBody Result modifyPwd(String password, String newPassword, Model model) {
		User user = UserUtils.getUser();
		String success = messageSourceUtil.getMessage("sys.user.promt.password.success");
		String error = messageSourceUtil.getMessage("sys.user.promt.password.error");
		String empty = messageSourceUtil.getMessage("sys.user.promt.password.empty");
		if (org.apache.commons.lang3.StringUtils.isNotBlank(password)
				&& org.apache.commons.lang3.StringUtils.isNotBlank(newPassword)) {
			if (SystemService.validatePassword(password, user.getPassword())) {
				systemService.updatePasswordById(user.getId(), user.getLoginName(), newPassword);
				return ResultGenerator.genSuccessResult(success);
			} else {
				return ResultGenerator.genFailResult(error);
			}
		} else {
			return ResultGenerator.genFailResult(empty);
		}
	}

	/**
	 * 查询所有机构
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping(value = { "findAllOffice" })
	@ResponseBody
	public String findAllOffice(User user, Model model) {
		String jsonString = JSON.toJSONString(UserUtils.getOfficeAllList());
		return jsonString;

	}

	@RefreshCSRFToken
	@RequiresPermissions("sys:user:view")
	@RequestMapping(value = "formAdd")
	public Model formAdd(User user, Model model) {
		if (user.getOffice() == null || user.getOffice().getId() == null) {
			user.setOffice(UserUtils.getUser().getOffice());
		}
		model.addAttribute("user", user);
		model.addAttribute("allRoles", systemService.findAllRole());
		return model;
	}

	
}
