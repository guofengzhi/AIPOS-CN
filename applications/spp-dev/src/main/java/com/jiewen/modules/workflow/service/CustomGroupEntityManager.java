package com.jiewen.modules.workflow.service;

import java.util.List;

import javax.annotation.Resource;

import org.activiti.engine.identity.Group;
import org.activiti.engine.impl.persistence.entity.GroupEntityManager;

/**
 *
 * 自定义用户组查询
 */
public class CustomGroupEntityManager extends GroupEntityManager {

    @Resource
    private IdentityPageService identityPageService;

    // @Override
    public Group findGroupById(String groupId) {
        return identityPageService.findGroupById(groupId);
    }

    @Override
    public List<Group> findGroupsByUser(String userId) {
        return identityPageService.findGroupsByUser(userId);
    }
}