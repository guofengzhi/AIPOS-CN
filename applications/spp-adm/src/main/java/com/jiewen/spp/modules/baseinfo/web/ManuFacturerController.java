
package com.jiewen.spp.modules.baseinfo.web;

import java.util.HashMap;
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
import com.jiewen.spp.modules.baseinfo.entity.ManuFacturer;
import com.jiewen.spp.modules.baseinfo.service.ManuFacturerService;

@Controller
@RequestMapping("${adminPath}/manuFacturer")
public class ManuFacturerController extends BaseController {

    @Autowired
    private ManuFacturerService manuFacturerService;

    @RequestMapping(value = "index")
    public String index() {
        return "modules/manuFacturer/manuFacturerList";
    }
    
    @ResponseBody
	@RequiresPermissions("maun:view")
	@RequestMapping(value = "checkManufacturerNo")
	public Map<String, Boolean> checkManufacturerNo(String manufacturerNo) {
		ManuFacturer findManuFacturerByNo = manuFacturerService.findManuFacturerByNo(manufacturerNo);
		Map<String, Boolean> map = new HashMap<String, Boolean>();
		boolean valid = false;
		if (findManuFacturerByNo == null) {
			valid = true;
		}
		map.put("valid", valid);
		return map;
	}

    @ModelAttribute
    public ManuFacturer get(@RequestParam(required = false) String id) {
        if (!StringUtils.isBlank(id)) {
            ManuFacturer manuFacturer = new ManuFacturer();
            manuFacturer.setId(id);
            return manuFacturerService.getManuFacturerById(manuFacturer);
        } else {
            return new ManuFacturer();
        }
    }

    @RequiresPermissions("maun:view")
    @RequestMapping(value = { "list", "" })
    @ResponseBody
    public Map<String, Object> list(String reqObj) throws Exception {
        ManuFacturer manuFacturer = new ParamResult<ManuFacturer>(reqObj)
                .getEntity(ManuFacturer.class);
        PageInfo<ManuFacturer> pageInfo = manuFacturerService.findPage(manuFacturer);
        return resultMap(manuFacturer, pageInfo);
    }

    @RequiresPermissions("maun:edit")
    @RequestMapping(value = "delete")
    public @ResponseBody Result delete(ManuFacturer manuFacturer) {
        String deleteFail = messageSourceUtil.getMessage("common.deleteFail");
        String deleteSuccess = messageSourceUtil.getMessage("common.deleteSuccess");
        try {
            manuFacturerService.deleteById(manuFacturer);
        } catch (Exception e) {
            return ResultGenerator.genFailResult(deleteFail);
        }
        return ResultGenerator.genSuccessResult(deleteSuccess);
    }

    @RequiresPermissions("maun:edit")
    @RequestMapping(value = "form/{option}")
    public String form(@PathVariable String option, ManuFacturer manuFacturer, Model model) {
        model.addAttribute("manuFacturer", manuFacturer);
        model.addAttribute("option", option);
        return "modules/manuFacturer/manuFacturerForm";
    }

    @RequiresPermissions("maun:edit")
    @RequestMapping(value = { "save", "" })
    @ResponseBody
    public Result save(ManuFacturer manuFacturer) throws Exception {
        String saveSuccess = messageSourceUtil.getMessage("common.saveSuccess");
        String updateSuccess = messageSourceUtil.getMessage("common.updateSuccess");
        if (manuFacturer.getId() == null) {

            ManuFacturer findManuFacturerByNo = manuFacturerService
                    .findManuFacturerByNo(manuFacturer.getManufacturerNo());
            if (findManuFacturerByNo != null) {
                String message = messageSourceUtil.getMessage("modules.baseinfo.vendor.sn.exist");
                return ResultGenerator.genFailResult(message);
            }

            ManuFacturer findManuFacturerByName = manuFacturerService
                    .findManuFacturerByName(manuFacturer.getManufacturerName());
            if (findManuFacturerByName != null) {
                String message = messageSourceUtil.getMessage("modules.baseinfo.vendor.name.exist");
                return ResultGenerator.genFailResult(message);
            }

            manuFacturerService.saveManuFacturer(manuFacturer);
            return ResultGenerator.genSuccessResult(saveSuccess);
        }
        manuFacturerService.update(manuFacturer);
        return ResultGenerator.genSuccessResult(updateSuccess);
    }

}
