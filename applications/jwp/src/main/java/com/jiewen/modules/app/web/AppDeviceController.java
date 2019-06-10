package com.jiewen.modules.app.web;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageInfo;
import com.jiewen.base.core.web.Result;
import com.jiewen.base.core.web.ResultGenerator;
import com.jiewen.jwp.base.constant.Constant;
import com.jiewen.jwp.base.utils.CacheUtils;
import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.base.web.ParamResult;
import com.jiewen.modules.app.entity.AppDevice;
import com.jiewen.modules.app.entity.AppInfo;
import com.jiewen.modules.app.entity.AppVersion;
import com.jiewen.modules.app.service.AppDeviceService;
import com.jiewen.modules.app.service.AppInfoService;
import com.jiewen.modules.app.service.AppVersionService;
import com.jiewen.modules.baseinfo.entity.Strategy;
import com.jiewen.modules.baseinfo.service.StrategyService;
import com.jiewen.modules.device.entity.Device;
import com.jiewen.modules.sys.entity.Dict;
import com.jiewen.modules.sys.utils.DictUtils;
import com.jiewen.modules.sys.utils.UserUtils;

@Controller
@RequestMapping("${adminPath}/appDevice")
public class AppDeviceController extends BaseController {

	@Autowired
	private AppDeviceService appDeviceService;

	@Autowired
	private AppInfoService appInfoService;

	@Autowired
	private AppVersionService appVersionService;

	@Autowired
	private StrategyService strategyService;

	@RequestMapping(value = "index")
	public String index() {
		return "modules/app/appdevice/appDeviceList";
	}

	@RequestMapping(value = { "list", "" })
	@ResponseBody
	public Map<String, Object> list(String reqObj) throws Exception {
		AppDevice appDevice = new ParamResult<AppDevice>(reqObj).getEntity(AppDevice.class);
		PageInfo<AppDevice> pageInfo = appDeviceService.findPage(appDevice);
		return resultMap(appDevice, pageInfo);
	}

	/**
	 * 发布系统版本给指定id的设备
	 * 
	 * @param ids
	 * @return
	 */

	@RequestMapping(value = "saveAppDevice/{appId}")
	public @ResponseBody Result saveRomDevice(@PathVariable("appId") String appId, String ids, String strategyId,
			String isJPushMessage, String upType) {
		String releaseFail = messageSourceUtil.getMessage("common.release.fail");
		String releaseSuccess = messageSourceUtil.getMessage("common.release.success");
		String message = messageSourceUtil.getMessage("modules.app.release.fail.device");
		long deviceCount = 0;
		if (ids != null) {
			try {
				// 通过APP_ID获取APP信息
				AppInfo appInfo = appInfoService.get(appId);
				if (appInfo == null) {
					return ResultGenerator.genFailResult(releaseFail);
				}
				// 获取版本号最高的APP_VERSION
				List<AppVersion> appVersionList = appVersionService.findAppVerByVersion(appInfo.getAppPackage());
				if (CollectionUtils.isEmpty(appVersionList)) {
					return ResultGenerator.genFailResult(releaseFail);
				}
				AppVersion appVersion = appVersionList.get(0);
				// 通过id查找出策略
				Strategy strategy = new Strategy();
				strategy.setId(strategyId);
				if (!"a".equals(strategyId)) {
					strategy = strategyService.get(strategyId);
				}
				deviceCount = appDeviceService.saveAppDevice(appVersion.getId(), ids, strategy, isJPushMessage, upType);
				clearCacheDeviceSn();
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
				return ResultGenerator.genFailResult(releaseFail);
			}
		}
		return ResultGenerator.genSuccessResult(releaseSuccess + deviceCount + message);
	}

	/**
	 * 所有页全选
	 * 
	 * @param device
	 * @param jPushDes
	 * @return
	 */
	@RequestMapping(value = "saveAllAppDevice")
	public @ResponseBody Result saveAllRomDevice(Device device, String isJPushMessage, String strategyId,
			String upType) {
		String releaseSuccess = messageSourceUtil.getMessage("common.release.success");
		String message = messageSourceUtil.getMessage("modules.app.release.fail.device");
		String releaseFail = messageSourceUtil.getMessage("common.release.fail");
		long deviceCount = 0;
		if (device != null) {
			try {
				// 通过APP_ID获取APP信息
				AppInfo appInfo = appInfoService.get(device.getId());
				if (appInfo == null) {
					return ResultGenerator.genFailResult(releaseFail);
				}
				// 获取版本号最高的APP_VERSION
				List<AppVersion> appVersionList = appVersionService.findAppVerByVersion(appInfo.getAppPackage());
				if (CollectionUtils.isEmpty(appVersionList)) {
					return ResultGenerator.genFailResult(releaseFail);
				}
				AppVersion appVersion = appVersionList.get(0);
				// 通过id查找出策略
				Strategy strategy = new Strategy();
				strategy.setId(strategyId);
				if (!"a".equals(strategyId)) {
					strategy = strategyService.get(strategyId);
				}
				deviceCount = appDeviceService.saveAllAppDevice(device, isJPushMessage, appVersion.getId(), strategy,
						upType);
				clearCacheDeviceSn();
			} catch (Exception e) {
				logger.error("error realease {}", e.getMessage());
				return ResultGenerator.genFailResult(e.getMessage());
			}
		}
		return ResultGenerator.genSuccessResult(releaseSuccess + deviceCount + message);
	}

	/**
	 * 清除设备SN缓存
	 */
	private void clearCacheDeviceSn() {
		String cacheKey = Constant.DEVICE_SN_APP + UserUtils.getUser().getId();
		CacheUtils.remove(cacheKey);
	}

	/**
	 * 发布系统版本给指定类型的设备
	 * 
	 * @param ids
	 * @return
	 */

	@RequestMapping(value = "saveAppDeviceByType/{appId}")
	public @ResponseBody Result saveRomDeviceByType(@PathVariable("appId") String appId, String manuNosAndTypes,
			Device device, String isJPushMessage) {
		String releaseFail = messageSourceUtil.getMessage("common.release.fail");
		String releaseSuccess = messageSourceUtil.getMessage("common.release.success");
		String message = messageSourceUtil.getMessage("modules.app.release.fail.device");
		int devicesCount = 0;
		if (manuNosAndTypes != null) {
			try {
				devicesCount = appDeviceService.saveAppDeviceByType(appId, device, manuNosAndTypes, isJPushMessage);
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
				return ResultGenerator.genFailResult(releaseFail);
			}
		}
		if (devicesCount == 0) {
			String notRequireRelease = messageSourceUtil.getMessage("modules.app.not.require.release");
			return ResultGenerator.genSuccessResult(notRequireRelease);
		}
		return ResultGenerator.genSuccessResult(releaseSuccess + devicesCount + message);
	}

	/**
	 * 所有页全选通过设备类型发布
	 * 
	 * @param device
	 * @param jPushDes
	 * @return
	 */
	@RequestMapping(value = "saveAllAppDeviceByType")
	public @ResponseBody Result saveAllAppDeviceByType(Device device, String isJPushMessage) {
		String releaseSuccess = messageSourceUtil.getMessage("common.release.success");
		String message = messageSourceUtil.getMessage("modules.app.release.fail.device");
		int devicesCount = 0;
		if (device != null) {
			try {
				devicesCount = appDeviceService.saveAppAllDeviceByType(device, isJPushMessage);
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
				return ResultGenerator.genFailResult(e.getMessage());
			}
		}
		if (devicesCount == 0) {
			String notRequireRelease = messageSourceUtil.getMessage("modules.app.not.require.release");
			return ResultGenerator.genSuccessResult(notRequireRelease);
		}
		return ResultGenerator.genSuccessResult(releaseSuccess + devicesCount + message);
	}

	/**
	 * 选择策略
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "strategySelect")
	public String strategySelect(Model model) {
		List<Dict> upTypeList = DictUtils.getDictList("app_upflag");
		model.addAttribute("upTypeList", upTypeList);

		Strategy strategy = new Strategy();
		strategy.setOrganId(UserUtils.getUser().getOfficeId());
		List<Strategy> strategyList = strategyService.findList(strategy);
		model.addAttribute("strategyList", strategyList);
		return "modules/app/appManage/strategySelect";
	}

}
