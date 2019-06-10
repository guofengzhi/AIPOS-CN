
package com.jiewen.modules.workflow.web;

import java.io.File;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.activiti.bpmn.model.BpmnModel;
import org.activiti.engine.HistoryService;
import org.activiti.engine.ProcessEngine;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.history.HistoricActivityInstance;
import org.activiti.engine.history.HistoricProcessInstance;
import org.activiti.engine.impl.persistence.entity.ProcessDefinitionEntity;
import org.activiti.engine.impl.pvm.PvmTransition;
import org.activiti.engine.impl.pvm.process.ActivityImpl;
import org.activiti.engine.repository.ProcessDefinition;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.image.ProcessDiagramGenerator;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.github.pagehelper.PageInfo;
import com.jiewen.commons.util.DateTimeUtil;
import com.jiewen.commons.util.FileUtil;
import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.base.web.ParamResult;
import com.jiewen.jwp.base.web.Result;
import com.jiewen.jwp.base.web.ResultGenerator;
import com.jiewen.jwp.common.FileUtils;
import com.jiewen.modules.workflow.entity.ActivityVo;
import com.jiewen.modules.workflow.entity.ProcessInstanceVo;
import com.jiewen.modules.workflow.service.RepositoryPageService;
import com.jiewen.modules.workflow.service.RuntimePageService;
import com.jiewen.modules.workflow.service.TblActModuleService;

/**
 * 工作流实例
 *
 * @author Pang.M 2018年1月19日
 *
 */
@Controller
@RequestMapping(value = "/workflow")
public class ProcessInstanceController extends BaseController {

    @Autowired
    private RuntimeService runtimeService;

    @Autowired
    private RuntimePageService runtimePageService;

    @Autowired
    private HistoryService historyService;

    @Autowired
    private RepositoryService repositoryService;

    @Autowired
    private TblActModuleService moduleService;

    @Autowired
    private RepositoryPageService repositoryPageService;

    // 流程处理引擎
    @Autowired
    private ProcessEngine processEngine;

    @Value("${http.uploader.path}")
    private String uploaderPath;

    @RequestMapping(value = "/processinstance/list")
    public String list(ModelMap map) {
        List<String> moduleList = moduleService.findModuleList();
        map.put("moduleList", JSON.toJSON(moduleList));
        return "modules/workflow/processinstance_list";
    }

    @RequiresPermissions("workflow:processinstance:view")
    @RequestMapping(value = "/processinstance/findList")
    public @ResponseBody Map<String, Object> findList(String reqObj) {
        ProcessInstanceVo procInst = new ParamResult<ProcessInstanceVo>(reqObj)
                .getEntity(ProcessInstanceVo.class);
        PageInfo<ProcessInstanceVo> pageInfo = repositoryPageService
                .getProcessInstanceList(procInst);
        return resultMap(procInst, pageInfo);
    }

    @RequiresPermissions("workflow:processinstance:view")
    @RequestMapping(value = "/activity/getActivityList/{instanceId}")
    public @ResponseBody Map<String, Object> getActivityList(
            @PathVariable("instanceId") String instanceId, String reqObj) {
        ProcessInstanceVo procInst = new ParamResult<ProcessInstanceVo>(reqObj)
                .getEntity(ProcessInstanceVo.class);
        procInst.setInstanceId(instanceId);
        PageInfo<ActivityVo> pageInfo = runtimePageService.getActivityList(procInst);
        return resultMap(procInst, pageInfo);
    }

    @RequiresPermissions("workflow:processinstance:edit")
    @RequestMapping(value = "/processinstance/delete/{instanceId}", method = RequestMethod.POST)
    @ResponseBody
    public Result deleteInstance(@PathVariable("instanceId") String id) {
        try {
            runtimeService.deleteProcessInstance(id,
                    messageSourceUtil.getMessage("workflow.proinst.flow.delete"));
            historyService.deleteHistoricProcessInstance(id);
            return ResultGenerator.genSuccessResult(
                    messageSourceUtil.getMessage("workflow.proinst.delete.success"));
        } catch (Exception ex) {
            String deleteFail = messageSourceUtil.getMessage("workflow.proinst.delete.fail");
            String msg = messageSourceUtil.getMessage("workflow.proinst.delete.fail.msg");
            return ResultGenerator.genFailResult(deleteFail + msg + ex.getMessage());
        }
    }

    @RequestMapping(value = "/monitor/{instanceId}", method = RequestMethod.GET)
    public String monitor(@PathVariable("instanceId") String instanceId,
            HttpServletRequest request) {
        Result image = generateImage(instanceId, request);
        request.setAttribute("image", image.getData());
        request.setAttribute("instanceId", instanceId);
        return "modules/workflow/monitor_show";
    }

    @RequestMapping(value = "/monitor/list/{instanceId}", method = RequestMethod.GET)
    public String monitorList(@PathVariable("instanceId") String instanceId,
            HttpServletRequest request) {
        request.setAttribute("instanceId", instanceId);
        return "modules/workflow/monitor_show_list";
    }

    @RequestMapping(value = "/monitor/image/{instanceId}", method = RequestMethod.GET)
    public String monitorImage(@PathVariable("instanceId") String instanceId,
            HttpServletRequest request) {
        Result image = generateImage(instanceId, request);
        request.setAttribute("image", image.getData());
        request.setAttribute("instanceId", instanceId);
        return "modules/workflow/monitor_show_image";
    }

    /**
     * 生成流程实例的流程图片，并重点高亮当前节点，高亮已经执行的链路
     *
     * @param instanceId
     *            流程实例
     * @param request
     * @return 第二个参数为生成的图片路径
     */
    @RequestMapping(value = "/processinstance/generate/{instanceId}", method = RequestMethod.POST)
    @ResponseBody
    public Result generateImage(@PathVariable("instanceId") String instanceId,
            HttpServletRequest request) {
        try {
            String resPath = request.getServletContext().getRealPath("/");
            ProcessInstance processInstance = runtimeService.createProcessInstanceQuery()
                    .processInstanceId(instanceId).singleResult();
            BpmnModel bpmnModel;
            List<String> activeActivityIds = new ArrayList<>();
            String processDefinitionId;
            // 存在活动节点，流程正在进行中
            if (processInstance != null) {
                processDefinitionId = processInstance.getProcessDefinitionId();
                // 正在活动的节点
                activeActivityIds = runtimeService.getActiveActivityIds(instanceId);
            } else {
                // 流程已经结束
                HistoricProcessInstance instance = historyService
                        .createHistoricProcessInstanceQuery().processInstanceId(instanceId)
                        .singleResult();
                processDefinitionId = instance.getProcessDefinitionId();
            }

            bpmnModel = repositoryService.getBpmnModel(processDefinitionId);

            ProcessDiagramGenerator pdg = processEngine.getProcessEngineConfiguration()
                    .getProcessDiagramGenerator();

            // -------------------------------executedActivityIdList已经执行的节点------------------------------------
            List<HistoricActivityInstance> historicActivityInstanceList = historyService
                    .createHistoricActivityInstanceQuery().processInstanceId(instanceId)
                    .orderByHistoricActivityInstanceStartTime().asc().list();

            // 已执行的节点ID集合
            List<String> executedActivityIdList = new ArrayList<>();
            for (HistoricActivityInstance activityInstance : historicActivityInstanceList) {
                executedActivityIdList.add(activityInstance.getActivityId());
            }

            ProcessDefinition processDefinition = repositoryService
                    .getProcessDefinition(processDefinitionId);
            String resourceName = instanceId + "_" + processDefinition.getDiagramResourceName();

            List<String> highLightedFlows = getHighLightedFlows(
                    (ProcessDefinitionEntity) processDefinition, historicActivityInstanceList);

            // 生成流图片 所有走过的节点高亮 第三个参数
            // activeActivityIds=当前活动节点点高亮;executedActivityIdList=已经执行过的节点高亮
            InputStream inputStream = pdg.generateDiagram(bpmnModel, "PNG", activeActivityIds,
                    highLightedFlows,
                    processEngine.getProcessEngineConfiguration().getActivityFontName(),
                    processEngine.getProcessEngineConfiguration().getLabelFontName(),
                    processEngine.getProcessEngineConfiguration().getActivityFontName(),
                    processEngine.getProcessEngineConfiguration().getProcessEngineConfiguration()
                            .getClassLoader(),
                    1);

            resourceName = DateTimeUtil.format(new Date(), "yyyyMMddHHmmss") + "_" + resourceName;
            // 生成本地图片
            String realPath = resPath + File.separator + uploaderPath + File.separator
                    + resourceName;
            realPath = realPath.replaceAll("\\\\", "/");
            File file = new File(realPath);
            if (file.exists()) {
                FileUtils.deleteFile(file.getAbsolutePath());
            }
            FileUtil.copyToFile(inputStream, file);
            String realName = (uploaderPath + File.separator + resourceName).replaceAll("\\\\",
                    "/");
            inputStream.close();
            return ResultGenerator
                    .genSuccessResult(
                            messageSourceUtil.getMessage("workflow.model.build.png.success"))
                    .setData(realName);
        } catch (Exception e) {
            String error = messageSourceUtil.getMessage("workflow.proinst.create.image.error");
            String msg = messageSourceUtil.getMessage("workflow.proinst.instance.id");
            logger.error(error + msg, instanceId, e);
            return ResultGenerator.genFailResult(error);
        }
    }

    /**
     * 获取需要高亮的线,如果其他方法需要调用 重构到RuntimePageService
     *
     * @param processDefinitionEntity
     * @param historicActivityInstances
     * @return
     */
    private List<String> getHighLightedFlows(ProcessDefinitionEntity processDefinitionEntity,
            List<HistoricActivityInstance> historicActivityInstances) {
        List<String> highFlows = new ArrayList<>(); // 用以保存高亮的线flowId
        for (int i = 0; i < historicActivityInstances.size() - 1; i++) { // 对历史流程节点进行遍历
            ActivityImpl activityImpl = processDefinitionEntity
                    .findActivity(historicActivityInstances.get(i).getActivityId()); // 得到节点定义的详细信息
            List<ActivityImpl> sameStartTimeNodes = new ArrayList<>(); // 用以保存后需开始时间相同的节点
            ActivityImpl sameActivityImpl1 = processDefinitionEntity
                    .findActivity(historicActivityInstances.get(i + 1).getActivityId());
            // 将后面第一个节点放在时间相同节点的集合里
            sameStartTimeNodes.add(sameActivityImpl1);
            for (int j = i + 1; j < historicActivityInstances.size() - 1; j++) {
                HistoricActivityInstance activityImpl2 = historicActivityInstances.get(j + 1); // 后续第二个节点
                // 如果第一个节点和第二个节点开始时间相同保存
                ActivityImpl sameActivityImpl2 = processDefinitionEntity
                        .findActivity(activityImpl2.getActivityId());
                sameStartTimeNodes.add(sameActivityImpl2);
            }
            List<PvmTransition> pvmTransitions = activityImpl.getOutgoingTransitions(); // 取出节点的所有出去的线
            for (PvmTransition pvmTransition : pvmTransitions) {
                // 对所有的线进行遍历
                ActivityImpl pvmActivityImpl = (ActivityImpl) pvmTransition.getDestination();
                // 如果取出的线的目标节点存在时间相同的节点里，保存该线的id，进行高亮显示
                if (sameStartTimeNodes.contains(pvmActivityImpl)) {
                    highFlows.add(pvmTransition.getId());
                }
            }
        }
        return highFlows;
    }

    /**
     * 改变流程实例状态 挂起/激活
     *
     * @param instanceId
     * @return
     */
    @RequestMapping(value = "/processinstance/toggleSuspensionState/{instanceId}", method = RequestMethod.POST)
    @ResponseBody
    public Result toggleSuspensionState(@PathVariable("instanceId") String instanceId) {
        org.activiti.engine.runtime.ProcessInstance processInstance = runtimeService
                .createProcessInstanceQuery().processInstanceId(instanceId).singleResult();
        if (processInstance.isSuspended()) {
            runtimeService.activateProcessInstanceById(instanceId);
            String activationSucess = messageSourceUtil
                    .getMessage("workflow.proinst.activation.success");
            return ResultGenerator.genSuccessResult(activationSucess);
        } else {
            runtimeService.suspendProcessInstanceById(instanceId);
            return ResultGenerator.genSuccessResult(
                    messageSourceUtil.getMessage("workflow.proinst.pending.success"));
        }
    }
}
