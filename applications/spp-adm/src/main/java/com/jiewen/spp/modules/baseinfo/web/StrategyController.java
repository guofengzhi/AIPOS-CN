
package com.jiewen.spp.modules.baseinfo.web;

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
import com.jiewen.base.core.web.BaseController;
import com.jiewen.base.core.web.ParamResult;
import com.jiewen.base.core.web.Result;
import com.jiewen.base.core.web.ResultGenerator;
import com.jiewen.base.sys.entity.Dict;
import com.jiewen.base.sys.utils.DictUtils;
import com.jiewen.base.sys.utils.UserUtils;
import com.jiewen.jwp.common.utils.StringUtils;
import com.jiewen.spp.modules.baseinfo.entity.Strategy;
import com.jiewen.spp.modules.baseinfo.service.StrategyService;

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
