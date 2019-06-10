package com.jiewen.spp.modules.tms.web;

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
import com.jiewen.jwp.common.utils.StringUtils;
import com.jiewen.jwp.common.utils.csrf.annotation.RefreshCSRFToken;
import com.jiewen.spp.modules.baseinfo.entity.ManuFacturer;
import com.jiewen.spp.modules.baseinfo.service.ManuFacturerService;
import com.jiewen.spp.modules.tms.entity.UpdateStrategy;
import com.jiewen.spp.modules.tms.service.UpdateStrategyService;

/**
 * 更新策略控制层
 * 
 * @author guofengzhi
 * 
 *         update 2019年5月21日 1、策略配置页面去除商户、终端号。 2、增加策略配置页面
 *         按sn号段或者sn匹配，以逗号分隔。例如000210001001-000210001100,000210001108属于一个sn号段加一个sn
 */
@Controller
@RequestMapping(value = "${adminPath}/tms/updateStrategy")
public class UpdateStrategyController extends BaseController {

	@Autowired
	private UpdateStrategyService updateStrategyService;

	@Autowired
	private ManuFacturerService manuFacturerService;

	@ModelAttribute
	public UpdateStrategy get(@RequestParam(required = false) String id) {
		if (!StringUtils.isBlank(id)) {
			UpdateStrategy updateStrategy = new UpdateStrategy();
			updateStrategy.setId(id);
			updateStrategy = updateStrategyService.get(updateStrategy);
			return updateStrategy;
		} else {
			return new UpdateStrategy();
		}
	}

	/**
	 * 显示主界面
	 * 
	 * @param model
	 * @return
	 */
	@RequiresPermissions("tms:updateStrategy:view")
	@RequestMapping(value = { "index" })
	public String index(Model model) {
		List<ManuFacturer> manufacturerList = manuFacturerService.findList();
		model.addAttribute("manufacturerList", manufacturerList);
		return "modules/tms/updateStrategyList";
	}

	/**
	 * 条件查询
	 * 
	 * @param reqObj
	 * @return
	 * @throws Exception
	 */
	@RequiresPermissions("tms:updateStrategy:view")
	@RequestMapping(value = { "list", "" })
	@ResponseBody
	public Map<String, Object> list(String reqObj) throws Exception {
		UpdateStrategy updateStrategy = new ParamResult<UpdateStrategy>(reqObj)
				.getEntity(UpdateStrategy.class);
		PageInfo<UpdateStrategy> pageInfo = updateStrategyService.findPage(updateStrategy);
		return resultMap(updateStrategy, pageInfo);
	}

	/**
	 * 展示新增/修改表单
	 * 
	 * @param updateStrategy
	 * @param model
	 * @return
	 */
	@RefreshCSRFToken
	@RequiresPermissions("tms:updateStrategy:edit")
	@RequestMapping(value = "form")
	public String form(@ModelAttribute UpdateStrategy updateStrategy, Model model) {
		List<ManuFacturer> manufacturerList = manuFacturerService.findList();
		model.addAttribute("manufacturerList", manufacturerList);
		model.addAttribute(updateStrategy);
		return "modules/tms/updateStrategyForm";
	}

	/**
	 * 展示策略关联更新物界面
	 * 
	 * @param updateStrategy
	 * @param model
	 * @return
	 */
	@RefreshCSRFToken
	@RequiresPermissions("tms:updateStrategy:edit")
	@RequestMapping(value = "configView")
	public String configView(@ModelAttribute UpdateStrategy updateStrategy, Model model) {
		model.addAttribute("id", updateStrategy.getId());
		model.addAttribute("maunNo", updateStrategy.getManufactureNo());
		return "modules/tms/strategyConfiguration";
	}

	/**
	 * 执行策略关联更新物文件操作
	 * 
	 * @param updateItemsId
	 * @param updateStrategyId
	 * @return
	 * @throws Exception
	 */
	@RequiresPermissions("tms:updateStrategy:edit")
	@RequestMapping(value = "config/{strategyId}")
	@ResponseBody
	public Result config(@PathVariable("strategyId") String strategyId, String ids)
			throws Exception {
		String configFail = messageSourceUtil.getMessage("tms.config.fail");
		String configSuccess = messageSourceUtil.getMessage("tms.config.success");
		try {
			updateStrategyService.saveFileStategy(strategyId, ids);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			return ResultGenerator.genFailResult(configFail);
		}
		return ResultGenerator.genSuccessResult(configSuccess);
	}

	/**
	 * 逻辑删除
	 * 
	 * @param updateStrategy
	 * @return
	 */
	@RequiresPermissions("tms:updateStrategy:edit")
	@RequestMapping(value = "delete")
	public @ResponseBody Result delete(UpdateStrategy updateStrategy) {
		String deleteFail = messageSourceUtil.getMessage("common.deleteFail");
		String deleteSuccess = messageSourceUtil.getMessage("common.deleteSuccess");
		try {
			updateStrategyService.deleteById(updateStrategy);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			return ResultGenerator.genFailResult(deleteFail);
		}
		return ResultGenerator.genSuccessResult(deleteSuccess);
	}

	/**
	 * 新增/修改更新策略
	 * 
	 * @param updateStrategy
	 * @return
	 * @throws Exception
	 */
	@RequiresPermissions("tms:updateStrategy:edit")
	@RequestMapping(value = "save")
	@ResponseBody
	public Result save(UpdateStrategy updateStrategy) throws Exception {
		String saveSuccess = messageSourceUtil.getMessage("common.saveSuccess");
		String updateSuccess = messageSourceUtil.getMessage("common.updateSuccess");
		updateStrategy.setOrganId(updateStrategy.getCurrentUser().getOfficeId());
		if (StringUtils.isEmpty(updateStrategy.getId())) {
			updateStrategyService.save(updateStrategy);
			return ResultGenerator.genSuccessResult(saveSuccess);
		}
		updateStrategyService.save(updateStrategy);
		return ResultGenerator.genSuccessResult(updateSuccess);
	}

}
