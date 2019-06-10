
package com.jiewen.base.sys.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageInfo;
import com.jiewen.base.core.web.BaseController;
import com.jiewen.base.core.web.ParamResult;
import com.jiewen.base.core.web.Result;
import com.jiewen.base.core.web.ResultGenerator;
import com.jiewen.base.sys.entity.DeviceMerchant;
import com.jiewen.base.sys.entity.Merchant;
import com.jiewen.base.sys.entity.Office;
import com.jiewen.base.sys.entity.TagManager;
import com.jiewen.base.sys.entity.User;
import com.jiewen.base.sys.service.OfficeService;
import com.jiewen.base.sys.service.SystemService;
import com.jiewen.base.sys.utils.UserUtils;
import com.jiewen.jwp.common.utils.StringUtils;
import com.jiewen.jwp.common.utils.csrf.annotation.RefreshCSRFToken;
import com.jiewen.jwp.common.utils.csrf.annotation.VerifyCSRFToken;
import com.jiewen.spp.modules.device.entity.Device;

/**
 * 标签管理Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/tagManager")
public class TagManagerController extends BaseController {

    @Autowired
    private SystemService systemService;
    
    @Autowired
    private OfficeService officeService;
    
    @RequiresPermissions("sys:tagManager:view")
    @RequestMapping(value = { "index" })
    public String index(Merchant merchant, Model model) {
        return "modules/sys/tagManageList";
    }

    @RequiresPermissions("sys:tagManager:view")
    @RequestMapping(value = { "list", "" })
    public @ResponseBody Map<String, Object> list(String reqObj) throws Exception {
    	TagManager tagManager = new ParamResult<TagManager>(reqObj).getEntity(TagManager.class);
    	User user = UserUtils.getUser();
    	if(user!=null){
    		tagManager.setOrgId(user.getOfficeId());
    	}
    	PageInfo<TagManager> findMerchantPage = systemService.findTagManagerPage(tagManager);
        return resultMap(tagManager, findMerchantPage);
    }
    @RequiresPermissions("sys:tagManager:view")
    @RequestMapping(value = "boundTermList")
    public @ResponseBody Map<String, Object> boundTermList(String reqObj) throws Exception {
    	DeviceMerchant deviceMerchant = new ParamResult<DeviceMerchant>(reqObj).getEntity(DeviceMerchant.class);
    	PageInfo<DeviceMerchant> findDeviceMerchantPage = systemService.findDeviceMerchantPage(deviceMerchant);
    	return resultMap(deviceMerchant, findDeviceMerchantPage);
    }
    
    @RefreshCSRFToken
    @RequiresPermissions("sys:tagManager:view")
    @RequestMapping(value = "form")
    public String form(TagManager tagManager, Model model,HttpServletRequest request) {
    	String tagId = request.getParameter("id");
    	String updateflag = "false";
    	if(StringUtils.isNotEmpty(tagId)){
    		updateflag = "true";
    		tagManager = systemService.getTagManagerByTagId(tagId);
    	}
        model.addAttribute("updateflag", updateflag);
        model.addAttribute("id", tagId);
        Office officeParam = new Office();
		officeParam.setId(tagManager.getOrgId());
		Office office = officeService.getOffice(officeParam);
		if (office != null) {
			tagManager.setOrgName(office.getName());
		}
        model.addAttribute("tagManager", tagManager);
        return "modules/sys/tagManagerForm";
    }
    
    @RequiresPermissions("sys:tagManager:edit")
    @RequestMapping(value = "add")
	@ResponseBody
    public Result addTagManager(TagManager tagManager, Model model) {
    	if(tagManager!=null&&StringUtils.isNotEmpty(tagManager.getTagName())&&StringUtils.isNotEmpty(tagManager.getOrgId())){
    		systemService.addTagManager(tagManager);
    	}
    	
    	return ResultGenerator.genSuccessResult();
    }
 
    @RequiresPermissions("sys:tagManager:edit")
    @RequestMapping(value = "update")
	@ResponseBody
    public Result updateTagManager(TagManager tagManager, Model model,HttpServletRequest request) {
    	String id = request.getParameter("id");
    	tagManager.setId(id);
    	systemService.updateTagManager(tagManager);
    	
    	return ResultGenerator.genSuccessResult();
    }

    @ResponseBody
    @RequiresPermissions("sys:tagManager:edit")
	@RequestMapping(value = "checkTagManagerName")
	public Map<String, Boolean> checkTagManagerName(String tagId,String tagName,String orgId ) {

    	TagManager param = new TagManager();
    	param.setId(tagId);
    	param.setOrgId(orgId);
    	param.setTagName(tagName);
		TagManager tagManager = systemService.getTagManagerByTag(param);
		Map<String, Boolean> map = new HashMap<String, Boolean>();
		boolean valid = false;
		if (tagManager == null) {
			valid = true;
		}
		map.put("valid", valid);
		return map;
	}
    @RequiresPermissions("sys:tagManager:edit")
    @RequestMapping(value = "boundOneTerm")
    @VerifyCSRFToken
    public @ResponseBody Result boundOneTerm(Model model,HttpServletRequest request) {
    	String merId = request.getParameter("merId");
    	String sn = request.getParameter("sn");
    	if(StringUtils.isEmpty(sn)){
    		return ResultGenerator.genFailResult("sn号为空");
    	}
    	if(StringUtils.isEmpty(merId)){
    		return ResultGenerator.genFailResult("商户号为空");
    	}
		return ResultGenerator.genSuccessResult();
    }
    
    @RequiresPermissions("sys:tagManager:edit")
	@RequestMapping(value = "delete")
	@ResponseBody
	public Result delete(String id) {
		systemService.deleteTagManager(id);
		String deleteSuccess = messageSourceUtil.getMessage("sys.tagManager.promt.delete.success");
		return ResultGenerator.genSuccessResult(deleteSuccess);
	}

	@RequiresPermissions("sys:tagManager:edit")
    @RequestMapping(value = "checkTagManagerBundTerm")
	@ResponseBody
    public Map<String, Boolean> checkTagManagerBundTerm(HttpServletRequest request) {
    	Map<String, Boolean> map = new HashMap<String, Boolean>();
    	String tagId = request.getParameter("tagId");
		List<TagManager> list = systemService.getTagManagerBundTermByTagId(tagId);
		if(list != null && list.size() != 0){
			map.put("hasDataFlag", false);
		}else{
			map.put("hasDataFlag", true);
		}
    	return map;
    }
    
    @RefreshCSRFToken
    @RequiresPermissions("sys:tagManager:view")
    @RequestMapping(value = "toBoundTermTagManager")
    public String merTermBoundImport( Model model,HttpServletRequest request) {
    	Device device = new Device();
    	List<Device> unBoundTerms=systemService.getUnBoundTerms(device);
    	Merchant merchant = new Merchant();
    	List<Merchant> merchants = systemService.getAllMerchant(merchant);
    	String id = request.getParameter("id");
    	model.addAttribute("unBoundTerms", unBoundTerms);
    	model.addAttribute("merchants", merchants);
    	model.addAttribute("id", id);
        return "modules/sys/tagManagerBundList";
    }
    
	@RequiresPermissions("sys:tagManager:view")
	@RequestMapping(value = "deviceBundList")
	public @ResponseBody Map<String, Object> listS(String reqObj,HttpServletRequest request) throws Exception {
		String mId = request.getParameter("mId");
		String sId = request.getParameter("sId");
		String tagId = request.getParameter("tagId");
		Device device = new ParamResult<Device>(reqObj).getEntity(Device.class);
		String officeId = UserUtils.getUser().getOfficeId();
		device.setOrganId(officeId);
		device.setmId(mId);
		device.setsId(sId);
		device.setLabels(tagId);//标签号注入到label字段
		PageInfo<Device> findTagManagerBundPage =systemService.findTagManagerDevicePage(device);
		return resultMap(device, findTagManagerBundPage);
	}
	
	 @RequiresPermissions("sys:tagManager:edit")
	@RequestMapping(value = "boundBatchTerm")
	@ResponseBody
	public Result boundBatchTerm(String[] ids,String tagId) {
		String officeId = UserUtils.getUser().getOfficeId();
		List<Device> deviceList = new ArrayList<Device>();
		for (String id : ids) {
			Device device = new Device();
			device.setId(id);
			device.setOrganId(officeId);
			device.setLabels(tagId);
			deviceList.add(device);
		}
		systemService.batchBundTagManagerDevice(deviceList);
		String deleteSuccess = messageSourceUtil.getMessage("sys.merchant.unBoundTerm.success");
		return ResultGenerator.genSuccessResult(deleteSuccess);
	}
	
	
	@RequiresPermissions("sys:tagManager:edit")
	@RequestMapping(value = "unBoundBatchTerm")
	@ResponseBody
	public Result unBoundBatchTerm(String[] ids,String tagId) {
		List<Device> deviceList = new ArrayList<Device>();
		for (String id : ids) {
			Device device = new Device();
			device.setId(id);
			device.setLabels(tagId);
			deviceList.add(device);
		}
		systemService.batchUnBundTagManagerDevice(deviceList);
		String deleteSuccess = messageSourceUtil.getMessage("sys.merchant.unBoundTerm.success");
		return ResultGenerator.genSuccessResult(deleteSuccess);
	}
}
