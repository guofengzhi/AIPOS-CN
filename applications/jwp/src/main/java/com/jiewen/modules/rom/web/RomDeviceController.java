package com.jiewen.modules.rom.web;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
import com.jiewen.modules.baseinfo.entity.Strategy;
import com.jiewen.modules.baseinfo.service.StrategyService;
import com.jiewen.modules.device.entity.Device;
import com.jiewen.modules.rom.entity.RomDevice;
import com.jiewen.modules.rom.service.RomDeviceService;
import com.jiewen.modules.sys.utils.UserUtils;

@Controller
@RequestMapping("${adminPath}/romDevice")
public class RomDeviceController extends BaseController {

    @Autowired
    private RomDeviceService romDeviceService;

    @Autowired
    private StrategyService strategyService;

    @RequestMapping(value = "index")
    public String index() {
        return "modules/device/romDeviceList";
    }

    @RequestMapping(value = { "list", "" })
    @ResponseBody
    public Map<String, Object> list(String reqObj) throws Exception {
        RomDevice romDevice = new ParamResult<RomDevice>(reqObj).getEntity(RomDevice.class);
        PageInfo<RomDevice> pageInfo = romDeviceService.findPage(romDevice);
        return resultMap(romDevice, pageInfo);
    }

    /**
     * 发布系统版本给指定id的设备
     * 
     * @param ids
     * @return
     */

    @RequestMapping(value = "saveRomDevice/{romId}")
    public @ResponseBody Result saveRomDevice(@PathVariable("romId") String romId,
            String strategyId, String ids, String isJPushMessage) {
        String releaseFail = messageSourceUtil.getMessage("common.release.fail");
        String notNeedRelease = messageSourceUtil.getMessage("modules.rom.not.need.release");
        String releaseSuccess = messageSourceUtil.getMessage("common.release.success");
        String deviceNum = messageSourceUtil.getMessage("modules.rom.device.num");

        Integer deviceCount = 0;
        if (ids != null) {
            try {
                // 通过id查找出策略
                Strategy strategy = new Strategy();
                strategy.setId(strategyId);
                if (!"a".equals(strategyId)) {
                    strategy = strategyService.get(strategyId);
                }
                deviceCount = romDeviceService.saveRomDevice(romId, ids, isJPushMessage, strategy);
                clearCacheDeviceSn();
            } catch (Exception e) {
                logger.error(e.getMessage(), e);
                return ResultGenerator.genFailResult(releaseFail);
            }
        }
        if (deviceCount == 0) {
            return ResultGenerator.genSuccessResult(notNeedRelease);
        }
        return ResultGenerator.genSuccessResult(releaseSuccess + deviceCount + deviceNum);
    }

    /**
     * 所有页全选
     * 
     * @param device
     * @param jPushDes
     * @return
     */
    @RequestMapping(value = "saveAllRomDevice")
    public @ResponseBody Result saveAllRomDevice(Device device, String strategyId,
            String isJPushMessage) {
        String notNeedRelease = messageSourceUtil.getMessage("modules.rom.not.need.release");
        String releaseSuccess = messageSourceUtil.getMessage("common.release.success");
        String deviceNum = messageSourceUtil.getMessage("modules.rom.device.num");

        Integer deviceCount = 0;
        if (device != null) {
            try {

                // 通过id查找出策略
                Strategy strategy = new Strategy();
                strategy.setId(strategyId);
                if (!"a".equals(strategyId)) {
                    strategy = strategyService.get(strategyId);
                }
                deviceCount = romDeviceService.saveAllRomDevice(device, isJPushMessage, strategy);
                clearCacheDeviceSn();
            } catch (Exception e) {
                logger.error(e.getMessage(), e);
                return ResultGenerator.genFailResult(e.getMessage());
            }
        }
        if (deviceCount == 0) {
            return ResultGenerator.genSuccessResult(notNeedRelease);
        }
        return ResultGenerator.genSuccessResult(releaseSuccess + deviceCount + deviceNum);
    }

    /**
     * 清除设备SN缓存
     */
    private void clearCacheDeviceSn() {
        String cacheKey = Constant.DEVICE_SN_ROM + UserUtils.getUser().getId();
        CacheUtils.remove(cacheKey);
    }

    /**
     * 选择策略
     * 
     * @param model
     * @return
     */
    @RequestMapping(value = "strategySelect")
    public String strategySelect(Model model) {
        List<Strategy> strategyList = strategyService.findList(new Strategy());
        model.addAttribute("strategyList", strategyList);
        return "modules/romRelease/strategySelect";
    }

    /**
     * 选择发布方法
     * 
     * @param model
     * @return
     */
    @RequestMapping(value = "releaseTypeSelect")
    public String releaseTypeSelect(Model model) {
        return "modules/romRelease/releaseTypeSelect";
    }

}
