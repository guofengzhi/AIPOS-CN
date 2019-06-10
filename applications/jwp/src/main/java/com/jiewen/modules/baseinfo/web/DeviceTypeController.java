package com.jiewen.modules.baseinfo.web;

import java.util.ArrayList;
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
import com.jiewen.modules.baseinfo.entity.ManuFacturer;
import com.jiewen.modules.baseinfo.service.DeviceTypeService;
import com.jiewen.modules.baseinfo.service.ManuFacturerService;

@Controller
@RequestMapping("${adminPath}/deviceType")
public class DeviceTypeController extends BaseController {

    @Autowired
    private DeviceTypeService deviceTypeService;

    @Autowired
    private ManuFacturerService manuFacturerService;

    @RequestMapping(value = "index")
    public String index(Model model) {
        List<DeviceType> deviceTypeList = deviceTypeService.getDeviceTypeList();
        model.addAttribute("deviceTypeList", deviceTypeList);
        List<ManuFacturer> manuFacturerList = manuFacturerService.findList();
        model.addAttribute("manuFacturerList", manuFacturerList);
        return "modules/deviceType/deviceTypeList";
    }

    @ModelAttribute
    public DeviceType get(@RequestParam(required = false) String id) {
        if (!StringUtils.isBlank(id)) {
            DeviceType deviceType = new DeviceType();
            deviceType.setId(id);
            return deviceTypeService.get(deviceType);
        } else {
            return new DeviceType();
        }
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
	@RequestMapping(value = "DeviceEditOrAdd")
	@ResponseBody
	public DeviceType form(String id, Model model) {
    	DeviceType deviceType = new DeviceType();
		if (org.apache.commons.lang3.StringUtils.isNotBlank(id)) {
			deviceType = deviceTypeService.get(id);
		}
		return deviceType;
	}
	
	
    @RequiresPermissions("device:type:view")
    @RequestMapping(value = { "list", "" })
    @ResponseBody
    public Map<String, Object> list(String reqObj) throws Exception {
        DeviceType deviceType = new ParamResult<DeviceType>(reqObj).getEntity(DeviceType.class);
        PageInfo<DeviceType> pageInfo = deviceTypeService.findPage(deviceType);
        return resultMap(deviceType, pageInfo);
    }

    @RequiresPermissions("device:type:edit")
    @RequestMapping(value = "delete")
    public @ResponseBody Result delete(DeviceType deviceType) {
        String deleteFail = messageSourceUtil.getMessage("common.deleteFail");
        String deleteSuccess = messageSourceUtil.getMessage("common.deleteSuccess");
        try {
            deviceTypeService.deleteById(deviceType);
        } catch (Exception e) {
            return ResultGenerator.genFailResult(deleteFail);
        }
        return ResultGenerator.genSuccessResult(deleteSuccess);
    }

    @RequiresPermissions("device:type:edit")
    @RequestMapping(value = "form/{option}")
    public String form(@PathVariable String option, DeviceType deviceType, Model model) {

        List<ManuFacturer> manuFacturerList = manuFacturerService.findList();
        model.addAttribute("manuFacturerList", manuFacturerList);
        model.addAttribute("deviceType", deviceType);
        model.addAttribute("option", option);
        return "modules/deviceType/deviceTypeForm";
    }

	/**
	 * 验证名称是否存在
	 * @param oldValue
	 * @param newValue
	 * @return
	 */
	@ResponseBody
	@RequiresPermissions("device:type:edit")
	@RequestMapping(value = "checkName")
	public Map<String, Boolean> checkNameAddOrUpdate(String oldValueNo, String newValueNo,String oldValueType,String newValueType) {
		
		Map<String, Boolean> map = new HashMap<>();
		
		DeviceType deviceType= new DeviceType();
		deviceType.setManufacturerNo(newValueNo);
		deviceType.setDeviceType(newValueType);
		deviceType = deviceTypeService.findDeviceTypeByType(deviceType);
		if (deviceType != null) {
			if(oldValueNo !=null && !"".equals(oldValueNo) & oldValueType !=null && !"".equals(oldValueType) ){//修改判断
				if(oldValueNo.equals(newValueNo) && oldValueType.equals(newValueType) ){//设备型号未修改，可以插入
					  map.put("valid", true);
				}else{//修改后的设备型号存在，不可修改
					map.put("valid", false);
				}
			}else{//新增，设备型号存在，不可新增
				map.put("valid", false);
			}
		}else{//设备型号不存在，可以新增
			    map.put("valid", true);
		}
		return map;
	}
	
    @RequiresPermissions("device:type:edit")
    @RequestMapping(value = { "save", "" })
    @ResponseBody
    public Result save(DeviceType deviceType) {
        String saveSuccess = messageSourceUtil.getMessage("common.saveSuccess");
        String updateSuccess = messageSourceUtil.getMessage("common.updateSuccess");
        if (deviceType.getId() == null) {

            DeviceType deviceTypeByType = deviceTypeService.findDeviceTypeByType(deviceType);
            if (deviceTypeByType != null) {
                String message = messageSourceUtil.getMessage("modules.baseinfo.model.already.exist");
                return ResultGenerator.genFailResult(message);
            }
            deviceTypeService.saveDeviceType(deviceType);
            return ResultGenerator.genSuccessResult(saveSuccess);
        }
        deviceTypeService.update(deviceType);
        return ResultGenerator.genSuccessResult(updateSuccess);
    }

    @RequestMapping(value = { "getDeviceTypeByManuNo", "" })
    @ResponseBody
    public Result getDeviceTypeByManuNo(String manufacturerNo) {
        List<DeviceType> deviceTypes = new ArrayList<>();
        try {
            DeviceType deviceType = new DeviceType();
            deviceType.setManufacturerNo(manufacturerNo);
            deviceTypes = deviceTypeService.getDeviceTypeByManuNo(deviceType);
        } catch (Exception e) {
            String message = messageSourceUtil.getMessage("modules.baseinfo.vendor.type.error");
            return ResultGenerator.genFailResult(message);
        }
        return ResultGenerator.genSuccessResult(deviceTypes);
    }

    @RequestMapping(value = { "getDeviceTypeByManuNos", "" })
    @ResponseBody
    public Result getDeviceTypeByManuNos(String manufacturerNos, String apkId) {
        Map<String, List<DeviceType>> deviceTypeMap = new HashMap<>();
        try {
            String manufacturerNo = StringUtils.isNotBlank(manufacturerNos) ? manufacturerNos
                    : StringUtils.EMPTY;
            String[] manuNos = StringUtils.split(manufacturerNo, ',');
            DeviceType deviceType = new DeviceType();
            List<DeviceType> deviceTypes;
            for (String manuNo : manuNos) {
                deviceType.setManufacturerNo(manuNo);
                deviceType.setApkId(apkId);
                deviceTypes = deviceTypeService.getDeviceTypeByManuNo(deviceType);
                deviceTypeMap.put(manuNo, deviceTypes);
            }
        } catch (Exception e) {
            String message = messageSourceUtil.getMessage("modules.baseinfo.vendor.type.error");
            return ResultGenerator.genFailResult(message);
        }
        return ResultGenerator.genSuccessResult(deviceTypeMap);
    }

}
