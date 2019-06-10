
package com.jiewen.base.sys.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.jiewen.base.config.Global;
import com.jiewen.base.core.entity.TreeNode;
import com.jiewen.base.core.web.BaseController;
import com.jiewen.base.core.web.Result;
import com.jiewen.base.core.web.ResultGenerator;
import com.jiewen.base.sys.entity.Office;
import com.jiewen.base.sys.entity.User;
import com.jiewen.base.sys.service.OfficeService;
import com.jiewen.base.sys.utils.DictUtils;
import com.jiewen.base.sys.utils.UserUtils;
import com.jiewen.jwp.common.utils.StringUtils;

/**
 * 机构Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/office")
public class OfficeController extends BaseController {

    @Autowired
    private OfficeService officeService;

    @RequestMapping(value = { "get" })
    @ResponseBody
    public Office get(@RequestParam(required = false) String id) {
        Office office = new Office();
        if (StringUtils.isNotBlank(id)) {
            office = officeService.get(id);
            if (!StringUtils.equals(office.getParentId(), "0")) {
                office.setParentName(office.getParent().getName());
                ;
            } else {
                office.setParentName(office.getName());
            }
        }
        return office;
    }

    @RequiresPermissions("sys:office:view")
    @RequestMapping(value = { "" })
    public String index() {
        return "modules/sys/officeTree";
    }
    @RequiresPermissions("sys:office:view")
    @RequestMapping(value = { "viewOfficeTree" })
    public String viewOfficeTree() {
    	return "modules/sys/officeTree2";
    }

    @RequiresPermissions("sys:office:view")
    @RequestMapping(value = { "list" })
    public String list(Office office, Model model) {
        model.addAttribute("list", officeService.findList(office));
        return "modules/sys/officeList";
    }
    
    @RequiresPermissions("sys:office:edit")
    @RequestMapping(value = "save")
    @ResponseBody
    public Result save(Office office, Model model) {
        User user = UserUtils.getUser();
        if (office.getParent() == null || StringUtils.isNotBlank(office.getParent().getId())) {
            office.setParent(new Office(office.getParentId()));
        }
        if (office.getArea() == null || office.getArea().getId() == null) {
            office.setArea(user.getOffice().getArea());
        }
        if (!beanValidator(model, office)) {
            return ResultGenerator.genFailResult((String) model.asMap().get("message"));
        }
        officeService.save(office);
        String unknow = messageSourceUtil.getMessage("common.sys.unknow");
        if (office.getChildDeptList() != null) {
            Office childOffice = null;
            for (String id : office.getChildDeptList()) {
                childOffice = new Office();
                childOffice.setName(DictUtils.getDictLabel(id, "sys_office_common", unknow));
                childOffice.setParent(office);
                childOffice.setArea(office.getArea());
                childOffice.setType("2");
                childOffice.setGrade(String.valueOf(Integer.valueOf(office.getGrade()) + 1));
                childOffice.setUseable(Global.YES);
                officeService.save(childOffice);
            }
        }
        String saveOrgan = messageSourceUtil.getMessage("sys.organ.tip.saveOrgan");
        String success = messageSourceUtil.getMessage("common.sys.success");
        return ResultGenerator
                .genSuccessResult(saveOrgan + "  " + office.getName() + "  " + success);
    }

    @RequiresPermissions("sys:office:edit")
    @RequestMapping(value = "delete")
    public @ResponseBody Result delete(String id) {
        Office office = new Office(id);
        officeService.delete(office);
        String message = messageSourceUtil.getMessage("sys.organ.tip.deleteSuccess");
        return ResultGenerator.genSuccessResult(message);
    }

    /**
     * 获取机构JSON数据。
     * 
     * @return
     */
    @RequiresPermissions("user")
    @RequestMapping(value = "treeData")
    public @ResponseBody List<TreeNode> treeData() {
        return officeService.getOrgTreeData();
    }
    
    /**
     * 获取机构JSON数据。
     * 
     * @return
     */
    @RequiresPermissions("user")
    @RequestMapping(value = "treeDataFilter")
    public @ResponseBody List<TreeNode> treeDataFilter() {
        return officeService.getUserOrgTreeData();
    }
    
    /**
     * 获取机构JSON数据。
     * 
     * @return
     */
    @RequiresPermissions("user")
    @RequestMapping(value = "toOfficeTree")
    public String toOfficeTree(HttpServletRequest request) {
    	HttpSession session = request.getSession();
    	session.setAttribute("orgSelect", request.getParameter("orgSelect"));
    	session.setAttribute("orgSelectValue", request.getParameter("orgSelectValue"));
    	session.setAttribute("windowId", request.getParameter("windowId"));
        return "modules/sys/officeTree2";
    }
}
