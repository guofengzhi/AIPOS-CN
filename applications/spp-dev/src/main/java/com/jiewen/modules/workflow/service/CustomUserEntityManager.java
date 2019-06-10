package com.jiewen.modules.workflow.service;

import java.util.List;

import javax.annotation.Resource;

import org.activiti.engine.identity.Group;
import org.activiti.engine.identity.User;
import org.activiti.engine.impl.persistence.entity.UserEntityManager;

/**
 * 自定义用户查询
 */
public class CustomUserEntityManager extends UserEntityManager {

    @Resource
    private IdentityPageService identityPageService;

    @Override
    public User findUserById(String userId) {
        return identityPageService.findUserById(userId);
    }

    @Override
    public List<Group> findGroupsByUser(String userId) {
        return identityPageService.findGroupsByUser(userId);
    }

}