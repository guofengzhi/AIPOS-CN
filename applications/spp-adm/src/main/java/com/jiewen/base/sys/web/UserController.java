
package com.jiewen.base.sys.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

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

import com.github.pagehelper.PageInfo;
import com.google.common.collect.Lists;
import com.jiewen.base.common.utils.excel.ExportExcel;
import com.jiewen.base.common.utils.excel.ImportExcel;
import com.jiewen.base.common.utils.validator.BeanValidators;
import com.jiewen.base.core.web.BaseController;
import com.jiewen.base.core.web.ParamResult;
import com.jiewen.base.core.web.Result;
import com.jiewen.base.core.web.ResultGenerator;
import com.jiewen.base.sys.entity.Office;
import com.jiewen.base.sys.entity.Role;
import com.jiewen.base.sys.entity.User;
import com.jiewen.base.sys.service.OfficeService;
import com.jiewen.base.sys.service.SystemService;
import com.jiewen.base.sys.utils.UserUtils;
import com.jiewen.jwp.common.utils.DateUtils;
import com.jiewen.jwp.common.utils.StringUtils;
import com.jiewen.jwp.common.utils.csrf.annotation.RefreshCSRFToken;
import com.jiewen.jwp.common.utils.csrf.annotation.VerifyCSRFToken;

/**
 * 用户Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/user")
public class UserController extends BaseController {

    @Autowired
    private SystemService systemService;
    
    @Autowired
    private OfficeService officeService;

    @ModelAttribute
    public User get(@RequestParam(required = false) String id) {
        if (StringUtils.isNotBlank(id)) {
            return systemService.getUser(id);
        } else {
            return new User();
        }
    }

    @RequiresPermissions("sys:user:view")
    @RequestMapping(value = { "index" })
    public String index(User user, Model model) {
        return "modules/sys/userList";
    }

    @RequiresPermissions("sys:user:view")
    @RequestMapping(value = { "list", "" })
    public @ResponseBody Map<String, Object> list(String reqObj) throws Exception {
        User user = new ParamResult<User>(reqObj).getEntity(User.class);
        return resultMap(user, systemService.findPage(user));
    }

    @RefreshCSRFToken
    @RequiresPermissions("sys:user:view")
    @RequestMapping(value = "form")
    public String form(User user, Model model) {
        if (user.getOffice() == null || user.getOffice().getId() == null) {
            user.setOffice(UserUtils.getUser().getOffice());
        }
        Office officeParam = new Office();
        officeParam.setId(user.getOfficeId());
        Office office = officeService.getOffice(officeParam);
        if(office!=null){
        	user.setOfficeName(office.getName());
        }
        model.addAttribute("user", user);
        model.addAttribute("allRoles", systemService.findAllRole());
        return "modules/sys/userForm";
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
        // 角色数据有效性验证，过滤不在授权内的角色
        List<Role> roleList = Lists.newArrayList();
        List<String> roleIdList = user.getRoleIdList();
        for (Role r : systemService.findAllRole()) {
            if (roleIdList.contains(r.getId())) {
                roleList.add(r);
            }
        }
        user.setRoleList(roleList);
        // 保存用户信息
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
        String deleteCurrentFailed = messageSourceUtil
                .getMessage("sys.user.promt.delete.current.failed");
        String deleteSuperFailed = messageSourceUtil
                .getMessage("sys.user.promt.delete.super.failed");
        String deleteSuccess = messageSourceUtil.getMessage("sys.user.promt.delete.success");
        if (UserUtils.getUser().getId().equals(id)) {
            message = deleteCurrentFailed;
            return ResultGenerator.genFailResult(message);
        } else if (User.isAdmin(id)) {
            message = deleteSuperFailed;
            return ResultGenerator.genFailResult(message);
        } else {
            User user = systemService.getUser(id);
            systemService.deleteUser(id);
            message = deleteSuccess;
            UserUtils.clearCache(user);
            return ResultGenerator.genSuccessResult(message);
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
            new ExportExcel(userData, User.class).setDataList(page.getList())
                    .write(response, fileName).dispose();
            return null;
        } catch (Exception e) {
            addMessage(redirectAttributes, exportFailed + e.getMessage());
        }
        return "redirect:" + adminPath + "/sys/user/list?repage";
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
                    if (validLoginName("", user.getLoginName())) {
                        user.setPassword(SystemService.entryptPassword("123456"));
                        BeanValidators.validateWithException(validator, user);
                        systemService.saveUser(user);
                        successNum++;
                    } else {
                        failureMsg.append("<br/>" + loginName + user.getLoginName() + existed);
                        failureNum++;
                    }
                } catch (ConstraintViolationException ex) {
                    failureMsg.append("<br/>" + loginName + user.getLoginName() + importFail);
                    List<String> messageList = BeanValidators.extractPropertyAndMessageAsList(ex,
                            ": ");
                    for (String message : messageList) {
                        failureMsg.append(message + "; ");
                        failureNum++;
                    }
                } catch (Exception ex) {
                    failureMsg.append("<br/>" + loginName + user.getLoginName() + importFail
                            + ex.getMessage());
                }
            }
            if (failureNum > 0) {
                failureMsg.insert(0, "，" + fail + failureNum + userNumber);
            }
            addMessage(redirectAttributes, importSuccess + successNum + userNumber + failureMsg);
        } catch (Exception e) {
            addMessage(redirectAttributes, importFailed + e.getMessage());
        }
        return "redirect:" + adminPath + "/sys/user/list?repage";
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
    public String importFileTemplate(HttpServletResponse response,
            RedirectAttributes redirectAttributes) {
        String userData = messageSourceUtil.getMessage("sys.user.promt.data");
        String templateFailed = messageSourceUtil.getMessage("sys.user.import.template.failed");
        try {
            String fileName = messageSourceUtil.getMessage("sys.user.import.template.name");
            List<User> list = Lists.newArrayList();
            list.add(UserUtils.getUser());
            new ExportExcel(userData, User.class, 2).setDataList(list).write(response, fileName)
                    .dispose();
            return null;
        } catch (Exception e) {
            addMessage(redirectAttributes, templateFailed + e.getMessage());
        }
        return "redirect:" + adminPath + "/sys/user/list?repage";
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
            if (StringUtils.equals(loginName, oldLoginName)) {
                return true;
            }
            User user = systemService.getUserByLoginName(loginName);
            if (user == null) {
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
        if (StringUtils.isNotBlank(user.getName())) {
            currentUser.setEmail(user.getEmail());
            currentUser.setPhone(user.getPhone());
            currentUser.setMobile(user.getMobile());
            currentUser.setRemarks(user.getRemarks());
            currentUser.setPhoto(user.getPhoto());
            systemService.updateUserInfo(currentUser);
            model.addAttribute("message", saveSuccess);
        }
        model.addAttribute("user", currentUser);
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
        if (StringUtils.isNotBlank(password) && StringUtils.isNotBlank(newPassword)) {
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
}
