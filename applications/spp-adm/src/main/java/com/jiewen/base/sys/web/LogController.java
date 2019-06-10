
package com.jiewen.base.sys.web;

import java.util.Map;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageInfo;
import com.jiewen.base.core.web.BaseController;
import com.jiewen.base.core.web.ParamResult;
import com.jiewen.base.sys.entity.Log;
import com.jiewen.base.sys.service.LogService;

/**
 * 日志Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/log")
public class LogController extends BaseController {

    @Autowired
    private LogService logService;

    @RequiresPermissions("sys:log:view")
    @RequestMapping(value = { "index" })
    public String index() {
        return "modules/sys/logList";
    }

    @RequiresPermissions("sys:log:view")
    @RequestMapping(value = { "list", "" })
    public @ResponseBody Map<String, Object> list(String reqObj) {
        Log log = new ParamResult<Log>(reqObj).getEntity(Log.class);
        PageInfo<Log> pageInfo = logService.findPage(log);
        return resultMap(log, pageInfo);
    }

}
