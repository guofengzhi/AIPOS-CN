
package com.jiewen.modules.workflow.web;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.jiewen.jwp.base.utils.IdGen;
import com.jiewen.jwp.base.utils.LocaleMessageSourceUtil;
import com.jiewen.jwp.base.web.Result;
import com.jiewen.modules.sys.utils.UserUtils;
import com.jiewen.modules.workflow.service.RuntimePageService;

/**
 *
 * 工作流Demo
 */
@Controller
@RequestMapping(value = "/activiti/demo")
public class DemoController {

    @Resource
    protected LocaleMessageSourceUtil messageSourceUtil;

    @Resource
    private RuntimePageService runtimePageService;

    @RequestMapping(value = "/vacation", method = RequestMethod.GET)
    private String vacation(HttpServletRequest request) {
        return "modules/demo/vacation";
    }

    private static final String VACATION_KEY = "vacationRequestStart";

    // 流程启动接口
    @RequestMapping(value = "/vacation/startFlow", method = RequestMethod.POST)
    @ResponseBody
    private Result startFlow(@RequestParam Map<String, Object> formData) {
        String leave = messageSourceUtil.getMessage("activity.demo.leave");
        String leaveResult = messageSourceUtil.getMessage("activity.demo.leave.result");
        // TODO 业务上保存数据
        // ----------------
        // 模拟业务id
        String businessKey = IdGen.uuid();
        String userId = UserUtils.getUser().getId();
        String processInstanceName = formData.get("applyUserName") + leave
                + formData.get("days") + leaveResult + formData.get("motivation");
        return runtimePageService.startProcessInstanceByKey(VACATION_KEY,
                processInstanceName, formData, userId, businessKey);
    }

}
