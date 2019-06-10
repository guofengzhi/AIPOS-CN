
package com.jiewen.spp.modules.rom.web;

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
import com.jiewen.jwp.common.utils.DateUtils;
import com.jiewen.spp.modules.baseinfo.entity.DeviceType;
import com.jiewen.spp.modules.baseinfo.entity.ManuFacturer;
import com.jiewen.spp.modules.baseinfo.service.DeviceTypeService;
import com.jiewen.spp.modules.baseinfo.service.ManuFacturerService;
import com.jiewen.spp.modules.rom.entity.RecordRomInfo;
import com.jiewen.spp.modules.rom.service.RecordRomInfoService;

@Controller
@RequestMapping("${adminPath}/recordRom")
public class RecordRomController extends BaseController {

    @Autowired
    private DeviceTypeService deviceTypeService;

    @Autowired
    private ManuFacturerService manuFacturerService;

    @Autowired
    private RecordRomInfoService recordRomInfoService;

    @RequestMapping(value = "index")
    public String index(Model model) {
        List<DeviceType> deviceTypeList = deviceTypeService.getDeviceTypeList();
        model.addAttribute("deviceTypeList", deviceTypeList);
        List<ManuFacturer> manuFacturerList = manuFacturerService.findList();
        model.addAttribute("manuFacturerList", manuFacturerList);
        return "modules/recordRom/recordRomList";
    }

    @RequestMapping(value = { "list", "" })
    @ResponseBody
    public Map<String, Object> list(String reqObj) {
        RecordRomInfo recordRomInfo = new ParamResult<RecordRomInfo>(reqObj)
                .getEntity(RecordRomInfo.class);

        if (recordRomInfo.getEndDate() != null && recordRomInfo.getBeginDate() != null
                && DateUtils.isSameDay(recordRomInfo.getBeginDate(), recordRomInfo.getEndDate())) {
            recordRomInfo.setEndDate(DateUtils.addDays(recordRomInfo.getBeginDate(), 1));
        }
        PageInfo<RecordRomInfo> pageInfo = recordRomInfoService.findPage(recordRomInfo);
        return resultMap(recordRomInfo, pageInfo);
    }

    /**
     * 去已发布系统版本页面
     * 
     * @param id
     * @param osDeviceType
     * @param model
     * @return
     */
    @RequestMapping("alreadyRomList")
    public String releaseAlreadyEdition(Integer id, Model model) {
        model.addAttribute("recordRomId", id);
        List<DeviceType> deviceTypeList = deviceTypeService.getDeviceTypeList();
        model.addAttribute("deviceTypeList", deviceTypeList);
        List<ManuFacturer> manuFacturerList = manuFacturerService.findList();
        model.addAttribute("manuFacturerList", manuFacturerList);
        return "modules/recordRom/recordDeviceList";
    }

}
