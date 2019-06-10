package com.jiewen.spp.modules.tms.web;

import java.util.List;
import java.util.Map;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageInfo;
import com.jiewen.base.core.web.BaseController;
import com.jiewen.base.core.web.ParamResult;
import com.jiewen.jwp.common.utils.StringUtils;
import com.jiewen.spp.modules.baseinfo.entity.ManuFacturer;
import com.jiewen.spp.modules.baseinfo.service.ManuFacturerService;
import com.jiewen.spp.modules.tms.entity.UpdateLog;
import com.jiewen.spp.modules.tms.service.UpdateLogService;

/**
 * 更新日志控制层
 * 
 * @author guofengzhi
 */
@Controller
@RequestMapping(value = "${adminPath}/tms/updateLog")
public class UpdateLogController extends BaseController {

	@Autowired
	private UpdateLogService updateLogService;
	
	@Autowired
	private ManuFacturerService manuFacturerService;

	@ModelAttribute
	public UpdateLog get(@RequestParam(required = false) String id) {
		if (!StringUtils.isBlank(id)) {
			UpdateLog updateLog = new UpdateLog();
			updateLog.setId(id);
			updateLog = updateLogService.get(updateLog);
			return updateLog;
		} else {
			return new UpdateLog();
		}
	}

	@RequiresPermissions("tms:updateLog:view")
	@RequestMapping(value = { "detail" })
	public String detail(@ModelAttribute UpdateLog updateLog, Model model) {
		List<ManuFacturer> manufacturerList = manuFacturerService.findList();
		model.addAttribute("manufacturerList", manufacturerList);
		model.addAttribute(updateLog);
		return "modules/tms/updateLogDetail";
	} 
	
	/**
	 * 显示主界面
	 * 
	 * @param model
	 * @return
	 */
	@RequiresPermissions("tms:updateLog:view")
	@RequestMapping(value = { "index" })
	public String index(Model model) {
		List<ManuFacturer> manufacturerList = manuFacturerService.findList();
		model.addAttribute("manufacturerList", manufacturerList);
		return "modules/tms/updateLogList";
	}

	/**
	 * 条件查询
	 * 
	 * @param reqObj
	 * @return
	 * @throws Exception
	 */
	@RequiresPermissions("tms:updateLog:view")
	@RequestMapping(value = {"list"})
	@ResponseBody
	public Map<String, Object> list(String reqObj) throws Exception {
		UpdateLog updateLog = new ParamResult<UpdateLog>(reqObj).getEntity(UpdateLog.class);
		PageInfo<UpdateLog> pageInfo = updateLogService.findPage(updateLog);
		return resultMap(updateLog, pageInfo);
	}

}
