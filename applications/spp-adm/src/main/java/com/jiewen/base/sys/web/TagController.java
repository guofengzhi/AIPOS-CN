
package com.jiewen.base.sys.web;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.jiewen.base.core.web.BaseController;

/**
 * 标签Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/tag")
public class TagController extends BaseController {

    /**
     * 树结构选择标签（treeselect.tag）
     */
    @RequiresPermissions("user")
    @RequestMapping(value = "treeselect")
    public String treeselect(String url, String extId, String checked, String selectIds,
            String isAll, String module, Model model) {
        model.addAttribute("url", url); // 树结构数据URL
        model.addAttribute("extId", extId); // 排除的编号ID
        model.addAttribute("checked", checked); // 是否可复选
        model.addAttribute("selectIds", selectIds); // 指定默认选中的ID
        model.addAttribute("isAll", isAll); // 是否读取全部数据，不进行权限过滤
        model.addAttribute("module", module);
        return "base/tag/tagTreeselect";
    }
}
