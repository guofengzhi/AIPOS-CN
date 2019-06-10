
package com.jiewen.base.sys.web;

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
import com.jiewen.base.sys.entity.Store;
import com.jiewen.base.sys.service.OfficeService;
import com.jiewen.base.sys.service.SystemService;
import com.jiewen.base.sys.utils.UserUtils;
import com.jiewen.jwp.common.utils.StringUtils;
import com.jiewen.jwp.common.utils.csrf.annotation.RefreshCSRFToken;
import com.jiewen.jwp.common.utils.csrf.annotation.VerifyCSRFToken;
import com.jiewen.spp.modules.device.entity.Device;

/**
 * 商户Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/store")
public class StoreController extends BaseController {

    @Autowired
    private SystemService systemService;
    
    @Autowired
    private OfficeService officeService;
    
    @RequiresPermissions("sys:store:view")
    @RequestMapping(value = { "index" })
    public String index(Store store, Model model) {
        return "modules/sys/storeList";
    }

    @RequiresPermissions("sys:store:view")
    @RequestMapping(value = { "list", "" })
    public @ResponseBody Map<String, Object> list(String reqObj) throws Exception {
    	Store store = new ParamResult<Store>(reqObj).getEntity(Store.class);
    	String orgId = UserUtils.getUser().getOfficeId();
    	if(StringUtils.isEmpty(store.getOrgId())){
    		store.setOrgId(orgId);
    	}
    	PageInfo<Store> findStorePage = systemService.findStorePage(store);
        return resultMap(store, findStorePage);
    }
    
    
    @RefreshCSRFToken
    @RequiresPermissions("sys:store:view")
    @RequestMapping(value = "toBoundStoreTerm")
    public String toBoundStoreTerm( Model model,HttpServletRequest request) {
    	String officeId = UserUtils.getUser().getOfficeId();
    	Device device = new Device();
    	List<Device> unBoundTerms=systemService.getUnBoundStoreTerms(device);
    	Store store = new Store();
    	store.setOrgId(officeId);
    	List<Store> stores = systemService.getAllStore(store);
    	model.addAttribute("unBoundTerms", unBoundTerms);
    	model.addAttribute("stores", stores);
        return "modules/sys/boundStoreTermList";
    }
    
    @RequiresPermissions("sys:store:view")
    @RequestMapping(value = "boundTermList")
    public @ResponseBody Map<String, Object> boundTermList(String reqObj) throws Exception {
    	DeviceMerchant deviceMerchant = new ParamResult<DeviceMerchant>(reqObj).getEntity(DeviceMerchant.class);
    	PageInfo<DeviceMerchant> findDeviceStorePage = systemService.findDeviceStorePage(deviceMerchant);
    	return resultMap(deviceMerchant, findDeviceStorePage);
    }
    
    @RefreshCSRFToken
    @RequiresPermissions("sys:store:view")
    @RequestMapping(value = "form")
    public String form(Store store, Model model,HttpServletRequest request) {
    	request.setAttribute("mapType", mapType);
    	String id = request.getParameter("id");
    	String updateflag = "false";
    	if(StringUtils.isNotEmpty(id)){
    		updateflag = "true";
    		store = systemService.getStoreById(id);
    	}
    	String officeId = UserUtils.getUser().getOfficeId();
    	Merchant merParam = new Merchant();
    	merParam.setOrgId(officeId);
    	List<Merchant> merchants = systemService.getAllMerchant(merParam);
    	Office officeParam = new Office();
		officeParam.setId(store.getOrgId());
		Office office = officeService.getOffice(officeParam);
		if (office != null) {
			store.setOrgName(office.getName());
		}
        model.addAttribute("store", store);
        model.addAttribute("updateflag", updateflag);
        model.addAttribute("id", id);
        model.addAttribute("merchants", merchants);
        if(StringUtils.isNotEmpty(mapType)){
			if(StringUtils.equals(mapType, "google")){
				return "modules/sys/storeFormEn";
			}
		}
        return "modules/sys/storeForm";
    }
    
    @RequiresPermissions("sys:store:edit")
    @RequestMapping(value = "update")
    @VerifyCSRFToken
    public @ResponseBody Result updateMerchant(Store store, Model model,HttpServletRequest request) {
    	String id = request.getParameter("id");
    	store.setId(id);
    	systemService.updateStore(store);
    	return ResultGenerator.genSuccessResult();
    }
    
    @RequiresPermissions("sys:store:edit")
    @RequestMapping(value = "add")
    @VerifyCSRFToken
    public @ResponseBody Result addStore(Store store, Model model) {
    	if(store!=null&&StringUtils.isNotEmpty(store.getMerId())&&StringUtils.isNotEmpty(store.getStoreId())){
    		systemService.addStore(store);
    	}
    	return ResultGenerator.genSuccessResult();
    }
    
    @RequiresPermissions("sys:merchant:edit")
    @RequestMapping(value = "boundOneStoreTerm")
    @VerifyCSRFToken
    public @ResponseBody Result boundOneTerm(Model model,HttpServletRequest request) {
    	String sid = request.getParameter("storeId");
    	String sn = request.getParameter("sn");
    	if(StringUtils.isEmpty(sn)){
    		return ResultGenerator.genFailResult("sn号为空");
    	}
    	if(StringUtils.isEmpty(sid)){
    		return ResultGenerator.genFailResult("门店号为空");
    	}
    	DeviceMerchant dm = systemService.getBoundTermBySn(sn);
    	if(dm!=null){
    		String storeId = dm.getStoreId();
    		if(StringUtils.isEmpty(storeId)){
    			dm.setStoreId(sid);
    			systemService.updateDeviceMerchant(dm);
    		}
    	}else{
    		Store store = systemService.getStoreByStoreId(sid);
    		systemService.boundOneTerm(store.getMerId(),sn,store.getStoreId());
    	}
		return ResultGenerator.genSuccessResult();
    }
    
    @RequiresPermissions("sys:store:edit")
	@RequestMapping(value = "delete")
	@ResponseBody
	public Result delete(String id) {
		systemService.deleteStore(id);
		String deleteSuccess = messageSourceUtil.getMessage("sys.store.promt.delete.success");
		return ResultGenerator.genSuccessResult(deleteSuccess);
	}
    
    @RequiresPermissions("sys:store:view")
  	@RequestMapping(value = "stores")
  	@ResponseBody
  	public Result stores(HttpServletRequest reqeust) {
    	String merId = reqeust.getParameter("merId");
    	Store store = new Store();
    	store.setMerId(merId);
    	List<Store> allStore = systemService.getAllStore(store);
  		return ResultGenerator.genSuccessResult(allStore);
  	}
    
    @ResponseBody
    @RequiresPermissions("sys:store:edit")
    @RequestMapping(value = "checkStoreId")
    public Map<String,Boolean> checkStoreId(String storeId) {
       Store store = systemService.getStoreByStoreId(storeId);
       Map<String, Boolean> map = new HashMap<String,Boolean>();
        boolean valid = false;
        if(store==null){
        	valid=true;
        }
        map.put("valid", valid);
        return map;
    }
}
