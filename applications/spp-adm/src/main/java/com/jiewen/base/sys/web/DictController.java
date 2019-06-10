
package com.jiewen.base.sys.web;

import java.util.List;
import java.util.Map;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.github.pagehelper.PageInfo;
import com.jiewen.base.core.web.BaseController;
import com.jiewen.base.core.web.ParamResult;
import com.jiewen.base.core.web.Result;
import com.jiewen.base.core.web.ResultGenerator;
import com.jiewen.base.sys.entity.Dict;
import com.jiewen.base.sys.service.DictService;
import com.jiewen.commons.util.StringUtil;

/**
 * 字典Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/dict")
public class DictController extends BaseController {

    @Autowired
    private DictService dictService;

    @RequiresPermissions("user")
    @RequestMapping(value = "index")
    public String index(ModelMap map) {
        List<String> typeList = dictService.findTypeList();
        map.put("typeList", JSON.toJSON(typeList));
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
    public Result save(Dict dict, Model model) {
        String dictSave = messageSourceUtil.getMessage("sys.dict.promt.save");
        String success = messageSourceUtil.getMessage("sys.dict.promt.success");
        if (!beanValidator(model, dict)) {
            return ResultGenerator.genFailResult((String) model.asMap().get("message"));
        } else {
            dictService.save(dict);
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

}
