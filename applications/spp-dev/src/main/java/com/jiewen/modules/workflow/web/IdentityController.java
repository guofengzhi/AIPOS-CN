
package com.jiewen.modules.workflow.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.activiti.engine.identity.Group;
import org.activiti.engine.identity.User;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageInfo;
import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.base.web.ParamResult;
import com.jiewen.modules.workflow.entity.UserEntity;
import com.jiewen.modules.workflow.service.IdentityPageService;

/**
 *
 * 用户/用户组控制器
 */
@Controller
@RequestMapping("/activiti")
public class IdentityController extends BaseController {

    @Resource
    private IdentityPageService identityPageService;

    // 用户选择界面
    // multiple=0 单选 multiple=1 多选
    @RequestMapping(value = "/user/select/{multiple}/{ids}", method = RequestMethod.GET)
    public String selectUserPage(@PathVariable("multiple") String multiple,
                                 @PathVariable("ids") String ids,
                                 HttpServletRequest request) {
        request.setAttribute("multiple", multiple);
        request.setAttribute("ids", ids);
        return "modules/workflow/id_user_select";
    }

    // 用户组选择界面
    @RequestMapping(value = "/group/select/{ids}", method = RequestMethod.GET)
    public String selectGroupPage(@PathVariable("ids") String ids,
                                  HttpServletRequest request) {
        request.setAttribute("ids", ids);
        return "modules/workflow/id_group_select";
    }

    @RequestMapping(value = "/{type}/names", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> getNamesByIds(@PathVariable("type") String type,
                                             String ids) {
        Map<String, String> map = new HashMap<>();
        String names = "";
        if ("user".equals(type)) {
            names = identityPageService.getUserNamesByUserIds(ids);
        } else {
            names = identityPageService.getGroupNamesByGroupIds(ids);
        }
        map.put("name", names);
        return map;
    }

    @RequestMapping(value = "/user/getUserList")
    public @ResponseBody Map<String, Object> findUserList(String reqObj) {
        UserEntity userEntity = new ParamResult<UserEntity>(reqObj)
                .getEntity(UserEntity.class);
        PageInfo<User> pageInfo = identityPageService.getUserList(userEntity);
        return resultMap(userEntity, pageInfo);
    }

    @RequestMapping(value = "/user/getGroupList")
    public @ResponseBody Map<String, Object> findGroupList(String reqObj) {
        UserEntity userEntity = new ParamResult<UserEntity>(reqObj)
                .getEntity(UserEntity.class);
        PageInfo<Group> pageInfo = identityPageService.getGroupList(userEntity);
        return resultMap(userEntity, pageInfo);
    }

}
