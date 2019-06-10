package com.jiewen.modules.rom.web;

import java.io.File;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.math.NumberUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.github.pagehelper.PageInfo;
import com.jiewen.base.core.web.Result;
import com.jiewen.base.core.web.ResultGenerator;
import com.jiewen.commons.ServerException;
import com.jiewen.commons.ServiceException;
import com.jiewen.jwp.base.config.Global;
import com.jiewen.jwp.base.constant.Constant;
import com.jiewen.jwp.base.utils.CacheUtils;
import com.jiewen.jwp.base.utils.UploadUtil;
import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.base.web.ParamResult;
import com.jiewen.jwp.common.FileUtils;
import com.jiewen.jwp.common.StringUtils;
import com.jiewen.modules.baseinfo.entity.DeviceType;
import com.jiewen.modules.baseinfo.entity.ManuFacturer;
import com.jiewen.modules.baseinfo.entity.Strategy;
import com.jiewen.modules.baseinfo.service.DeviceTypeService;
import com.jiewen.modules.baseinfo.service.ManuFacturerService;
import com.jiewen.modules.baseinfo.service.StrategyService;
import com.jiewen.modules.rom.entity.OsRomInfo;
import com.jiewen.modules.rom.service.OsRomInfoService;
import com.jiewen.modules.sys.entity.Dict;
import com.jiewen.modules.sys.utils.DictUtils;
import com.jiewen.modules.sys.utils.UserUtils;
import com.jiewen.modules.upload.entity.SysFile;

@Controller
@RequestMapping("${adminPath}/osRom")
public class OsRomInfoController extends BaseController {

    private static final String DEVICE_TYPE_LIST = "deviceTypeList";

    private static final String MANU_FACT_LIST = "manuFacturerList";

    private static final String INDUSTRY_LIST = "industryList";

    private static final String CLIENT_ID_LIST = "clientIdentifyList";

    private static final String PUBLISH_TYPE = "releaseType";

    @Autowired
    private OsRomInfoService osRomInfoService;

    @Autowired
    private ManuFacturerService manuFacturerService;

    @Autowired
    private DeviceTypeService deviceTypeService;

    @Autowired
    private StrategyService strategyService;

    /** 上传文件配置目录 */
    private static final String UPLOAERPATH = Global.getConfig("uploaderPath");

    List<ManuFacturer> getManufacturerList() {
        return manuFacturerService.findList();
    }

    List<DeviceType> getDeviceTypeList() {
        return deviceTypeService.getDeviceTypeList();
    }

    List<Strategy> getStrategyList() {
        return strategyService.findList(new Strategy());
    }

    @RequestMapping(value = "index")
    public String index(Model model) {
        model.addAttribute(DEVICE_TYPE_LIST, getDeviceTypeList());
        model.addAttribute(MANU_FACT_LIST, getManufacturerList());
        return "modules/osRom/osRomList";
    }

    @RequestMapping(value = "alreadyReleaseIndex")
    public String alreadyReleaseIndex(Model model) {
        model.addAttribute(DEVICE_TYPE_LIST, getDeviceTypeList());
        model.addAttribute(MANU_FACT_LIST, getManufacturerList());
        return "modules/romRelease/alreadyReleaseOsRomList";
    }

    @RequestMapping(value = "passiveReleaseIndex")
    public String passiveReleaseIndex(Model model) {
        model.addAttribute(DEVICE_TYPE_LIST, getDeviceTypeList());
        model.addAttribute(MANU_FACT_LIST, getManufacturerList());
        // 0:被动发布 1:主动发布
        model.addAttribute(PUBLISH_TYPE, "0");
        return "modules/romRelease/releaseOsRomList";
    }

    @RequestMapping(value = "activeReleaseIndex")
    public String activeReleaseIndex(Model model) {
        model.addAttribute(DEVICE_TYPE_LIST, getDeviceTypeList());
        model.addAttribute(MANU_FACT_LIST, getManufacturerList());
        // 0:被动发布 1:主动发布
        model.addAttribute(PUBLISH_TYPE, "1");
        return "modules/romRelease/releaseOsRomList";
    }

    @RequestMapping(value = "deviceRomIndex")
    public String deviceRomIndex(String id, Model model) {
        model.addAttribute("id", id);
        model.addAttribute(DEVICE_TYPE_LIST, getDeviceTypeList());
        model.addAttribute(MANU_FACT_LIST, getManufacturerList());
        return "modules/device/osRomRecordList";
    }

    @ModelAttribute
    public OsRomInfo get(@RequestParam(required = false) String id) {
        if (!StringUtils.isBlank(id) && NumberUtils.isCreatable(id)) {
            return osRomInfoService.get(id);
        } else {
            return new OsRomInfo();
        }
    }

    @RequiresPermissions("osrom:view")
    @RequestMapping(value = { "list", "" })
    @ResponseBody
    public Map<String, Object> list(String reqObj) {
        OsRomInfo osRomInfo = new ParamResult<OsRomInfo>(reqObj).getEntity(OsRomInfo.class);
        PageInfo<OsRomInfo> pageInfo = osRomInfoService.findPage(osRomInfo);
        return resultMap(osRomInfo, pageInfo);
    }

    @RequestMapping(value = { "getOsRomByDeviceId", "" })
    @ResponseBody
    public Map<String, Object> getOsRomByDeviceId(String reqObj, String id) {
        OsRomInfo osRomInfo = new ParamResult<OsRomInfo>(reqObj).getEntity(OsRomInfo.class);
        osRomInfo.setId(id);
        PageInfo<OsRomInfo> pageInfo = osRomInfoService.getOsRomByDeviceId(osRomInfo);
        return resultMap(osRomInfo, pageInfo);
    }

    @RequiresPermissions("osrom:edit")
    @RequestMapping(value = "delete")
    public @ResponseBody Result delete(OsRomInfo osRomInfo) {
        String deleteSuccess = messageSourceUtil.getMessage("common.deleteSuccess");
        String deleteFail = messageSourceUtil.getMessage("common.deleteFail");

        try {
            osRomInfoService.deleteById(osRomInfo);
        } catch (Exception e) {
            logger.info(e.getMessage(), e);
            return ResultGenerator.genFailResult(deleteFail);
        }
        return ResultGenerator.genSuccessResult(deleteSuccess);
    }

    @RequiresPermissions("osrom:edit")
    @RequestMapping(value = "form/{option}")
    public String form(@PathVariable String option, OsRomInfo osRomInfo, Model model) {

        model.addAttribute(DEVICE_TYPE_LIST, getDeviceTypeList());
        model.addAttribute(MANU_FACT_LIST, getManufacturerList());
        List<Dict> clientIdentifyList = DictUtils.getDictList("client_identify");
        model.addAttribute(CLIENT_ID_LIST, clientIdentifyList);

        if (StringUtils.isEmpty(osRomInfo.getId())) {
            model.addAttribute("osRomInfo", osRomInfo);
        } else {
            OsRomInfo romInfo = osRomInfoService.get(osRomInfo.getId());
            model.addAttribute("romInfo", romInfo);

            String manufacturerName = manuFacturerService
                    .findManuFacturerByNo(osRomInfo.getManufacturerNo()).getManufacturerName();
            model.addAttribute("manufacturerName", manufacturerName);
            return "modules/osRom/osRomInfoForm";
        }
        return "modules/osRom/osRomForm";
    }

    /**
     * 去发布系统版本页面
     * 
     * @param id
     * @param osDeviceType
     * @param model
     * @return
     */
    @RequestMapping("releaseNoEdition")
    public String releaseNoEdition(OsRomInfo osRomInfo, Model model, String releaseType) {
        model.addAttribute("osRomId", osRomInfo.getId());
        model.addAttribute("osVersion", osRomInfo.getOsVersion());
        model.addAttribute("clinetId", osRomInfo.getClientIdentification());
        model.addAttribute(DEVICE_TYPE_LIST, getDeviceTypeList());
        model.addAttribute(MANU_FACT_LIST, getManufacturerList());
        model.addAttribute("strategyList", getStrategyList());
        List<Dict> industryList = DictUtils.getDictList("40010");
        model.addAttribute(INDUSTRY_LIST, industryList);
        List<Dict> clientIdentifyList = DictUtils.getDictList("client_identify");
        model.addAttribute(CLIENT_ID_LIST, clientIdentifyList);
        model.addAttribute(PUBLISH_TYPE, releaseType);
        return "modules/romRelease/releaseDeviceList";
    }

    /**
     * 上传设备SN信息
     * 
     * @param file
     * @return
     * @throws Exception
     */
    @RequestMapping("uploadDeviceSn")
    public @ResponseBody Result uploadDeviceSn(@PathVariable("file") MultipartFile file,
            String romOrApp, Model model) {
        long deviceSnCount = 0;
        try {
            deviceSnCount = osRomInfoService.uploadDeviceSn(file, romOrApp);
        } catch (Exception e) {
            return ResultGenerator.genFailResult(e.getMessage());
        }
        return ResultGenerator.genSuccessResult(deviceSnCount);
    }

    /**
     * 清除设备SN缓存
     * 
     * @param file
     * @return
     * @throws Exception
     */
    @RequestMapping("clearDeviceSnCache")
    public @ResponseBody Result clearDeviceSnCache(String romOrApp) {
        String cacheKey = "";
        String userId = UserUtils.getUser().getId();
        if (Constant.DEVICE_SN_ROM.equals(romOrApp)) {
            cacheKey = Constant.DEVICE_SN_ROM + userId;
        } else {
            cacheKey = Constant.DEVICE_SN_APP + userId;
        }
        CacheUtils.remove(cacheKey);
        return ResultGenerator.genSuccessResult();
    }

    /**
     * 去上传设备SN信息 页面
     * 
     * @param file
     * @return
     * @throws Exception
     */
    @RequestMapping("uploadDeviceSnPage")
    public String uploadDeviceSnPage() {
        return "modules/romRelease/devSnFile";
    }

    /**
     * 去已发布系统版本页面
     * 
     * @param id
     * @param osDeviceType
     * @param model
     * @return
     */
    @RequestMapping("releaseAlreadyEdition")
    public String releaseAlreadyEdition(Integer id, String osDeviceType, Model model) {
        model.addAttribute("osRomId", id);
        model.addAttribute(DEVICE_TYPE_LIST, getDeviceTypeList());
        model.addAttribute(MANU_FACT_LIST, getManufacturerList());
        List<Dict> industryList = DictUtils.getDictList("40010");
        model.addAttribute(INDUSTRY_LIST, industryList);
        return "modules/romRelease/alreadyDeviceList";
    }

    /**
     * 保存文件
     * 
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("saveFile")
    public @ResponseBody Result saveFile(@RequestParam("file") MultipartFile file,
            HttpServletRequest request, HttpServletResponse response) {
        String uploadFail = messageSourceUtil.getMessage("common.upload.fail");

        OsRomInfo osRomInfo = new OsRomInfo();
        try {
            UploadUtil.uploadSaveFile(file, request);
        } catch (Exception e) {
            return ResultGenerator.genFailResult(uploadFail);
        }
        return ResultGenerator.genSuccessResult(osRomInfo);
    }

    @ResponseBody
    @RequestMapping("/selectProgress/{fileMd5}")
    public Result selectProgressByMd5(@PathVariable String fileMd5) throws ServerException {
        String handlerError = messageSourceUtil.getMessage("modules.rom.server.handler.error");

        SysFile sysFile = new SysFile();
        try {
            sysFile = osRomInfoService.selectProgressByFileMd5(fileMd5);
            return ResultGenerator.genSuccessResult(sysFile);
        } catch (Exception e) {
            logger.error(e.getMessage());
            throw new ServerException(handlerError);
        }
    }

    @RequestMapping(value = "/mergeOrCheckChunks/{param}", method = RequestMethod.POST)
    @ResponseBody
    public Result mergeOrCheckChunks(@PathVariable String param, HttpServletRequest request) {
        OsRomInfo osRomInfo = new OsRomInfo();
        String fileName = request.getParameter("fileName");
        String fileMd5 = request.getParameter("fileMd5");
        String manuNo = request.getParameter("manuNo");
        int lastIndexOf = fileName.lastIndexOf('.');
        String fileNameStr = fileName.substring(0, lastIndexOf);
        String[] split = fileNameStr.split("_");

        try {
            if (param.equals("mergeChunks")) {
                Map<String, Object> result = UploadUtil.uploadMergeChunk(request);
                String filePath = manuNo + File.separator + split[0] + File.separator
                        + result.get("fileName");
                osRomInfo.setManufacturerNo(manuNo);
                osRomInfo.setOsStart(split[3].trim());
                osRomInfo.setOsEnd(split[4].trim());
                osRomInfo.setOsDeviceType(split[0].trim());
                osRomInfo.setRomFileSize(Long.valueOf(result.get("fileSize").toString()));
                osRomInfo
                        .setMd5FileValue(FileUtils.md5Sum(UPLOAERPATH + File.separator + filePath));
                osRomInfo.setRomPath(filePath);
                osRomInfo.setClientIdentification(split[1]);
                osRomInfoService.deleteFile(fileMd5);
                return ResultGenerator.genSuccessResult(osRomInfo);
            } else if (param.equals("checkChunk")) {
                boolean reslut = osRomInfoService.uploadCheckChunk(request);
                return ResultGenerator.genSuccessResult(reslut);
            }
        } catch (ServiceException e) {
            return ResultGenerator.genFailResult(e.getMessage());
        }
        return null;
    }

    @RequiresPermissions("osrom:edit")
    @RequestMapping(value = "save")
    public @ResponseBody Result save(OsRomInfo osRomInfo) throws ServerException {
        String uploadSuccess = messageSourceUtil
                .getMessage("modules.rom.system.version.upload.success");

        try {
            osRomInfoService.saveOsRomInfo(osRomInfo);
        } catch (ServiceException e) {
            return ResultGenerator.genFailResult(e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            throw new ServerException(e.getMessage());
        }

        return ResultGenerator.genSuccessResult(uploadSuccess);
    }

    /**
     * 获取app版本数量
     * 
     * @return
     */
    @RequestMapping(value = "getOsRomInfoCount")
    public @ResponseBody Result getDeviceCount() {
        return ResultGenerator.genSuccessResult(osRomInfoService.getDeviceCount());
    }

}
