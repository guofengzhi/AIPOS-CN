package com.jiewen.modules.sys.web;

import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.base.web.ParamResult;
import com.jiewen.jwp.base.web.Result;
import com.jiewen.jwp.base.web.ResultGenerator;
import com.jiewen.modules.sys.domain.MerchantDO;
import com.jiewen.modules.sys.service.MerchantService;
import com.github.pagehelper.PageInfo;

/**
 * 商户表
 * 		@RequiresPermissions("sys:merchant:add")
 * @author 李裕泽
 * @email 461539197@qq.com
 * @date 2018-11-28 15:12:53
 */
 
@Controller
@RequestMapping("/sys/merchant")
public class MerchantController extends BaseController {

	@Autowired
	private MerchantService merchantService;
	
	@RequestMapping(value = "index")
	public String index(MerchantDO merchant,Model model) {
	     MerchantDO  us = new MerchantDO ();
		model.addAttribute("merchant", us);
	    return "modules/sys/merchant";
	}
	
	  @RequestMapping("/list")
      public @ResponseBody Map<String, Object> list(HttpServletRequest request, String reqObj) throws Exception {
		
	 MerchantDO merchant = new ParamResult<MerchantDO>(reqObj).getEntity(MerchantDO.class);
   	 
        PageInfo<MerchantDO> pageInfo = merchantService.list(merchant);
        
        return resultMap(merchant, pageInfo);
		
	}
	
	@RequestMapping("/add")
	String add(){
	    return "modules/sys/add";
	}

	@RequestMapping("/edit")
	@ResponseBody
	public MerchantDO  edit(String id){
		MerchantDO merchant = merchantService.get(id);
	    return merchant;
	}
	
	/**
	 * 保存
	 */
	@ResponseBody
	@RequestMapping("/save")
	public Result save( MerchantDO merchant){
		if(merchantService.save(merchant)>0){
		   return ResultGenerator.genSuccessResult();
		}else{
		   return ResultGenerator.genFailResult("新增失败请查看log日志原因");
		}
	}
	/**
	 * 修改
	 */
	@ResponseBody
	@RequestMapping("/update")
	public Result update( MerchantDO merchant){
		if(merchantService.update(merchant)>0){
		  return ResultGenerator.genSuccessResult();
		}else{
		   return ResultGenerator.genFailResult("修改失败请查看log日志原因");
		}
	}
	
	/**
	 * 删除
	 */
	@RequestMapping( "/remove")
	@ResponseBody
	public Result remove( String id){
		if(merchantService.remove(id)>0){
		  return ResultGenerator.genSuccessResult();
		}else{
		   return ResultGenerator.genFailResult("删除失败请查看log日志原因");
		}
	}
	
	/**
	 * 批量删除
	 */
	@RequestMapping("/batchRemove")
	@ResponseBody
	public Result remove(@RequestParam("ids[]") String[] ids){
		if(merchantService.batchRemove(ids)>0){
		   return ResultGenerator.genSuccessResult();
		}else{
		   return ResultGenerator.genFailResult("删除失败请查看log日志原因");
		}
	}
	
}
