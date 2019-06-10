package com.jiewen.modules.workflow.web;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.activiti.engine.FormService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.form.FormProperty;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.druid.util.StringUtils;
import com.alibaba.fastjson.JSON;
import com.github.pagehelper.PageInfo;
import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.base.web.ParamResult;
import com.jiewen.jwp.base.web.Result;
import com.jiewen.jwp.base.web.ResultCode;
import com.jiewen.jwp.base.web.ResultGenerator;
import com.jiewen.modules.workflow.constants.Constants;
import com.jiewen.modules.workflow.entity.TaskDoneVo;
import com.jiewen.modules.workflow.entity.TaskEntity;
import com.jiewen.modules.workflow.entity.TaskVo;
import com.jiewen.modules.workflow.service.IdentityPageService;
import com.jiewen.modules.workflow.service.RuntimePageService;
import com.jiewen.modules.workflow.service.TaskPageService;
import com.jiewen.modules.workflow.service.TblActModuleService;

/**
 * 
 * 用户待办已办控制器
 * 
 */
@Controller
@RequestMapping(value = "/activiti")
public class UserTaskController extends BaseController {

    @Autowired
    private TaskService taskService;

    @Resource
    private TaskPageService taskPageService;

    @Autowired
    private RuntimeService runtimeService;

    @Autowired
    private FormService formService;

    @Resource
    private IdentityPageService identityPageService;

    @Resource
    private RuntimePageService runtimePageService;

    @Autowired
    private TblActModuleService moduleService;

    // 我的待办
    @RequestMapping(value = "/task/todo/list", method = RequestMethod.GET)
    public String list_todo(ModelMap map) {
        List<String> moduleList = moduleService.findModuleList();
        map.put("moduleList", JSON.toJSON(moduleList));
        return "modules/workflow/task_list_todo";
    }

    @RequestMapping(value = "/task/todo/getTaskToDoList/{userId}")
    public @ResponseBody Map<String, Object> getTaskToDoList(String reqObj,
            @PathVariable("userId") String userId) {
        TaskEntity taskEntity = new ParamResult<TaskEntity>(reqObj).getEntity(TaskEntity.class);
        taskEntity.setUserId(userId);
       // PageInfo<TaskVo> pageInfo = taskPageService.getTaskToDoList(taskEntity);
        PageInfo<TaskVo> pageInfo = new PageInfo<TaskVo>();
        return resultMap(taskEntity, pageInfo);
    }

    // 我的已办
    @RequestMapping(value = "/task/done/list", method = RequestMethod.GET)
    public String list_done(ModelMap map) {
        List<String> moduleList = moduleService.findModuleList();
        map.put("moduleList", JSON.toJSON(moduleList));
        return "modules/workflow/task_list_done";
    }

    @RequestMapping(value = "/task/todo/getTaskDoneList")
    public @ResponseBody Map<String, Object> getTaskDoneList(String reqObj) {
        TaskEntity taskEntity = new ParamResult<TaskEntity>(reqObj).getEntity(TaskEntity.class);
        PageInfo<TaskDoneVo> pageInfo = taskPageService.getTaskDoneList(taskEntity);
        return resultMap(taskEntity, pageInfo);
    }

    @RequestMapping(value = "/task/claim/{taskId}/{userId}", method = RequestMethod.POST)
    @ResponseBody
    public Result claimTask(@PathVariable("taskId") String taskId,
            @PathVariable("userId") String userId) {
        Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
        if (!StringUtils.isEmpty(task.getAssignee())) {
            String userName = "";
            if (!task.getAssignee().equals(userId)) {
                userName = "【" + identityPageService.getUserNamesByUserIds(task.getAssignee())
                        + "】";
            }
            String taskSign = messageSourceUtil.getMessage("workflow.usertask.task.sign.already");
            String sign = messageSourceUtil.getMessage("workflow.usertask.sign");
            return ResultGenerator.genFailResult(taskSign + userName + sign);
        }
        return taskPageService.claimTask(taskId, userId);
    }

    /**
     * 取消签收
     */
    @RequestMapping(value = "/task/unclaim/{taskId}/{userId}", method = RequestMethod.POST)
    @ResponseBody
    public Result unclaimTask(@PathVariable("taskId") String taskId,
            @PathVariable("userId") String userId) {
        return taskPageService.unclaimTask(taskId, userId);
    }

    /**
     * 用户办理之前确认是否被该用户签收
     */
    @RequestMapping(value = "/task/checkClaim/{taskId}/{userId}", method = RequestMethod.POST)
    @ResponseBody
    public Result checkClaim(@PathVariable("taskId") String taskId,
            @PathVariable("userId") String userId) {
        Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
        if (StringUtils.isEmpty(task.getAssignee())) {
            return ResultGenerator.genFailResult(ResultCode.NOT_FOUND,
                    messageSourceUtil.getMessage("workflow.usertask.not.sign.msg"));
        } else if (!task.getAssignee().equals(userId)) {
            String userName = identityPageService.getUserNamesByUserIds(task.getAssignee());
            String taskAlready = messageSourceUtil.getMessage("workflow.usertask.task.already");
            String unableHandle = messageSourceUtil.getMessage("workflow.usertask.unable.handle");
            return ResultGenerator.genFailResult(taskAlready + userName + unableHandle);
        } else {
            return ResultGenerator.genSuccessResult(true);
        }
    }

    /**
     * 办理任务
     */
    @RequestMapping(value = "/task/deal/{taskId}", method = RequestMethod.GET)
    public String dealTask(@PathVariable("taskId") String taskId, HttpServletRequest request) {
        Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
        // 流程实例ID
        request.setAttribute("processInstanceId", task.getProcessInstanceId());

        // 流程内置表单变量,因为这种方式，在页面展示困难，所以这里只存储相关变量
        // 页面展示的内容从formKey中.form获取，以减少流程模型的配置工作量
        List<FormProperty> formProperties = formService.getTaskFormData(task.getId())
                .getFormProperties();
        request.setAttribute("formProperties", formProperties);

        ProcessInstance processInstance = runtimeService.createProcessInstanceQuery()
                .processInstanceId(task.getProcessInstanceId()).singleResult();
        String businessKey = processInstance.getBusinessKey();

        String formUrl = null;

        // 获取业务url，外嵌表单展示,注入业务url 可通过local_form_url 设置，也可设置在formKey中
        for (FormProperty formProperty : formProperties) {
            if (formProperty.getId().equals(Constants.VAR_FORM_URL)) {
                formUrl = formProperty.getValue();
                if (!StringUtils.isEmpty(formUrl)) {
                    if (!formUrl.endsWith(businessKey)) {
                        formUrl = formUrl + businessKey;
                    }
                }
            }
        }
        String formKey = formService.getTaskFormKey(task.getProcessDefinitionId(),
                task.getTaskDefinitionKey());
        if (StringUtils.isEmpty(formUrl) && !StringUtils.isEmpty(formKey)
                && !formKey.endsWith(".form")) {
            formUrl = formKey;
            if (!formUrl.endsWith(businessKey)) {
                formUrl = formUrl + businessKey;
            }
        }

        if (!StringUtils.isEmpty(formUrl)) {
            request.setAttribute("formUrl", formUrl);
        }
        request.setAttribute("formName", processInstance.getName());

        // 通过formKey获取通用审批字段（审批结果、审批意见） 适用于通用审批表单
        if (!StringUtils.isEmpty(formKey) && formKey.endsWith(".form")) {
            Object formData = formService.getRenderedTaskForm(task.getId());
            if (formData != null) {
                request.setAttribute("formData", formData);
            }
        }
        request.setAttribute("taskId", taskId);
        return "modules/workflow/task_todo";
    }

    /**
     * 撤回任务
     *
     * @param instanceId
     *            历史流程节点中的ID
     * @return
     */
    @RequestMapping(value = "/task/withdraw/{instanceId}/{userId}", method = RequestMethod.POST)
    @ResponseBody
    public Result withdrawTask(@PathVariable("instanceId") String instanceId,
            @PathVariable("userId") String userId) {
        return taskPageService.withdrawTask(instanceId, userId);
    }
}
