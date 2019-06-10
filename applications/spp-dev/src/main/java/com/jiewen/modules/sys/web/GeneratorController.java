package com.jiewen.modules.sys.web;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.configuration.Configuration;
import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.PropertiesConfiguration;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.github.pagehelper.PageInfo;
import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.base.web.ParamResult;
import com.jiewen.jwp.base.web.Result;
import com.jiewen.jwp.base.web.ResultGenerator;
import com.jiewen.modules.sys.entity.SelectTable;
import com.jiewen.modules.sys.service.SelectTableService;
import com.jiewen.modules.sys.service.SystemService;
import com.jiewen.modules.sys.utils.GenUtils;

/**
 * 代码生成器
 * @author liyuz
 *
 */
@Controller
@RequestMapping("/generator")
public class GeneratorController extends BaseController {

	
	
	 @Autowired
	 private SystemService systemService;
	
	 @Autowired
	 private SelectTableService selectTableService;
	 
	 /**
	  * 初始化跳转数据表页面
	  * @return
	  */
	 @RequestMapping(value="/setting", method=RequestMethod.GET)
     public String setting(){
        return "modules/sys/generator_setting";
        
     }
	 
	 /**
	  * 初始化加载数据接中所有的表以及试图
	  * @param request
	  * @param reqObj
	  * @return
	  * @throws Exception
	  */
     @RequestMapping(value = { "list", "" })
 	 public @ResponseBody Map<String, Object> list(HttpServletRequest request, String reqObj) throws Exception {
    	 
    	SelectTable selectTable = new ParamResult<SelectTable>(reqObj).getEntity(SelectTable.class);
    	 
        PageInfo<SelectTable> pageInfo = selectTableService.findPage(selectTable);
        
        return resultMap(selectTable, pageInfo);
     }
	 
     
    /**
     * 
     * 根据表名生成对应的代码
     * @param request
     * @param response
     * @param tableName
     * @throws IOException
     * 
     */
    @RequestMapping("/code/{tableName}")
 	public void code(HttpServletRequest request, HttpServletResponse response,
 			@PathVariable("tableName") String tableName) throws IOException {
    	
 		String[] tableNames = new String[] { tableName };
 		
 		byte[] data = selectTableService.generatorCode(tableNames);
 		
 		response.reset();
 		
 		response.setHeader("Content-Disposition", "attachment; filename=\"JWP.zip\"");
 		response.addHeader("Content-Length", "" + data.length);
 		response.setContentType("application/octet-stream; charset=UTF-8");

 		IOUtils.write(data, response.getOutputStream());
 	}
    
    @RequestMapping("/batchCode")
	public void batchCode(HttpServletRequest request, HttpServletResponse response, String tables) throws IOException {
		String[] tableNames = new String[] {};
		tableNames = JSON.parseArray(tables).toArray(tableNames);
		byte[] data = selectTableService.generatorCode(tableNames);
		response.reset();
		response.setHeader("Content-Disposition", "attachment; filename=\"bootdo.zip\"");
		response.addHeader("Content-Length", "" + data.length);
		response.setContentType("application/octet-stream; charset=UTF-8");

		IOUtils.write(data, response.getOutputStream());
	}

    @RequestMapping("/edit")
	public String edit(Model model) {
		Configuration conf = GenUtils.getConfig();
		Map<String, Object> property = new HashMap<>(16);
		property.put("author", conf.getProperty("author"));
		property.put("email", conf.getProperty("email"));
		property.put("packPath", conf.getProperty("packPath"));
		property.put("autoRemovePre", conf.getProperty("autoRemovePre"));
		property.put("tablePrefix", conf.getProperty("tablePrefix"));
		model.addAttribute("property", property);
		return "modules/sys/generator_edit";
	}

    @RequestMapping("/update")
	public @ResponseBody Result update(@RequestParam Map<String, Object> map) {
		try {
			PropertiesConfiguration conf = new PropertiesConfiguration("generator.properties");
			conf.setProperty("author", map.get("author"));
			conf.setProperty("email", map.get("email"));
			conf.setProperty("packPath", map.get("packPath"));
			//conf.setProperty("autoRemovePre", map.get("autoRemovePre"));
			//conf.setProperty("tablePrefix", map.get("tablePrefix"));
			conf.save();
		} catch (ConfigurationException e) {
			return ResultGenerator.genFailResult("保存配置文件出错");
		}
		return ResultGenerator.genSuccessResult("修改成功");

	}
}
