package com.jiewen.modules.sys.web;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.github.pagehelper.PageInfo;
import com.jiewen.commons.util.StringUtil;
import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.base.web.ParamResult;
import com.jiewen.jwp.base.web.Result;
import com.jiewen.jwp.base.web.ResultGenerator;
import com.jiewen.modules.sys.entity.Dict;
import com.jiewen.modules.sys.service.DictService;

/**
 * 字典Controller
 */
@Controller
@RequestMapping(value = "/sys/dict")
public class DictController extends BaseController {

    @Autowired
    private DictService dictService;

    @RequiresPermissions("user")
    @RequestMapping(value = "index")
    public String index(ModelMap map) {
        List<String> typeList = dictService.findTypeList();
        Dict dict = new Dict();
        Locale locale = LocaleContextHolder.getLocale();
        dict.setLang(locale.toString().toLowerCase());
        List<Dict> langTypeList = dictService.findLangTypeList(dict);
        if(langTypeList.isEmpty()) {
        	dict.setLang(defalutLocale);
        	langTypeList = dictService.findLangTypeList(dict);
        }
        map.put("localLang", dict.getLang());
        map.put("typeList", JSON.toJSON(typeList));
        map.put("langTypeList", langTypeList);
        return "modules/sys/dictList";
    }

    @ModelAttribute
    public Dict get(@RequestParam(required = false) String id) {
        Dict dict = new Dict();
        if (StringUtil.isNotEmpty(id)) {
            dict.setId(id);
            return dictService.get(dict);
        } else {
            return dict;
        }
    }

    @RequiresPermissions("sys:dict:view")
    @RequestMapping(value = { "list", "" })
    @ResponseBody
    public Map<String, Object> list(String reqObj) throws Exception {
        Dict dict = new ParamResult<Dict>(reqObj).getEntity(Dict.class);
        String lang = dict.getLang();
        dict.setLang(lang);
        PageInfo<Dict> pageInfo = dictService.findPage(dict);
        return resultMap(dict, pageInfo);
    }

    @RequiresPermissions("sys:dict:view")
    @RequestMapping(value = "edit")
    public String form(Dict dict, Model model) {
        model.addAttribute("dict", dict);
        return "modules/sys/dictForm";
    }

    @RequiresPermissions("sys:dict:edit")
    @RequestMapping(value = "save")
    @ResponseBody
    public Result save(Dict dict, Model model, String addOrUpdate) {
    	String dictSave = messageSourceUtil.getMessage("sys.dict.promt.save");
    	String success = messageSourceUtil.getMessage("sys.dict.promt.success");
        if (!beanValidator(model, dict)) {
            return ResultGenerator.genFailResult((String) model.asMap().get("message"));
        } else {
        	String langType = dict.getLang();
        	dict.setLang(langType);
        	if(addOrUpdate.equals("add")){
        		dict.setId(dictService.getDict().getId());
                dictService.save(dict);
        	}else{
                dictService.update(dict);
        	}
            return ResultGenerator.genSuccessResult(dictSave + dict.getLabel() + success);
        }
    }

    @RequiresPermissions("sys:dict:edit")
    @RequestMapping(value = "delete/{id}")
    @ResponseBody
    public Result delete(Dict dict) {
        dictService.delete(dict);
        String deleteSuccess = messageSourceUtil.getMessage("sys.dict.promt.delete.success");
        return ResultGenerator.genSuccessResult(deleteSuccess);
    }

    @ResponseBody
    @RequestMapping(value = "listData")
    public List<Dict> listData(@RequestParam(required = false) String code) {
        Dict dict = new Dict();
        dict.setType(code);
        return dictService.findList(dict);
    }
    
    /**
     * 根据Id查询对象
     * @param id
     * @return
     */
    @RequestMapping(value ={"selectDict"})
    @ResponseBody
    public Dict selectDict(@RequestParam(required = false) String id) {
	  
    	Dict dict = new Dict();
        if (org.apache.commons.lang3.StringUtils.isNotBlank(id)) {
        	dict.setId(id);
        	dict = dictService.get(dict);
        }
        return dict;
    }
}
