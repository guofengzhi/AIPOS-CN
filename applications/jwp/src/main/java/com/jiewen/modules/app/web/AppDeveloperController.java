package com.jiewen.modules.app.web;

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
import com.jiewen.jwp.common.annotation.RefreshCSRFToken;
import com.jiewen.modules.app.entity.AppDeveloper;
import com.jiewen.modules.app.service.AppDeveloperService;

@Controller
@RequestMapping("${adminPath}/appDeveloper")
public class AppDeveloperController extends BaseController {

    @Autowired
    private AppDeveloperService appDeveloperService;

    @RequestMapping(value = "index")
    public String index() {
        return "modules/app/developer/appDeveloperList";
    }

    @ModelAttribute
    public AppDeveloper get(@RequestParam(required = false) String id) {
        if (!StringUtils.isBlank(id)) {
            AppDeveloper appDeveloper = new AppDeveloper();
            appDeveloper.setId(id);
            return appDeveloperService.get(appDeveloper);
        } else {
            return new AppDeveloper();
        }
    }

    @RequiresPermissions("app:developer:view")
    @RequestMapping(value = { "list", "" })
    @ResponseBody
    public Map<String, Object> list(String reqObj) throws Exception {
        AppDeveloper appDeveloper = new ParamResult<AppDeveloper>(reqObj)
                .getEntity(AppDeveloper.class);
        PageInfo<AppDeveloper> pageInfo = appDeveloperService.findPage(appDeveloper);
        return resultMap(appDeveloper, pageInfo);
    }

    @RequiresPermissions("app:developer:edit")
    @RequestMapping(value = "delete")
    public @ResponseBody Result delete(AppDeveloper appDeveloper) {
        String deleteFail = messageSourceUtil.getMessage("common.deleteFail");
        String deleteSuccess = messageSourceUtil.getMessage("common.deleteSuccess");
        try {
            appDeveloperService.deleteById(appDeveloper);
        } catch (Exception e) {
            return ResultGenerator.genFailResult(deleteFail);
        }
        return ResultGenerator.genSuccessResult(deleteSuccess);
    }

    @RequiresPermissions("app:developer:edit")
    @RefreshCSRFToken
    @RequestMapping(value = "form/{option}")
    public String form(@PathVariable String option, AppDeveloper appDeveloper, Model model) {
        model.addAttribute("appDeveloper", appDeveloper);
        model.addAttribute("option", option);
        return "modules/app/developer/appDeveloperForm";
    }

    @RequiresPermissions("app:developer:edit")
    @RequestMapping(value = { "save", "" })
    @ResponseBody
    public Result save(AppDeveloper appDeveloper) throws Exception {
        String developerAlreadyExist = messageSourceUtil
                .getMessage("modules.app.developers.already.exist");
        String saveSuccess = messageSourceUtil.getMessage("common.saveSuccess");
        String updateSuccess = messageSourceUtil.getMessage("common.updateSuccess");
        if (appDeveloper.getId() == null) {

            AppDeveloper appDeveloperByName = appDeveloperService
                    .findAppDeveloperByName(appDeveloper.getName());
            if (appDeveloperByName != null) {
                return ResultGenerator.genFailResult(developerAlreadyExist);
            }

            appDeveloperService.saveAppDeveloper(appDeveloper);
            return ResultGenerator.genSuccessResult(saveSuccess);
        }
        appDeveloperService.update(appDeveloper);
        return ResultGenerator.genSuccessResult(updateSuccess);
    }

}
