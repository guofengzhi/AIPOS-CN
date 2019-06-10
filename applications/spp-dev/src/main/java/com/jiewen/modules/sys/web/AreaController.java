package com.jiewen.modules.sys.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.jiewen.jwp.base.query.domain.Query;
import com.jiewen.jwp.base.query.handler.QueryDefinition;
import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.base.web.Result;
import com.jiewen.jwp.base.web.ResultGenerator;
import com.jiewen.jwp.common.JsonMapper;
import com.jiewen.modules.sys.entity.Area;
import com.jiewen.modules.sys.entity.AreaTreeNode;
import com.jiewen.modules.sys.service.AreaService;
import com.jiewen.modules.sys.utils.UserUtils;

/**
 * 区域Controller.
 */
@Controller
@RequestMapping(value = "/sys/area")
public class AreaController extends BaseController {

    @Autowired
    private AreaService areaService;

    @RequestMapping(value= {"get"})
    
//    @ModelAttribute("area")
    @ResponseBody
    public Area get(@RequestParam(required = false) String id) {
        if (StringUtils.isNotBlank(id)) {
            return areaService.get(id);
        } else {
            return new Area();
        }
    }

    @RequiresPermissions("sys:area:view")
//    @RequestMapping(value = { "list", "" })
//改为下一行？
    @RequestMapping(value="list")
    @ResponseBody
    public Map<String, Object> list(String queryId, Area area) {
        Map<String, Object> result = new HashMap<String, Object>();
        Query query = QueryDefinition.getQueryById(queryId);
        result.put("data", JsonMapper.toJsonString(areaService.findAll()));
        result.put("query", query);
        return result;
    }

    @RequiresPermissions("sys:area:view")
    @RequestMapping(value = { "index", "" })
    public String index() {
        return "modules/sys/areaTree";
    }

    @RequiresPermissions("sys:area:view")
    @RequestMapping(value = "form")
    public String form(Area area, Model model) {
        if (area.getParent() == null || area.getParent().getId() == null) {
            area.setParent(UserUtils.getUser().getOffice().getArea());
        }
        area.setParent(areaService.get(area.getParent().getId()));
        model.addAttribute("area", area);
        return "modules/sys/areaForm";
    }

    @RequiresPermissions("sys:area:edit")
    @RequestMapping(value = "save")
    @ResponseBody
    public Result save(Area area, Model model) {
        String message = "";
        String saveArea = messageSourceUtil.getMessage("sys.area.tip.saveArea");
        String success = messageSourceUtil.getMessage("common.sys.success");
        if (area.getParent() == null
                || org.apache.commons.lang3.StringUtils.isNotBlank(area.getParent().getId())) {
            area.setParent(new Area(area.getParentId()));
        }
        if (!beanValidator(model, area)) {
            message = (String) model.asMap().get("message");
        } else {
        	
        	//如果不存在ID则新增ID
            if(area.getId() == null){
            	area.setId(areaService.selectAreaId().getId());
            	areaService.save(area);
            }else{
            	areaService.update(area);
            } 
            message = saveArea+"'" + area.getName() + "'"+success;
        }
            return ResultGenerator.genSuccessResult(message);
    }

    @RequiresPermissions("sys:area:edit")
    @RequestMapping(value = "delete")
    @ResponseBody
    public Result delete(Area area, RedirectAttributes redirectAttributes) {
    	String delAreaSuccess = messageSourceUtil.getMessage("sys.area.tip.delAreaSuccess");
        areaService.delete(area);
        return ResultGenerator.genSuccessResult(delAreaSuccess);
    }
  
    @RequiresPermissions("user")
    @RequestMapping(value="treeData")
    public @ResponseBody List<AreaTreeNode> treeData(){
    	return areaService.getOrgTreeData();
    }
   
}
