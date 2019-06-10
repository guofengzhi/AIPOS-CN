package com.jiewen.modules.baseinfo.web;

import java.util.HashMap;
import java.util.List;
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
import com.jiewen.modules.baseinfo.entity.DeviceType;
import com.jiewen.modules.baseinfo.entity.Strategy;
import com.jiewen.modules.baseinfo.service.StrategyService;
import com.jiewen.modules.sys.entity.Dict;
import com.jiewen.modules.sys.utils.DictUtils;
import com.jiewen.modules.sys.utils.UserUtils;

@Controller
@RequestMapping("${adminPath}/strategy")
public class StrategyController extends BaseController {

	@Autowired
	private StrategyService strategyService;

	@RequestMapping(value = "index")
	public String index() {
		return "modules/strategy/strategyList";
	}

	@ModelAttribute
	public Strategy get(@RequestParam(required = false) String id) {
		if (!StringUtils.isBlank(id)) {
			return strategyService.get(id);
		} else {
			return new Strategy();
		}
	}

	@RequiresPermissions("strategy:view")
	@RequestMapping(value = { "list", "" })
	@ResponseBody
	public Map<String, Object> list(String reqObj) throws Exception {
		Strategy strategy = new ParamResult<Strategy>(reqObj).getEntity(Strategy.class);
		strategy.setOrganId(UserUtils.getUser().getOfficeId());
		PageInfo<Strategy> pageInfo = strategyService.findPage(strategy);
		return resultMap(strategy, pageInfo);
	}

	@RequiresPermissions("strategy:edit")
	@RequestMapping(value = "delete")
	public @ResponseBody Result delete(Strategy strategy) {
		String deleteFail = messageSourceUtil.getMessage("common.deleteFail");
		String deleteSuccess = messageSourceUtil.getMessage("common.deleteSuccess");
		try {
			strategyService.deleteById(strategy);
		} catch (Exception e) {
			return ResultGenerator.genFailResult(deleteFail);
		}
		return ResultGenerator.genSuccessResult(deleteSuccess);
	}

	@RequiresPermissions("strategy:edit")
	@RequestMapping(value = "form/{option}")
	public String form(@PathVariable String option, Strategy strategy, Model model) {
		model.addAttribute("strategy", strategy);
		model.addAttribute("option", option);
		List<Dict> dictList = DictUtils.getDictList("upgrade_type");
		model.addAttribute("dictList", dictList);
		return "modules/strategy/strategyForm";
	}


    /**
	 * 新增修改
	 * 
	 * @param option
	 * @param manuFacturer
	 * @param model
	 * @return
	 */
    @RequiresPermissions("device:type:edit")
	@RequestMapping(value = "StrategyEditOrAdd")
	@ResponseBody
	public Strategy form(String id, Model model) {
    	Strategy strategy = new Strategy();
		if (org.apache.commons.lang3.StringUtils.isNotBlank(id)) {
			strategy = strategyService.get(id);
		}
		return strategy;
	}
    
    /**
	 * 验证策略名称是否存在
	 * @param oldValue
	 * @param newValue
	 * @return
	 */
	@ResponseBody
	@RequiresPermissions("device:type:edit")
	@RequestMapping(value = "checkStrategyName")
	public Map<String, Boolean> checkStrategyName(String oldValueNo, String newValueNo) {
		
		Map<String, Boolean> map = new HashMap<>();
		
		Strategy strategy= new Strategy();
		strategy =strategyService.findStrategyByName(newValueNo);
		if (strategy != null) {
			if(oldValueNo !=null && !"".equals(oldValueNo) ){//修改判断
				if(oldValueNo.equals(newValueNo) ){//策略名称未修改，可以插入
					  map.put("valid", true);
				}else{//修改后的策略名称存在，不可修改
					map.put("valid", false);
				}
			}else{//新增，策略名称存在，不可新增
				map.put("valid", false);
			}
		}else{//策略名称不存在，可以新增
			    map.put("valid", true);
		}
		return map;
	}
	
	@RequiresPermissions("strategy:edit")
	@RequestMapping(value = { "save", "" })
	@ResponseBody
	public Result save(Strategy strategy) throws Exception {
		String saveSuccess = messageSourceUtil.getMessage("common.saveSuccess");
		String updateSuccess = messageSourceUtil.getMessage("common.updateSuccess");
		String policynameExist = messageSourceUtil.getMessage("modules.baseinfo.policyname.already.exists");
		strategy.setOrganId(UserUtils.getUser().getOfficeId());
		if (StringUtils.isEmpty(strategy.getId())) {

			Strategy findStrategyByName = strategyService.findStrategyByName(strategy.getStrategyName());
			if (findStrategyByName != null) {
				return ResultGenerator.genFailResult(policynameExist);
			}
			strategyService.saveStrategy(strategy);
			return ResultGenerator.genSuccessResult(saveSuccess);
		}
		strategyService.update(strategy);
		return ResultGenerator.genSuccessResult(updateSuccess);
	}

}
