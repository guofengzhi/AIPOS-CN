
package com.jiewen.modules.workflow.service;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.impl.bpmn.parser.BpmnParse;
import org.activiti.engine.impl.persistence.entity.ProcessDefinitionEntity;
import org.activiti.engine.repository.Model;
import org.activiti.engine.repository.ModelQuery;
import org.activiti.engine.repository.ProcessDefinition;
import org.activiti.engine.repository.ProcessDefinitionQuery;
import org.activiti.engine.runtime.ProcessInstanceQuery;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageInfo;
import com.jiewen.jwp.base.service.BaseService;
import com.jiewen.modules.workflow.entity.ModelVo;
import com.jiewen.modules.workflow.entity.ProcDefVo;
import com.jiewen.modules.workflow.entity.ProcessInstanceVo;

@Service
public class RepositoryPageService extends BaseService {

    @Autowired
    private RepositoryService repositoryService;

    @Autowired
    private RuntimeService runtimeService;

    @Resource
    private IdentityPageService identityPageService;

    public PageInfo<Model> getModelList(ModelVo actReModel) {

        String name = null;
        if (StringUtils.isNotBlank(actReModel.getName())) {
            name = actReModel.getName();
        }
        ModelQuery query = repositoryService.createModelQuery();
        if (StringUtils.isNotEmpty(name)) {
            query = query.modelNameLike(name);
        }
        long count;
        count = query.count();
        List<Model> modelList;
        modelList = query.orderByCreateTime().desc()
                .listPage((actReModel.getPage() - 1) * actReModel.getRows(), actReModel.getRows());
        PageInfo<Model> pageInfo = new PageInfo<>();
        pageInfo.setList(modelList);
        pageInfo.setTotal(count);
        return pageInfo;
    }

    public PageInfo<ProcDefVo> getProcessDefList(ProcDefVo procDef) {

        String name = null;
        if (StringUtils.isNotBlank(procDef.getName())) {
            name = procDef.getName();
        }

        ProcessDefinitionQuery query = repositoryService.createProcessDefinitionQuery();
        if (StringUtils.isNotEmpty(name)) {
            query = query.processDefinitionNameLike(name);
        }
        long count;
        count = query.count();
        List<ProcessDefinition> processDefList;
        processDefList = query.orderByProcessDefinitionId().desc()
                .listPage((procDef.getPage() - 1) * procDef.getRows(), procDef.getRows());

        List<ProcDefVo> retList = new ArrayList<ProcDefVo>();
        for (ProcessDefinition processDefinition : processDefList) {
            ProcessDefinitionEntity entity = (ProcessDefinitionEntity) processDefinition;
            ProcDefVo vo = new ProcDefVo();
            BeanUtils.copyProperties(entity, vo);
            retList.add(vo);
        }

        PageInfo<ProcDefVo> pageInfo = new PageInfo<>();
        pageInfo.setList(retList);
        pageInfo.setTotal(count);
        return pageInfo;
    }

    public PageInfo<ProcessInstanceVo> getProcessInstanceList(ProcessInstanceVo procinst) {
        String name = null;
        String businessKey = null;
        String category = null;
        if (StringUtils.isNotBlank(procinst.getName())) {
            name = procinst.getName();
        }
        if (StringUtils.isNotBlank(procinst.getBusinessKey())) {
            businessKey = procinst.getBusinessKey();
        }
        if (StringUtils.isNotBlank(procinst.getCategory())) {
            category = procinst.getCategory();
        }
        ProcessInstanceQuery query = runtimeService.createProcessInstanceQuery();
        if (!StringUtils.isEmpty(name)) {
            query = query.processInstanceNameLike(name);
        }
        if (!StringUtils.isEmpty(businessKey)) {
            query = query.processInstanceBusinessKey(businessKey);
        }
        if (!StringUtils.isEmpty(category)) {
            query = query.processDefinitionCategory(category);
        }
        long count;
        count = query.count();
        List<org.activiti.engine.runtime.ProcessInstance> instanceList;
        instanceList = query.orderByProcessInstanceId().desc()
                .listPage((procinst.getPage() - 1) * procinst.getRows(), procinst.getRows());
        // 原来类型为ExecutionEntity，再向前台json格式化的时候出现异常，所以转化为ProcessInstanceVo
        List<ProcessInstanceVo> volist = new ArrayList<ProcessInstanceVo>();
        for (org.activiti.engine.runtime.ProcessInstance processInstance : instanceList) {
            ProcessInstanceVo vo = new ProcessInstanceVo();
            BeanUtils.copyProperties(processInstance, vo);
            // 业务类型
            ProcessDefinition processDefinition = repositoryService
                    .getProcessDefinition(processInstance.getProcessDefinitionId());
            vo.setCategory(processDefinition.getCategory());
            vo.setStartUserId(getStartUserId(processInstance));
            vo.setStartUserName(identityPageService.getUserNamesByUserIds(vo.getStartUserId()));
            volist.add(vo);
        }

        PageInfo<ProcessInstanceVo> pageInfo = new PageInfo<>();
        pageInfo.setList(volist);
        pageInfo.setTotal(count);
        return pageInfo;
    }

    public String getStartUserId(org.activiti.engine.runtime.ProcessInstance processInstance) {
        ProcessDefinitionEntity processDefinition = (ProcessDefinitionEntity) repositoryService
                .getProcessDefinition(processInstance.getProcessDefinitionId());
        String initiator = processDefinition
                .getProperty(BpmnParse.PROPERTYNAME_INITIATOR_VARIABLE_NAME).toString();
        String assign = runtimeService
                .getVariable(processInstance.getProcessInstanceId(), initiator).toString();
        return assign;
    }

}
