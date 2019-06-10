package com.jiewen.modules.sys.web;

import java.util.List;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.jiewen.jwp.base.entity.TreeNode;
import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.base.web.Result;
import com.jiewen.jwp.base.web.ResultGenerator;
import com.jiewen.modules.sys.entity.Dict;
import com.jiewen.modules.sys.entity.Menu;
import com.jiewen.modules.sys.service.DictService;
import com.jiewen.modules.sys.service.SystemService;
import com.jiewen.modules.sys.utils.UserUtils;

/**
 * 菜单Controller
 */
@Controller
@RequestMapping(value = "/sys/menu")
public class MenuController extends BaseController {

    @Autowired
    private SystemService systemService;
    
    @Autowired
    private DictService dictService;

    @ResponseBody
    @RequestMapping(value = "get")
    public Menu get(@RequestParam(required = false) String id) {
        if (org.apache.commons.lang3.StringUtils.isNotBlank(id)) {
            return systemService.getMenu(id);
        } else {
            return new Menu();
        }
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
    public String index(ModelMap map) {
    	Dict dict = new Dict();
    	dict.setLang(LocaleContextHolder.getLocale().toString().toLowerCase());
    	List<Dict> langTypeList = dictService.findLangTypeList(dict);
    	if(langTypeList.isEmpty()) {
    		dict.setLang(defalutLocale);
    		langTypeList = dictService.findLangTypeList(dict);
    	}
    	map.put("langTypeList", langTypeList);
    	map.put("currentLanguage", dict.getLang());
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
    public List<TreeNode> treeData(@RequestParam("language") String language) {
    	String lang = language;
    	List<TreeNode> treeDataList = systemService.getTreeData(lang);
    	if(treeDataList.isEmpty()) {
    		lang = LocaleContextHolder.getLocale().toString().toLowerCase();
    		treeDataList = systemService.getTreeData(lang);
    		if(treeDataList.isEmpty()) {
    			treeDataList = systemService.getTreeData(defalutLocale);
    		}
    	}
        return treeDataList;
    }
    
    
}
