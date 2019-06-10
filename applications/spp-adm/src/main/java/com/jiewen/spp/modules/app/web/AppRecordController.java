
package com.jiewen.spp.modules.app.web;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageInfo;
import com.jiewen.base.core.web.BaseController;
import com.jiewen.base.core.web.ParamResult;
import com.jiewen.base.sys.utils.UserUtils;
import com.jiewen.commons.util.DateTimeUtil;
import com.jiewen.spp.modules.app.entity.AppRecord;
import com.jiewen.spp.modules.app.service.AppRecordService;
import com.jiewen.spp.modules.baseinfo.entity.DeviceType;
import com.jiewen.spp.modules.baseinfo.entity.ManuFacturer;
import com.jiewen.spp.modules.baseinfo.service.DeviceTypeService;
import com.jiewen.spp.modules.baseinfo.service.ManuFacturerService;

@Controller
@RequestMapping("${adminPath}/appRecord")
public class AppRecordController extends BaseController {

	@Autowired
	private DeviceTypeService deviceTypeService;

	@Autowired
	private ManuFacturerService manuFacturerService;

	@Autowired
	private AppRecordService appRecordService;

	private static final String DEVICE_TYPE_LIST = "deviceTypeList";

	private static final String MANU_FACT_LIST = "manuFacturerList";

	@RequestMapping(value = "index")
	public String index(Model model) {
		return "modules/app/appRecord/recordAppList";
	}

	@RequestMapping(value = { "list", "" })
	@ResponseBody
	public Map<String, Object> list(String reqObj) throws Exception {
		AppRecord appRecord = new ParamResult<AppRecord>(reqObj).getEntity(AppRecord.class);

		if (appRecord.getBeginDate() != null) {
			String sDate = DateTimeUtil.format(appRecord.getBeginDate(), "yyyyMMdd");
			appRecord.setBeginDateStr(sDate);
		}
		if (appRecord.getEndDate() != null) {
			String eDate = DateTimeUtil.format(appRecord.getEndDate(), "yyyyMMdd");
			appRecord.setEndDateStr(eDate);
		}
		appRecord.setOrganId(UserUtils.getUser().getOfficeId());
		PageInfo<AppRecord> pageInfo = appRecordService.findPage(appRecord);
		return resultMap(appRecord, pageInfo);
	}

	/**
	 * 去已发布系统版本页面
	 * 
	 * @param id
	 * @param model
	 * @return
	 */
	@RequestMapping("alreadyAppList")
	public String alreadyAppList(Integer id, Model model) {
		model.addAttribute("recordId", id);
		List<DeviceType> deviceTypeList = deviceTypeService.getDeviceTypeList();
		model.addAttribute(DEVICE_TYPE_LIST, deviceTypeList);
		List<ManuFacturer> manuFacturerList = manuFacturerService.findList();
		model.addAttribute(MANU_FACT_LIST, manuFacturerList);
		return "modules/app/appRecord/recordAppDeviceList";
	}
}
