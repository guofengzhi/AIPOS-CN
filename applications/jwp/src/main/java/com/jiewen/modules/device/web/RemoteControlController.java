package com.jiewen.modules.device.web;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageInfo;
import com.jiewen.base.core.web.Result;
import com.jiewen.base.core.web.ResultGenerator;
import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.base.web.ParamResult;
import com.jiewen.modules.baseinfo.entity.DeviceType;
import com.jiewen.modules.baseinfo.entity.ManuFacturer;
import com.jiewen.modules.baseinfo.service.DeviceTypeService;
import com.jiewen.modules.baseinfo.service.ManuFacturerService;
import com.jiewen.modules.device.entity.Device;
import com.jiewen.modules.device.entity.Message;
import com.jiewen.modules.device.service.DeviceService;
import com.jiewen.modules.device.service.RemoteControlService;

@Controller
@RequestMapping("${adminPath}/control")
public class RemoteControlController extends BaseController {

    @Autowired
    private DeviceService deviceService;

    @Autowired
    private ManuFacturerService manuFacturerService;

    @Autowired
    private DeviceTypeService deviceTypeService;

    @Autowired
    private RemoteControlService remoteControlService;

    @RequestMapping(value = "index")
    public String index(Model model) {
        List<DeviceType> deviceTypeList = deviceTypeService.getDeviceTypeList();
        model.addAttribute("deviceTypeList", deviceTypeList);
        List<ManuFacturer> manuFacturerList = manuFacturerService.findList();
        model.addAttribute("manuFacturerList", manuFacturerList);
        return "modules/remote/remoteControlList";
    }

    @RequestMapping(value = { "list", "" })
    @ResponseBody
    public Map<String, Object> list(String reqObj) throws Exception {
        Device device = new ParamResult<Device>(reqObj).getEntity(Device.class);
        PageInfo<Device> pageInfo = deviceService.findPage(device);
        return resultMap(device, pageInfo);
    }

    /**
     * 指定id
     * 
     * @param ids
     * @param message
     * @param isAll
     * @param commandTye
     * @return
     */
    @RequestMapping(value = "sendCommand")
    public @ResponseBody Result sendCommand(String ids, Message message, String isAll,
            String commandType) {
        String success = messageSourceUtil.getMessage("modules.device.release.instruction.success");
        String fail = messageSourceUtil.getMessage("modules.device.release.instruction.fail");

        try {
            remoteControlService.executeComand(ids, message, isAll, commandType);
        } catch (Exception e) {
            logger.info(e.getMessage(), e);
            return ResultGenerator.genFailResult(fail);
        }
        return ResultGenerator.genSuccessResult(success);
    }

    /**
     * 所有页全选
     * 
     * @param device
     * @param jPushDes
     * @return
     */
    @RequestMapping(value = "sendCommandToAll")
    public @ResponseBody Result sendCommandToAll(Device device, String isJPushMessage) {
        String releaseSuccess = messageSourceUtil.getMessage("modules.device.release.success");

        if (device != null) {
            try {

                // romDeviceService.saveAllRomDevice(device, isJPushMessage,
                // strategy);

            } catch (Exception e) {
                logger.error(e.getMessage(), e);
                return ResultGenerator.genFailResult(e.getMessage());
            }
        }
        return ResultGenerator.genSuccessResult(releaseSuccess);
    }

}
