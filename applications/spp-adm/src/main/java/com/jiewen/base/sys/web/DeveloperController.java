
package com.jiewen.base.sys.web;

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
import com.jiewen.base.core.web.BaseController;
import com.jiewen.base.core.web.ParamResult;
import com.jiewen.base.core.web.Result;
import com.jiewen.base.core.web.ResultGenerator;
import com.jiewen.base.sys.entity.Office;
import com.jiewen.base.sys.entity.Role;
import com.jiewen.base.sys.entity.User;
import com.jiewen.base.sys.service.DeveloperService;
import com.jiewen.base.sys.service.OfficeService;
import com.jiewen.base.sys.service.SystemService;
import com.jiewen.base.sys.utils.UserUtils;
import com.jiewen.jwp.common.utils.StringUtils;
import com.jiewen.jwp.common.utils.csrf.annotation.RefreshCSRFToken;
import com.jiewen.jwp.common.utils.csrf.annotation.VerifyCSRFToken;

/**
 * 开发者Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/developer")
public class DeveloperController extends BaseController {

	@Autowired
    private SystemService systemService;
	
    @Autowired
    private DeveloperService developerService;
    
    @ModelAttribute
    public User get(@RequestParam(required = false) String id) {
        if (StringUtils.isNotBlank(id)) {
            return systemService.getUser(id);
        } else {
            return new User();
        }
    }

    @RequiresPermissions("sys:developer:view")
    @RequestMapping(value = { "index" })
    public String index(User user, Model model) {
    	return "modules/sys/developerList";
    }

    @RequiresPermissions("sys:developer:view")
    @RequestMapping(value = { "list", "" })
    public @ResponseBody Map<String, Object> list(String reqObj) throws Exception {
        User user = new ParamResult<User>(reqObj).getEntity(User.class);
        return resultMap(user, developerService.findPage(user));
    }

    @RefreshCSRFToken
    @RequiresPermissions("sys:developer:view")
    @RequestMapping(value = "form")
    public String form(User user, Model model) {
        model.addAttribute("user", user);
        return "modules/sys/developerForm";
    }

    @RequiresPermissions("sys:developer:edit")
    @RequestMapping(value = "save")
    @VerifyCSRFToken
    public @ResponseBody Result save(User user, HttpServletRequest request, Model model) {
    		
        if (!beanValidator(model, user)) {
            return ResultGenerator.genFailResult((String) model.asMap().get("message"));
        }
        if (!validLoginName(user.getOldLoginName(), user.getLoginName())) {
            String saveUser = messageSourceUtil.getMessage("sys.user.promt.save");
            String saveUserFailed = messageSourceUtil.getMessage("sys.user.promt.save.failed");
            return ResultGenerator.genFailResult(saveUser + user.getLoginName() + saveUserFailed);
        }
        // 保存开发者信息
        developerService.saveUser(user);
        // 清除当前用户缓存
        if (user.getLoginName().equals(UserUtils.getUser().getLoginName())) {
            UserUtils.clearCache();
        }

        return ResultGenerator.genSuccessResult();
    }

    @RequiresPermissions("sys:developer:edit")
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

}
