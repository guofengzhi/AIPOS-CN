package com.jiewen.modules.customer.web;

import java.util.ArrayList;
import java.util.HashMap;
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

import com.google.common.collect.Lists;
import com.jiewen.base.core.web.Result;
import com.jiewen.base.core.web.ResultGenerator;
import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.base.web.ParamResult;
import com.jiewen.jwp.common.StringUtils;
import com.jiewen.jwp.common.annotation.RefreshCSRFToken;
import com.jiewen.jwp.common.annotation.VerifyCSRFToken;
import com.jiewen.modules.customer.service.CustomerUserService;
import com.jiewen.modules.sys.entity.Office;
import com.jiewen.modules.sys.entity.Role;
import com.jiewen.modules.sys.entity.User;
import com.jiewen.modules.sys.service.SystemService;
import com.jiewen.modules.sys.utils.UserUtils;

/**
 * 客户用户Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/customer/user")
public class CustomerUserController extends BaseController {

    @Autowired
    private SystemService systemService;

    @Autowired
    private CustomerUserService customerUserService;

    @ModelAttribute
    public User get(@RequestParam(required = false) String id) {
        if (StringUtils.isNotBlank(id)) {
            return customerUserService.getUser(id);
        } else {
            return new User();
        }
    }

    @RequiresPermissions("sys:cususer:view")
    @RequestMapping(value = { "index" })
    public String index(User user, Model model) {
        return "modules/customer/cusUserList";
    }

    @RequiresPermissions("sys:cususer:view")
    @RequestMapping(value = { "list", "" })
    public @ResponseBody Map<String, Object> list(String reqObj) throws Exception {
        User user = new ParamResult<User>(reqObj).getEntity(User.class);
        User currentUser = UserUtils.getUser();
        user.setOfficeId(currentUser.getOfficeId());
        user.setId(currentUser.getId());
        return resultMap(user, customerUserService.findPage(user));
    }

    @RefreshCSRFToken
    @RequiresPermissions("sys:cususer:view")
    @RequestMapping(value = "form")
    public String form(User user, Model model) {
        User userForm = new User();
        if (user.getClient() == null || user.getClient().getCustomerId() == null) {
            userForm.setClient(UserUtils.getUser().getClient());
        } else {
            userForm = user;
        }
        model.addAttribute("user", userForm);
        // 设置固定客户用户角色
        String customerManager = messageSourceUtil.getMessage("sys.customer.user.manager");
        String customerNormal = messageSourceUtil.getMessage("sys.customer.user.normal");
        List<Role> roleList = new ArrayList<Role>();
        Role manager = new Role();
        manager.setId("8");
        manager.setName(customerManager);
        roleList.add(manager);
        Role normal = new Role();
        normal.setId("9");
        normal.setName(customerNormal);
        roleList.add(normal);
        model.addAttribute("allRoles", roleList);
        return "modules/customer/cusUserForm";
    }

    @RequiresPermissions("sys:cususer:edit")
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
        customerUserService.saveUser(user);
        // 清除当前用户缓存
        if (user.getLoginName().equals(UserUtils.getUser().getLoginName())) {
            UserUtils.clearCache();
        }

        return ResultGenerator.genSuccessResult();
    }

    @RequiresPermissions("sys:cususer:edit")
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
            User user = customerUserService.getUser(id);
            customerUserService.deleteUser(id);
            message = deleteSuccess;
            UserUtils.clearCache(user);
            return ResultGenerator.genSuccessResult(message);
        }
    }

    /**
     * 验证登录名是否有效
     * 
     * @param oldLoginName
     * @param loginName
     * @return
     */
    @ResponseBody
    @RequiresPermissions("sys:cususer:view")
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
    @RequiresPermissions("sys:cususer:view")
    public Boolean validLoginName(String oldLoginName, String loginName) {
        if (loginName != null) {
            if (StringUtils.equals(loginName, oldLoginName)) {
                return true;
            }
            User user = customerUserService.getByLoginName(loginName);
            if (user == null) {
                return true;
            }
        }
        return false;
    }

    /**
     * 返回用户信息
     * 
     * @return
     */
    @RequiresPermissions("user")
    @RequestMapping(value = "infoData")
    public String infoData() {
        return "modules/customer/modifyPwd";
    }

    /**
     * 修改个人用户密码
     * 
     * @param oldPassword
     * @param newPassword
     * @param model
     * @return
     */
    @SuppressWarnings("static-access")
    @RequiresPermissions("user")
    @RequestMapping(value = "modifyPwd")
    public @ResponseBody Result modifyPwd(String password, String newPassword, Model model) {
        User user = UserUtils.getUser();
        String success = messageSourceUtil.getMessage("sys.user.promt.password.success");
        String error = messageSourceUtil.getMessage("sys.user.promt.password.error");
        String empty = messageSourceUtil.getMessage("sys.user.promt.password.empty");
        if (StringUtils.isNotBlank(password) && StringUtils.isNotBlank(newPassword)) {
            if (customerUserService.validatePassword(password, user.getPassword())) {
                customerUserService.updatePasswordById(user.getId(), user.getLoginName(),
                        newPassword);
                return ResultGenerator.genSuccessResult(success);
            } else {
                return ResultGenerator.genFailResult(error);
            }
        } else {
            return ResultGenerator.genFailResult(empty);
        }
    }
}
