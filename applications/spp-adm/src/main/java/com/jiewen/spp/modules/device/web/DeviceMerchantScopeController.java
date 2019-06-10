
package com.jiewen.spp.modules.device.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.jiewen.base.core.web.BaseController;
import com.jiewen.base.sys.entity.Merchant;
import com.jiewen.base.sys.entity.User;
import com.jiewen.base.sys.service.SystemService;
import com.jiewen.base.sys.utils.UserUtils;
import com.jiewen.commons.util.StringUtil;
import com.jiewen.jwp.common.utils.StringUtils;
import com.jiewen.spp.modules.device.entity.Device;
import com.jiewen.spp.modules.device.service.DeviceService;

@Controller
@RequestMapping("${adminPath}/scope")
public class DeviceMerchantScopeController extends BaseController {
	
	@Autowired
	private SystemService systemService;

	@Autowired
	private DeviceService deviceService;
	
	@RequiresPermissions("sys:location:view")
	@RequestMapping(value = "index")
	public String index(Model model,HttpServletRequest request) {
		User user = UserUtils.getUser();
		Merchant merParam = new Merchant();
		merParam.setOrgId(user.getOfficeId());
		List<Merchant> allMerchant = systemService.getAllMerchant(merParam);
		Gson gson = new Gson();
		String mers = gson.toJson(allMerchant);
		model.addAttribute("merchants", mers);
		if(StringUtils.isNotEmpty(mapType)){
			if(StringUtils.equals(mapType, "google")){
				return "modules/device/deviceMerchantScopeEn";
			}
		}
		return "modules/device/deviceMerchantScope";
	}
	
	@RequiresPermissions("sys:location:view")
	@RequestMapping(value = "terms")
	@ResponseBody
	public String terms(Model model,HttpServletRequest request) {
		String merId = request.getParameter("merId");
		String orgId = request.getParameter("orgId");
		User user = UserUtils.getUser();
		Device device = new Device();
		device.setOrganId(orgId);
		if(StringUtil.isEmpty(orgId)){
			device.setOrganId(user.getOfficeId());
		}
		device.setMerId(merId);
		device.setDeviceBundState("1");
		List<Device> orgDevices = deviceService.getOrgDevices(device);
		Gson gson = new Gson();
		return gson.toJson(orgDevices);
	}
	
	@RequiresPermissions("sys:location:view")
	@RequestMapping(value = "merchants")
	@ResponseBody
	public String merchants(Model model,HttpServletRequest request) {
		String merId = request.getParameter("merId");
		String orgId = request.getParameter("orgId");
		User user = UserUtils.getUser();
		Merchant merchant = new Merchant();
		merchant.setOrgId(orgId);
		if(StringUtil.isEmpty(orgId)){
			merchant.setOrgId(user.getOfficeId());
		}
		merchant.setMerId(merId);
		List<Merchant> merchants = systemService.getAllMerchant(merchant);
		Gson gson = new Gson();
		return gson.toJson(merchants);
	}
}
