
package com.jiewen.modules.workflow.web;

import java.io.File;
import java.io.InputStream;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.activiti.engine.RepositoryService;
import org.activiti.engine.repository.ProcessDefinition;
import org.apache.commons.io.IOUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageInfo;
import com.jiewen.commons.util.FileUtil;
import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.base.web.ParamResult;
import com.jiewen.jwp.base.web.Result;
import com.jiewen.jwp.base.web.ResultGenerator;
import com.jiewen.jwp.common.FileUtils;
import com.jiewen.modules.workflow.entity.ProcDefVo;
import com.jiewen.modules.workflow.service.RepositoryPageService;

/**
 * 工作流定义
 *
 * @author Pang.M 2018年1月19日
 *
 */
@Controller
@RequestMapping(value = "/workflow/processdef")
public class ProcessDefController extends BaseController {

    @Autowired
    private RepositoryService repositoryService;

    @Autowired
    private RepositoryPageService repositoryPageService;

    @Value("${http.uploader.path}")
    private String dirPath;

    @RequestMapping(value = "/list")
    public String list() {
        return "modules/workflow/processdef_list";
    }

    @RequiresPermissions("workflow:processdef:view")
    @RequestMapping(value = "findList")
    public @ResponseBody Map<String, Object> findList(String reqObj) {
        ProcDefVo procDef = new ParamResult<ProcDefVo>(reqObj).getEntity(ProcDefVo.class);
        PageInfo<ProcDefVo> pageInfo = repositoryPageService.getProcessDefList(procDef);
        return resultMap(procDef, pageInfo);
    }

    // 删除定义，如果流程定义已被使用，则不删除 type=0 软删除 type=1 强制删除
    @RequestMapping(value = "/delete/{delType}/{pdId}", method = RequestMethod.POST)
    @ResponseBody
    public Result deleteDeployment(@PathVariable("delType") String delType,
                                   @PathVariable("pdId") String pdId) {
        ProcessDefinition pd = repositoryService.getProcessDefinition(pdId);
        try {
            if ("0".equals(delType)) {
                repositoryService.deleteDeployment(pd.getDeploymentId());
            } else {
                repositoryService.deleteDeployment(pd.getDeploymentId(), true);
            }
            return ResultGenerator.genSuccessResult(
                    messageSourceUtil.getMessage("common.deleteSuccess"));
        } catch (Exception e) {
            return ResultGenerator.genFailResult(messageSourceUtil
                    .getMessage("workflow.procdef.delete.fail.executive"));
        }
    }

    // 导出流程定义资源文件
    @RequestMapping(value = "/export/{type}/{id}", method = RequestMethod.GET)
    public void downloadFlow(@PathVariable("type") String type,
                             @PathVariable("id") String id,
                             HttpServletResponse response) {
        try {
            ProcessDefinition processDefinition = repositoryService
                    .getProcessDefinition(id);
            String resourceName = "";
            if (type.equals("image")) {
                resourceName = processDefinition.getDiagramResourceName();
            } else if (type.equals("xml")) {
                resourceName = processDefinition.getResourceName();
            }
            InputStream resourceAsStream = repositoryService.getResourceAsStream(
                    processDefinition.getDeploymentId(), resourceName);
            IOUtils.copy(resourceAsStream, response.getOutputStream());
            response.setHeader("Content-Disposition",
                    "attachment; filename=" + resourceName);
            response.flushBuffer();
        } catch (Exception e) {
            String procinst = messageSourceUtil
                    .getMessage("workflow.procdef.export.procinst");
            String msg = messageSourceUtil.getMessage("workflow.procdef.fail.file");
            logger.error(procinst + type + msg, id, e);
        }
    }

    // 显示流程资源文件
    @RequestMapping(value = "/show/{pdId}", method = RequestMethod.GET)
    public String showResoure(@PathVariable("pdId") String pdId,
                              HttpServletRequest request) {
        Result xml = generateResource("xml", pdId, request);
        Result image = generateResource("image", pdId, request);
        request.setAttribute("xml", xml.getData());
        request.setAttribute("image", image.getData());
        request.setAttribute("pdId", pdId);
        return "modules/workflow/processdef_show";
    }

    /**
     * 生成资源文件，并返回文件路径 给开发者看的
     */
    @RequestMapping(value = "/generate/{type}/{pdId}", method = RequestMethod.POST)
    @ResponseBody
    public Result generateResource(@PathVariable("type") String type,
                                   @PathVariable("pdId") String pdId,
                                   HttpServletRequest request) {
        try {
            String resPath = request.getServletContext().getRealPath("/");
            ProcessDefinition processDefinition = repositoryService
                    .getProcessDefinition(pdId);
            String resourceName = "";
            if (type.equals("image")) {
                resourceName = processDefinition.getDiagramResourceName();
            } else if (type.equals("xml")) {
                resourceName = processDefinition.getResourceName();
            }
            InputStream resourceAsStream = repositoryService.getResourceAsStream(
                    processDefinition.getDeploymentId(), resourceName);
            String realPath = resPath + File.separator + dirPath + File.separator
                    + resourceName;
            realPath = realPath.replaceAll("\\\\", "/");
            File file = new File(realPath);
            if (file.exists()) {
                FileUtils.delFile(file.getAbsolutePath());
            }
            FileUtil.copyToFile(resourceAsStream, file);
            String realName = (dirPath + File.separator + resourceName).replaceAll("\\\\",
                    "/");
            return ResultGenerator
                    .genFailResult(messageSourceUtil
                            .getMessage("workflow.model.build.png.success"))
                    .setData(realName);
        } catch (Exception e) {
            String buildFileError = messageSourceUtil
                    .getMessage("workflow.procdef.build.conf.file.error");
            String pid = messageSourceUtil.getMessage("workflow.procdef.pid.msg");
            logger.error(buildFileError + pid, pdId, e);
            return ResultGenerator.genFailResult("生成资源文件异常");
        }
    }
}
