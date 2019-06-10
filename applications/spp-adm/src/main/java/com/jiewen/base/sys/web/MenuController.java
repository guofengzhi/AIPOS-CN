
package com.jiewen.base.sys.web;

import java.util.List;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.jiewen.base.core.entity.TreeNode;
import com.jiewen.base.core.web.BaseController;
import com.jiewen.base.core.web.Result;
import com.jiewen.base.core.web.ResultGenerator;
import com.jiewen.base.sys.entity.Menu;
import com.jiewen.base.sys.service.SystemService;
import com.jiewen.base.sys.utils.UserUtils;
import com.jiewen.jwp.common.utils.StringUtils;

/**
 * 菜单Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/menu")
public class MenuController extends BaseController {

    @Autowired
    private SystemService systemService;

    @ResponseBody
    @RequestMapping(value = "get")
    public Menu get(@RequestParam(required = false) String id) {
        Menu menu = new Menu();
        if (StringUtils.isNotBlank(id)) {
            menu = systemService.getMenu(id);
        }
        UserUtils.spiltName(menu);
        return menu;
    }

    @RequiresPermissions("sys:menu:edit")
    @RequestMapping(value = "save")
    @ResponseBody
    public Result save(Menu menu, Model model) {
        String authority = messageSourceUtil.getMessage("sys.menu.promt.authority");
        String menuSave = messageSourceUtil.getMessage("sys.menu.promt.menuSave");
        String success = messageSourceUtil.getMessage("sys.menu.promt.success");
        if (!UserUtils.getUser().isAdmin()) {
            return ResultGenerator.genFailResult(authority);
        }
        if (!beanValidator(model, menu)) {
            return ResultGenerator.genFailResult((String) model.asMap().get("message"));
        } else {
            systemService.saveMenu(menu);
            return ResultGenerator.genSuccessResult(menuSave + menu.getName() + success);
        }
    }

    @RequiresPermissions("sys:menu:edit")
    @RequestMapping(value = "delete")
    @ResponseBody
    public Result delete(Menu menu) {
        systemService.deleteMenu(menu);
        String menuDelete = messageSourceUtil.getMessage("sys.menu.promt.menuDelete");
        String success = messageSourceUtil.getMessage("sys.menu.promt.success");
        return ResultGenerator.genSuccessResult(menuDelete + menu.getName() + success);
    }

    @RequiresPermissions("user")
    @RequestMapping(value = "index")
    public String index() {
        return "modules/sys/menuIndex";
    }

    /**
     * isShowHide是否显示隐藏菜单
     * 
     * @param extId
     * @param isShowHidden
     * @param response
     * @return
     */
    @RequiresPermissions("user")
    @ResponseBody
    @RequestMapping(value = "/treeData", method = RequestMethod.POST)
    public List<TreeNode> treeData() {
        return systemService.getTreeData();
    }
}
