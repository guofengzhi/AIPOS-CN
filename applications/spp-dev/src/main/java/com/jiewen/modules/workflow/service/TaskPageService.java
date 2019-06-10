
package com.jiewen.modules.workflow.service;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import org.activiti.engine.HistoryService;
import org.activiti.engine.IdentityService;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.history.HistoricProcessInstance;
import org.activiti.engine.history.HistoricProcessInstanceQuery;
import org.activiti.engine.history.HistoricTaskInstance;
import org.activiti.engine.identity.User;
import org.activiti.engine.impl.RuntimeServiceImpl;
import org.activiti.engine.impl.interceptor.Command;
import org.activiti.engine.impl.interceptor.CommandContext;
import org.activiti.engine.impl.persistence.entity.ExecutionEntity;
import org.activiti.engine.impl.persistence.entity.ProcessDefinitionEntity;
import org.activiti.engine.impl.pvm.process.ActivityImpl;
import org.activiti.engine.repository.ProcessDefinition;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.IdentityLink;
import org.activiti.engine.task.IdentityLinkType;
import org.activiti.engine.task.Task;
import org.activiti.engine.task.TaskQuery;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageInfo;
import com.jiewen.jwp.base.utils.LocaleMessageSourceUtil;
import com.jiewen.jwp.base.web.Result;
import com.jiewen.jwp.base.web.ResultGenerator;
import com.jiewen.jwp.common.DateUtils;
import com.jiewen.jwp.common.StringUtils;
import com.jiewen.modules.workflow.constants.Constants;
import com.jiewen.modules.workflow.dao.ExecuteSqlDao;
import com.jiewen.modules.workflow.entity.ExecuteSqlVo;
import com.jiewen.modules.workflow.entity.TaskDoneVo;
import com.jiewen.modules.workflow.entity.TaskEntity;
import com.jiewen.modules.workflow.entity.TaskVo;

/**
 *
 * 用户待办/已办
 */
@Service
public class TaskPageService {

    private static final Logger logger = LoggerFactory.getLogger(TaskPageService.class);

    @Resource
    protected LocaleMessageSourceUtil messageSourceUtil;

    @Autowired
    private TaskService taskService;

    @Resource
    private IdentityPageService identityPageService;

    @Resource
    private RuntimePageService runtimePageService;

    @Autowired
    private RuntimeService runtimeService;

    @Autowired
    private HistoryService historyService;

    @Autowired
    private IdentityService identityService;

    @Autowired
    private RepositoryService repositoryService;

    @Autowired
    private ExecuteSqlDao executeSqlDao;

    public Result claimTask(String taskId, String assignee) {
        Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
        if (StringUtils.isEmpty(task.getAssignee())) {
            taskService.claim(taskId, assignee);
            return ResultGenerator.genSuccessResult(true);
        } else {
            String assgineeName = identityPageService
                    .getUserNamesByUserIds(task.getAssignee());
            String signFail = messageSourceUtil
                    .getMessage("workflow.usertask.task.sign.already");
            String msg = messageSourceUtil.getMessage("workflow.usertask.sign");
            return ResultGenerator.genFailResult(signFail + assgineeName + msg);
        }
    }

    public Result unclaimTask(String taskId, String assignee) {
        String signError = messageSourceUtil.getMessage("workfolw.usertask.sign.error");
        String cancelSignerror = messageSourceUtil
                .getMessage("workflow.usertask.cancel.sign.error");
        String signMsg = messageSourceUtil.getMessage("workflow.usertask.sign");
        Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
        if (StringUtils.isEmpty(task.getAssignee())) {
            return ResultGenerator.genFailResult(signError);
        } else if (!assignee.equals(task.getAssignee())) {
            String assgineeName = identityPageService
                    .getUserNamesByUserIds(task.getAssignee());
            return ResultGenerator
                    .genFailResult(cancelSignerror + assgineeName + signMsg);
        } else {
            taskService.unclaim(taskId);
            // List<IdentityLink>
            // identityLinks=taskService.getIdentityLinksForTask(taskId);
            // taskService.deleteUserIdentityLink(taskId,assignee,
            // IdentityLinkType.PARTICIPANT);
            // runtimeService.deleteUserIdentityLink(task.getProcessInstanceId(),assignee,IdentityLinkType.PARTICIPANT);
            return ResultGenerator.genSuccessResult(true);
        }
    }

    // 待办
    public PageInfo<TaskVo> getTaskToDoList(TaskEntity taskEntity) {
        String name = null; // 流程实例名称
        String businessKey = null; // 业务key
        String category = null; // 业务类型编码
        String userId = null; // 执行人
        if (taskEntity != null) {
            if (StringUtils.isNotEmpty(taskEntity.getUserId())) {
                userId = taskEntity.getUserId();
            }
            if (StringUtils.isNotEmpty(taskEntity.getName())) {
                name = taskEntity.getName();
            }
            if (StringUtils.isNotEmpty(taskEntity.getBusinessKey())) {
                businessKey = taskEntity.getBusinessKey();
            }
            if (StringUtils.isNotEmpty(taskEntity.getCategory())) {
                category = taskEntity.getCategory();
            }
        }
        List<Task> taskList;
        // 委托的任务没有显示
        TaskQuery query = taskService.createTaskQuery().taskCandidateOrAssigned(userId);
        if (!StringUtils.isEmpty(name)) {
            query = query.taskNameLike(name);
        }
        if (!StringUtils.isEmpty(businessKey)) {
            query = query.processInstanceBusinessKey(businessKey);
        }
        if (!StringUtils.isEmpty(category)) {
            List<String> categorys = new ArrayList<>();
            categorys.add(category);
            query = query.processCategoryIn(categorys);
        }
        taskList = query.orderByTaskCreateTime().desc().listPage(
                (taskEntity.getPage() - 1) * taskEntity.getRows(), taskEntity.getRows());
        List<TaskVo> voList = new ArrayList<>();
        for (Task task : taskList) {
            TaskVo vo = new TaskVo();
            BeanUtils.copyProperties(task, vo);
            // 可在此添加额外信息
            if (!StringUtils.isEmpty(task.getAssignee())) {
                vo.setAssigneeName(
                        identityPageService.getUser(task.getAssignee()).getFirstName());
            }
            // 委托人
            if (!StringUtils.isEmpty(task.getOwner())) {
                String owner = identityPageService.getUser(task.getOwner())
                        .getFirstName();
                if (StringUtils.isEmpty(vo.getAssigneeName())) {
                    vo.setAssigneeName(owner);
                } else {
                    String princianl = messageSourceUtil
                            .getMessage("workflow.usertask.princianl");
                    vo.setAssigneeName(vo.getAssigneeName() + princianl + owner + ")");
                }
            }
            if (StringUtils.isEmpty(vo.getAssigneeName())) {
                Map<String, String> map = getTaskCandidateUser(task.getId());
                String userNames = map.get("names");
                if (!StringUtils.isEmpty(userNames)) {
                    vo.setAssigneeName(userNames);
                }
            }
            ProcessInstance processInstance = runtimeService.createProcessInstanceQuery()
                    .processInstanceId(task.getProcessInstanceId()).singleResult();
            vo.setProcessInstanceName(processInstance.getName());
            // 判断是否可以取消签收，要看是否通过候选人、候选组选择审批人的，不然指定审批人的任务取消签收后变成游离状态，不会出现在任何人的待办里
            // 所以通过initialAssignee和assignee判断是否取消签收有问题（候选人签收后initialAssignee和assignee一样）
            vo.setCanUnclaim(getTaskState(task.getId()) ? "0" : "1");
            vo.setStartUserId(runtimePageService.getStartUserId(task.getId()));
            vo.setStartUserName(
                    identityPageService.getUserNamesByUserIds(vo.getStartUserId()));
            voList.add(vo);
        }

        PageInfo<TaskVo> pageInfo = new PageInfo<>();
        pageInfo.setTotal(voList.size());
        pageInfo.setList(voList);
        return pageInfo;
    }

    /**
     * 获取候选用户
     *
     * @param taskId
     * @return Map names ids
     */
    public Map<String, String> getTaskCandidateUser(String taskId) {
        Set<User> users = getTaskCandidate(taskId);
        String[] names = new String[users.size()];
        String[] ids = new String[users.size()];
        Map<String, String> map = new HashMap<>();
        int i = 0;
        for (User user : users) {
            names[i] = user.getFirstName();
            ids[i] = user.getId();
            i++;
        }

        map.put("names", StringUtils.join(names, ','));
        map.put("ids", StringUtils.join(ids, ','));
        return map;
    }

    /**
     * 获取任务候选人
     *
     * @param taskId
     *            任务ID
     * @return
     */
    public Set<User> getTaskCandidate(String taskId) {
        Set<User> users = new HashSet<>();
        List<IdentityLink> identityLinkList = taskService.getIdentityLinksForTask(taskId);
        if (identityLinkList != null && !identityLinkList.isEmpty()) {
            for (
                    Iterator<IdentityLink> iterator = identityLinkList.iterator();
                    iterator.hasNext();) {
                IdentityLink identityLink = iterator.next();
                if (identityLink.getUserId() != null) {
                    User user = identityPageService.getUser(identityLink.getUserId());
                    if (user != null) {
                        users.add(user);
                    }
                }
                if (identityLink.getGroupId() != null) {
                    // 根据组获得对应人员
                    List<User> userList = identityService.createUserQuery()
                            .memberOfGroup(identityLink.getGroupId()).list();
                    if (userList != null && !userList.isEmpty()) {
                        users.addAll(userList);
                    }
                }
            }

        }
        return users;
    }

    // 获取流程状态，判断当前节点的办理人是指定的办理人还是签收的办理人
    // true=指定的审批人（可以撤回） false=签收后产生的审批人（不可撤回）
    public boolean getTaskState(String taskId) {
        List<IdentityLink> identiyLinks = taskService.getIdentityLinksForTask(taskId);
        for (IdentityLink identiyLink : identiyLinks) {
            if (IdentityLinkType.CANDIDATE.equals(identiyLink.getType())) {
                return false;
            }
        }
        return true;
    }

    /**
     * 获取已办的任务李彪
     *
     * @param condition
     *            查询条件
     * @param pageInfo
     *            分页信息
     * @return
     */
    public PageInfo<TaskDoneVo> getTaskDoneList(TaskEntity taskEntity) {
        String name = null; // 流程实例名称
        String businessKey = null; // 业务key
        String category = null; // 业务类型编码
        String userId = null; // 执行人
        String startTime = null; // 开始启动时间
        String endTime = null; // 结束启动时间
        PageInfo<TaskDoneVo> pageInfo = new PageInfo<>();
        if (taskEntity != null) {
            if (StringUtils.isNotEmpty(taskEntity.getUserId())) {
                userId = taskEntity.getUserId();
            }
            if (StringUtils.isNotEmpty(taskEntity.getName())) {
                name = taskEntity.getName();
            }
            if (StringUtils.isNotEmpty(taskEntity.getBusinessKey())) {
                businessKey = taskEntity.getBusinessKey();
            }
            if (StringUtils.isNotEmpty(taskEntity.getCategory())) {
                category = taskEntity.getCategory();
            }
            if (StringUtils.isNotEmpty(taskEntity.getStartTime())) {
                startTime = taskEntity.getStartTime();
            }
            if (StringUtils.isNotEmpty(taskEntity.getEndTime())) {
                endTime = taskEntity.getEndTime();
            }
        }

        List<TaskDoneVo> volist = new ArrayList<>();
        List<HistoricProcessInstance> processInstanceList;
        // 通过此种方式过滤掉签收后出现在已办的情况
        Set<String> processInstanceIdSet = new HashSet<>();
        List<HistoricTaskInstance> taskInstances = historyService
                .createHistoricTaskInstanceQuery().taskInvolvedUser(userId).finished()
                .orderByTaskCreateTime().desc().list();
        for (HistoricTaskInstance taskInstance : taskInstances) {
            processInstanceIdSet.add(taskInstance.getProcessInstanceId());
        }
        // 用户启动的流程
        List<HistoricProcessInstance> instances = historyService
                .createHistoricProcessInstanceQuery().startedBy(userId).list();
        for (HistoricProcessInstance instance : instances) {
            processInstanceIdSet.add(instance.getId());
        }

        if (processInstanceIdSet.isEmpty()) {
            pageInfo.setTotal(0);
            pageInfo.setList(volist);
            return pageInfo;
        }
        // ---------------------------------------------
        HistoricProcessInstanceQuery query = historyService
                .createHistoricProcessInstanceQuery()
                .processInstanceIds(processInstanceIdSet);
        if (!StringUtils.isEmpty(userId)) {
            query.involvedUser(userId);
        }
        if (!StringUtils.isEmpty(name)) {
            query.processInstanceNameLike(name);
        }
        if (!StringUtils.isEmpty(businessKey)) {
            query = query.processInstanceBusinessKey(businessKey);
        }
        if (!StringUtils.isEmpty(category)) {
            query = query.processDefinitionCategory(category);
        }
        if (!StringUtils.isEmpty(startTime)) {
            try {
                Date startDate = DateUtils.parseDate(startTime + " 00:00:00",
                        "yyyy-MM-dd HH:mm:ss");
                query.startedAfter(startDate);
            } catch (ParseException ex) {
                logger.error(
                        messageSourceUtil.getMessage("workflow.usertask.starttime.error"),
                        ex.getMessage());
            }
        }
        if (!StringUtils.isEmpty(endTime)) {
            try {
                Date endDate = DateUtils.parseDate(endTime + " 23:59:59",
                        "yyyy-MM-dd HH:mm:ss");
                query.startedBefore(endDate);
            } catch (ParseException ex) {
                logger.error(
                        messageSourceUtil.getMessage("workflow.usertask.endtime.error"),
                        ex.getMessage());
            }
        }
        processInstanceList = query.orderByProcessInstanceStartTime().desc().listPage(
                (pageInfo.getPageNum() - 1) * pageInfo.getPageSize(),
                pageInfo.getPageSize());

        for (HistoricProcessInstance processInstance : processInstanceList) {
            TaskDoneVo vo = new TaskDoneVo();
            BeanUtils.copyProperties(processInstance, vo);
            vo.setStartUserName(
                    identityPageService.getUserNamesByUserIds(vo.getStartUserId()));
            // 是否办结
            if (processInstance.getEndTime() != null) {
                vo.setFlowState(Constants.STATE_INSTANCE_DONE);
            } else {
                vo.setFlowState(Constants.STATE_INSTANCE_DOING);
            }
            ProcessDefinition processDefinition = repositoryService
                    .createProcessDefinitionQuery()
                    .processDefinitionId(processInstance.getProcessDefinitionId())
                    .singleResult();
            vo.setCategory(processDefinition.getCategory());
            vo.setCanWithdraw(
                    canWithdraw(processInstance, userId).getCode() == 200 ? "1" : "0");
            volist.add(vo);
        }

        pageInfo.setTotal(volist.size());
        pageInfo.setList(volist);
        return pageInfo;

    }

    /**
     * 判断流程是否可撤回 历史流程节点中最后一个审批人是userId
     */
    public Result canWithdraw(HistoricProcessInstance processInstance, String userId) {
        List<HistoricTaskInstance> taskInstances = historyService
                .createHistoricTaskInstanceQuery().processUnfinished()
                .processInstanceId(processInstance.getId()).orderByTaskCreateTime().desc()
                .orderByTaskId().desc().list();
        if (taskInstances.isEmpty() || taskInstances.size() < 2) {
            return ResultGenerator.genFailResult(
                    messageSourceUtil.getMessage("workflow.usertask.not.cancel"));
        } else {
            HistoricTaskInstance taskInstance = taskInstances.get(1);
            HistoricTaskInstance taskCurrent = taskInstances.get(0);
            // 流程审批人未未指定（未签收+未办理）
            if (StringUtils.isEmpty(taskCurrent.getAssignee())) {
                if (taskInstance.getAssignee() != null
                        && taskInstance.getAssignee().equals(userId)) {
                    return ResultGenerator.genSuccessResult(
                            messageSourceUtil.getMessage("workflow.usertask.can.cancel"));
                }
            }
            // 流程定义时指定了办理人，也可以撤回
            else if (getTaskState(taskCurrent.getId())) {
                if (taskInstance.getAssignee() != null
                        && taskInstance.getAssignee().equals(userId)) {
                    return ResultGenerator.genSuccessResult(
                            messageSourceUtil.getMessage("workflow.usertask.can.cancel"));
                }
            }

        }
        return ResultGenerator.genFailResult(
                messageSourceUtil.getMessage("workflow.usertask.not.cancel"));
    }

    /**
     * 流程撤回 TODO MESSAGE 流程撤回需要给相关人员发送消息提醒
     *
     * @param instanceId
     *            历史流程实例ID
     * @param userId
     *            用户ID
     * @return
     */
    public Result withdrawTask(String instanceId, String userId) {
        HistoricProcessInstance processInstance = historyService
                .createHistoricProcessInstanceQuery().processInstanceId(instanceId)
                .singleResult();
        Result result = this.canWithdraw(processInstance, userId);
        if (result.getCode() != 200) {
            return ResultGenerator.genFailResult(
                    messageSourceUtil.getMessage("workflow.usertask.not.cancel"));
        } else {
            HistoricTaskInstance taskInstance = (HistoricTaskInstance) result.getData();
            final org.activiti.engine.impl.persistence.entity.TaskEntity task;
            task = (org.activiti.engine.impl.persistence.entity.TaskEntity) taskService
                    .createTaskQuery().processInstanceId(instanceId).singleResult();
            try {
                this.jumpTask(task, taskInstance.getTaskDefinitionKey());
                // 删除历史记录，填充签收人
                this.deleteCurrentTaskInstance(task.getId(), taskInstance);
                return ResultGenerator.genSuccessResult(true);
            } catch (Exception ex) {
                return ResultGenerator.genFailResult(
                        messageSourceUtil.getMessage("workflow.usertask.cancel.exception")
                                + ex.getMessage());
            }

        }
    }

    /**
     * 流程跳跃到任意节点
     *
     * @param currentTaskEntity
     *            当前任务实例
     * @param targetTaskDefinitionKey
     *            任务定义节点key(目标节点)
     * @throws Exception
     */
    public void jumpTask(
                         final org.activiti.engine.impl.persistence.entity.TaskEntity currentTaskEntity,
                         String targetTaskDefinitionKey) throws Exception {
        ProcessDefinitionEntity processDefinition = (ProcessDefinitionEntity) repositoryService
                .getProcessDefinition(currentTaskEntity.getProcessDefinitionId());
        final ActivityImpl activity = processDefinition
                .findActivity(targetTaskDefinitionKey);

        final ExecutionEntity execution = (ExecutionEntity) runtimeService
                .createExecutionQuery().executionId(currentTaskEntity.getExecutionId())
                .singleResult();

        // 包装一个Command对象
        ((RuntimeServiceImpl) runtimeService).getCommandExecutor()
                .execute(new Command<Void>() {

                    @Override
                    public Void execute(CommandContext commandContext) {
                        // 创建新任务
                        // execution.setActivity(activity);
                        execution.executeActivity(activity);

                        // 删除当前的任务
                        // 不能删除当前正在执行的任务，所以要先清除掉关联
                        currentTaskEntity.setExecutionId(null);
                        taskService.saveTask(currentTaskEntity);
                        taskService.deleteTask(currentTaskEntity.getId(), true);

                        return null;
                    }
                });

    }

    // 删除历史记录，回填签收人以保证流程明细显示正确
    public Result deleteCurrentTaskInstance(String taskId,
                                            HistoricTaskInstance taskInstance) {
        // 删除正在执行的任务
        // 删除HistoricTaskInstance
        String sql_task = "delete from act_hi_taskinst where " + "ID_='" + taskId
                + "' or ID_='" + taskInstance.getId() + "'";
        this.executeSqlDao.executeSql(new ExecuteSqlVo(sql_task));
        // 删除HistoricActivityInstance
        String sql_activity = "delete from act_hi_actinst where " + "TASK_ID_='" + taskId
                + "' or TASK_ID_='" + taskInstance.getId() + "'";
        this.executeSqlDao.executeSql(new ExecuteSqlVo(sql_activity));
        // 获取当前的任务,保存签收人
        Task task = taskService.createTaskQuery()
                .executionId(taskInstance.getExecutionId()).singleResult();
        task.setAssignee(taskInstance.getAssignee());
        task.setOwner(taskInstance.getOwner());
        taskService.saveTask(task);
        // 解决HistoricActivityInstance的Assignee为空的现象
        if (!StringUtils.isEmpty(taskInstance.getAssignee())) {
            String sql_update = "update act_hi_actinst set " + "ASSIGNEE_='"
                    + taskInstance.getAssignee() + "' where TASK_ID_='" + task.getId()
                    + "'";
            this.executeSqlDao.executeSql(new ExecuteSqlVo(sql_update));
        }

        String sql_update_execution = "update act_ru_execution set " + "ACT_ID_='"
                + taskInstance.getTaskDefinitionKey() + "' where ID_='"
                + taskInstance.getExecutionId() + "'";
        this.executeSqlDao.executeSql(new ExecuteSqlVo(sql_update_execution));
        return ResultGenerator.genSuccessResult(true);
    }
}
