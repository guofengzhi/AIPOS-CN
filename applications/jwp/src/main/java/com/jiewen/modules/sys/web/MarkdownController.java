package com.jiewen.modules.sys.web;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageInfo;
import com.jiewen.commons.util.StringUtil;
import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.base.web.ParamResult;
import com.jiewen.jwp.base.web.Result;
import com.jiewen.jwp.base.web.ResultGenerator;
import com.jiewen.modules.sys.entity.Essay;
import com.jiewen.modules.sys.service.EssayService;

/**
 * 编辑Controller
 */
@Controller
@RequestMapping(value = "/markdown")
public class MarkdownController extends BaseController {

	@Autowired
	private EssayService essayService;
	
    @RequestMapping(value = { "form" })
    public String form(Essay essay, Model model) {
    	model.addAttribute("id", essay.getId());
    	return "modules/sys/markdown";    		
    }
    
    @RequestMapping(value = { "preview" })
    public String preview(Essay essay, Model model) {
    	model.addAttribute("id", essay.getId());
    	return "modules/sys/preview";    		
    }
    
    @RequestMapping(value = { "getEssay/{mid}" })
    @ResponseBody
    public Result getEssay(@PathVariable("mid") String mid) {
    	Essay essay = new Essay();
    	essay.setId(mid);
    	return ResultGenerator.genSuccessResult(essayService.get(essay));
    }
    
    @RequestMapping(value = { "index" })
    public String index() {
        return "modules/sys/essayList";
    }
    
    @ModelAttribute
    public Essay get(@RequestParam(required = false) String id) {
    	Essay essay = new Essay();
        if (StringUtil.isNotEmpty(id)) {
        	essay.setId(id);
            return essayService.get(essay);
        } else {
            return essay;
        }
    }
    
    @RequestMapping(value = { "list", "" })
    @ResponseBody
    public Map<String, Object> list(String reqObj) throws Exception {
    	Essay essay = new ParamResult<Essay>(reqObj).getEntity(Essay.class);    		
        PageInfo<Essay> pageInfo = essayService.findPage(essay);
        return resultMap(essay, pageInfo);
    }
    
    @RequestMapping(value = "save")
    public @ResponseBody Result save(Essay essay) {
    	try {
			essayService.save(essay);
		} catch (Exception e) {
			return ResultGenerator.genFailResult(messageSourceUtil.getMessage("common.saveFailed"));
		}
        return ResultGenerator.genSuccessResult(messageSourceUtil.getMessage("common.saveSuccess"));
    }
    
    @RequestMapping(value = "delete")
    public @ResponseBody Result delete(Essay essay) {
    	try {
			essayService.delete(essay);
		} catch (Exception e) {
			return ResultGenerator.genFailResult(messageSourceUtil.getMessage("common.deleteFail"));
		}
        return ResultGenerator.genSuccessResult(messageSourceUtil.getMessage("common.deleteSuccess"));
    }

}
