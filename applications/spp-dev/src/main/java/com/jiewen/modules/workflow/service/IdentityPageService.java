
package com.jiewen.modules.workflow.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.activiti.engine.IdentityService;
import org.activiti.engine.identity.Group;
import org.activiti.engine.identity.NativeGroupQuery;
import org.activiti.engine.identity.User;
import org.activiti.engine.identity.UserQuery;
import org.activiti.engine.impl.persistence.entity.GroupEntity;
import org.activiti.engine.impl.persistence.entity.UserEntity;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageInfo;
import com.jiewen.jwp.base.service.BaseService;
import com.jiewen.jwp.base.utils.StrUtil;
import com.jiewen.jwp.common.Collections3;
import com.jiewen.modules.workflow.dao.ExecuteSqlDao;
import com.jiewen.modules.workflow.entity.ExecuteSqlVo;

@Service
public class IdentityPageService extends BaseService {

    @Autowired
    private ExecuteSqlDao executeSqlDao;

    @Autowired
    private IdentityService identityService;

    public String getUserNamesByUserIds(String userIds) {
        StringBuilder sql = new StringBuilder();
        sql.append("select distinct FIRST_ as name from act_id_user us");
        sql.append(" where us.ID_ in (" + StrUtil.getInStr(userIds) + ")");
        List<Map<String, Object>> list = this.executeSqlDao
                .executeSql(new ExecuteSqlVo(sql.toString()));
        return Collections3.extractToString(list, "name", ",");
    }

    public String getUserNamesByGroupIds(String groupIds) {
        StringBuilder sql = new StringBuilder();
        sql.append("select DISTINCT FIRST_ as name from act_id_membership m");
        sql.append(" left JOIN act_id_user u on m.USER_ID_=u.ID_");
        sql.append(" where m.GROUP_ID_ in (" + StrUtil.getInStr(groupIds) + ")");
        List<Map<String, Object>> list = this.executeSqlDao
                .executeSql(new ExecuteSqlVo(sql.toString()));
        return Collections3.extractToString(list, "name", ",");
    }

    public String getGroupNamesByGroupIds(String groupIds) {
        StringBuilder sql = new StringBuilder();
        sql.append("select distinct NAME_ as name from act_id_group gp");
        sql.append(" where gp.ID_ in (" + StrUtil.getInStr(groupIds) + ")");
        List<Map<String, Object>> list = this.executeSqlDao
                .executeSql(new ExecuteSqlVo(sql.toString()));
        return Collections3.extractToString(list, "name", ",");
    }

    public Group findGroupById(String groupId) {
        String sql = "select id,name,code from tbl_role where id=" + groupId;
        List<Map<String, Object>> maps = this.executeSqlDao.executeSql(new ExecuteSqlVo(sql));
        if (maps == null || maps.isEmpty()) {
            return null;
        }
        Map<String, Object> map = maps.get(0);
        GroupEntity group = new GroupEntity();
        group.setId(map.get("id").toString());
        group.setName(map.get("name").toString());
        group.setType(map.get("code").toString());
        return group;
    }

    public List<Group> findGroupsByUser(String userId) {
        String sql = "select r.id id,name,code from tbl_role r"
                + " left join tbl_user_role ur on r.id=ur.roleid" + " where ur.userid=" + userId;
        List<Map<String, Object>> maps = this.executeSqlDao.executeSql(new ExecuteSqlVo(sql));
        List<Group> groups = new ArrayList<>();
        for (Map<String, Object> map : maps) {
            Group group = new GroupEntity();
            group.setId(map.get("id").toString());
            group.setName(map.get("name").toString());
            group.setType(map.get("code").toString());
            groups.add(group);
        }
        return groups;
    }

    public User findUserById(String userId) {
        String sql = "select id,name,login_name,email,password from tbl_user where id=" + userId;
        List<Map<String, Object>> maps = this.executeSqlDao.executeSql(new ExecuteSqlVo(sql));
        if (maps == null || maps.isEmpty()) {
            return null;
        }
        Map<String, Object> map = maps.get(0);
        UserEntity userEntity = new UserEntity();
        userEntity.setId(map.get("id").toString());
        userEntity.setFirstName(map.get("name").toString());
        userEntity.setLastName(map.get("login_name").toString());
        userEntity.setEmail(map.get("email").toString());
        userEntity.setPassword(map.get("password").toString());
        return userEntity;
    }

    public PageInfo<User> getUserList(com.jiewen.modules.workflow.entity.UserEntity userEntity) {
        String name = null;
        String groupId = null;
        if (userEntity != null) {
            if (StringUtils.isNotEmpty(userEntity.getName())) {
                name = userEntity.getName();
            }
            if (StringUtils.isNotEmpty(userEntity.getGroupId())) {
                groupId = userEntity.getGroupId();
            }
        }
        List<User> userList;
        long count;
        UserQuery query = identityService.createUserQuery();
        if (!StringUtils.isEmpty(name)) {
            query = query.userFirstNameLike(name);
        }
        if (!StringUtils.isEmpty(groupId)) {
            query = query.memberOfGroup(groupId);
        }
        count = query.count();
        userList = query.orderByUserId().asc()
                .listPage((userEntity.getPage() - 1) * userEntity.getRows(), userEntity.getRows());

        PageInfo<User> pageInfo = new PageInfo<>();
        pageInfo.setList(userList);
        pageInfo.setTotal(count);
        return pageInfo;
    }

    public PageInfo<Group> getGroupList(com.jiewen.modules.workflow.entity.UserEntity userEntity) {
        String name = null;
        if (StringUtils.isNotEmpty(userEntity.getName())) {
            name = userEntity.getName();
        }
        List<Group> groupList;
        long count;
        String sql = "SELECT * FROM  act_id_group  where 1=1 order by ID_";
        if (!StringUtils.isEmpty(name)) {
            sql = sql.replace("1=1", "NAME_ like '" + name + "' or TYPE_ like '" + name + "'");
        }
        NativeGroupQuery query = identityService.createNativeGroupQuery().sql(sql);
        // native查询中一下查询会有异常
        // count=query.count();
        // 改成如下，查询正常
        count = identityService.createNativeGroupQuery()
                .sql("select count(ID_) from (" + sql + ") t").count();
        groupList = query.listPage((userEntity.getPage() - 1) * userEntity.getRows(),
                userEntity.getRows());

        PageInfo<Group> pageInfo = new PageInfo<>();
        pageInfo.setList(groupList);
        pageInfo.setTotal(count);
        return pageInfo;
    }

    public User getUser(String userId) {
        User user = identityService.createUserQuery().userId(userId).singleResult();
        return user;
    }
}
