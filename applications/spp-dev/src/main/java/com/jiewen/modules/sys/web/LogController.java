
package com.jiewen.modules.sys.web;

import java.util.List;
import java.util.Map;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageInfo;
import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.base.web.ParamResult;
import com.jiewen.modules.sys.entity.Dict;
import com.jiewen.modules.sys.entity.Log;
import com.jiewen.modules.sys.service.DictService;
import com.jiewen.modules.sys.service.LogService;

/**
 * 日志Controller
 */
@Controller
@RequestMapping(value = "/sys/log")
public class LogController extends BaseController {

    @Autowired
    private LogService logService;

    @Autowired
    private DictService dictService;

    @RequiresPermissions("sys:log:view")
    @RequestMapping(value = { "index" })
    public String index(ModelMap map) {
        String lacalanguage = LocaleContextHolder.getLocale().toString().toLowerCase();
        Dict dict = new Dict();
        dict.setLang(lacalanguage);
        List<Dict> findLangTypeList = dictService.findLangTypeList(dict);
        map.put("localLang", lacalanguage);
        if (findLangTypeList.size() == 0) {
            map.put("localLang", defalutLocale);
        }
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
