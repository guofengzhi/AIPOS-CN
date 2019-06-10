package com.jiewen.modules.customer.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.github.pagehelper.PageInfo;
import com.jiewen.base.core.web.Result;
import com.jiewen.base.core.web.ResultGenerator;
import com.jiewen.jwp.base.constant.DictConstant;
import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.base.web.ParamResult;
import com.jiewen.jwp.common.StringUtils;
import com.jiewen.modules.app.entity.AppInfo;
import com.jiewen.modules.app.service.AppInfoService;
import com.jiewen.modules.baseinfo.entity.DeviceType;
import com.jiewen.modules.baseinfo.entity.ManuFacturer;
import com.jiewen.modules.baseinfo.service.DeviceTypeService;
import com.jiewen.modules.baseinfo.service.ManuFacturerService;
import com.jiewen.modules.device.entity.Device;
import com.jiewen.modules.device.entity.DeviceInfo;
import com.jiewen.modules.device.service.DeviceService;
import com.jiewen.modules.sys.entity.Dict;
import com.jiewen.modules.sys.entity.User;
import com.jiewen.modules.sys.utils.DictUtils;
import com.jiewen.modules.sys.utils.UserUtils;

@Controller
@RequestMapping("${adminPath}/customer/device")
public class CustomerDeviceController extends BaseController {

	private static final String DEVICE_TYPE_LIST = "deviceTypeList";

	private static final String MANU_FACT_LIST = "manuFacturerList";

	private static final String INDUSTRY_LIST = "industryList";

	private static final String CLIENT_ID_LIST = "clientIdentifyList";

	private static final String INDUSTRY_CODE = "40010";

	private static final String DEVICE = "device";

	private static final String DEVICE_INFO = "deviceInfo";

	private static final String DICT_LIST = "dictList";

	@Autowired
	private DeviceService deviceService;

	@Autowired
	private ManuFacturerService manuFacturerService;

	@Autowired
	private DeviceTypeService deviceTypeService;

	@Autowired
	private AppInfoService appInfoService;

	@ModelAttribute
	public Device get(String id, Model model) {
		Device device = new Device();
		if (StringUtils.isNotBlank(id)) {
			device.setId(id);
			device = deviceService.get(device);
		}
		return device;
	}

	private List<DeviceType> getDevTypeList() {
		return deviceTypeService.getDeviceTypeList();
	}

	private List<ManuFacturer> getManuFacturerList() {
		return manuFacturerService.findList();
	}

	private List<Dict> getClientIdeList() {
		return DictUtils.getDictList("client_identify");
	}

	@RequestMapping(value = "index")
	public String index(Model model) {

		model.addAttribute(DEVICE_TYPE_LIST, getDevTypeList());
		model.addAttribute(MANU_FACT_LIST, getManuFacturerList());
		model.addAttribute(CLIENT_ID_LIST, getClientIdeList());
		List<Dict> industryList = DictUtils.getDictList(INDUSTRY_CODE);
		model.addAttribute(INDUSTRY_LIST, industryList);
		return "modules/customer/cusDeviceList";
	}

	/**
	 * 正常列表
	 * 
	 * @param deviceType
	 * @param reqObj
	 * @return
	 * @throws Exception
	 */
	@RequiresPermissions("customer:device:view")
	@RequestMapping(value = { "list", "" })
	@ResponseBody
	public Map<String, Object> list(String reqObj) {
		Device device = new ParamResult<Device>(reqObj).getEntity(Device.class);
		User currentUser = UserUtils.getUser();
		device.setClientNo(currentUser.getOfficeId());
		PageInfo<Device> pageInfo = deviceService.findPage(device);
		return resultMap(device, pageInfo);
	}

	/**
	 * 设备信息
	 * 
	 * @author Pang.M
	 */
	@RequestMapping(value = "deviceInfo")
	public String checkDeviceInfo(Model model, Device device) {
		List<DeviceType> deviceTypeList = deviceTypeService.getDeviceTypeList();
		model.addAttribute(DEVICE_TYPE_LIST, deviceTypeList);
		List<ManuFacturer> manuFacturerList = manuFacturerService.findList();
		model.addAttribute(MANU_FACT_LIST, manuFacturerList);
		model.addAttribute(DEVICE, device);

		DeviceInfo deviceInfo = new DeviceInfo();
		if (device.getDeviceInfo() != null) {
			deviceInfo = JSON.parseObject(device.getDeviceInfo().toString(), DeviceInfo.class);
		}
		model.addAttribute(DEVICE_INFO, deviceInfo);

		// 设备硬件状状态
		List<Dict> dictList = DictUtils.getDictList(DictConstant.DEVICE_INFO_STATUS);
		model.addAttribute(DICT_LIST, dictList);

		return "modules/customer/cusDeviceInfo";
	}

	/**
	 * 设备应用列表
	 * 
	 * @author Pang.M
	 */
	@RequestMapping(value = "checkDeviceAppList")
	public @ResponseBody Result checkDeviceAppList(String deviceId) {
		Device device = new Device();
		if (!StringUtils.isBlank(deviceId)) {
			device.setId(deviceId);
			device = deviceService.findDeviceById(device);
		}
		List<AppInfo> appInfoList = new ArrayList<>();
		if (device.getAppInfo() != null) {
			appInfoList = appInfoService.findAppInfoListConverDevolper(device.getAppInfo().toString(),
					device.getOrganId());
		}
		return ResultGenerator.genSuccessResult(appInfoList);
	}

	/**
	 * 获取设备数量
	 * 
	 * @return
	 */
	@RequestMapping(value = "getDeviceCount")
	public @ResponseBody Result getDeviceCount(String type) {
		return ResultGenerator.genSuccessResult(deviceService.getCustomerDeviceCount(type));
	}

}
