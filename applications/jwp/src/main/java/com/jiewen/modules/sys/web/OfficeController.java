package com.jiewen.modules.sys.web;

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

import com.jiewen.jwp.base.config.Global;
import com.jiewen.jwp.base.entity.TreeNode;
import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.base.web.Result;
import com.jiewen.jwp.base.web.ResultGenerator;
import com.jiewen.modules.sys.entity.Office;
import com.jiewen.modules.sys.entity.User;
import com.jiewen.modules.sys.service.OfficeService;
import com.jiewen.modules.sys.utils.DictUtils;
import com.jiewen.modules.sys.utils.UserUtils;

/**
 * 机构Controller
 */
@Controller
@RequestMapping(value = "/sys/office")
public class OfficeController extends BaseController {

    @Autowired
    private OfficeService officeService;

    @RequestMapping(value = { "get" })
    @ResponseBody
    public Office get(@RequestParam(required = false) String id) {
        Office office = new Office();
        if (org.apache.commons.lang3.StringUtils.isNotBlank(id)) {
            office = officeService.get(id);
            if (!org.apache.commons.lang3.StringUtils.equals(office.getParentId(), "0")) {
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
        //填写上级机构
        if (office.getParent() == null|| org.apache.commons.lang3.StringUtils.isNotBlank(office.getParent().getId())) {
            office.setParent(new Office(office.getParentId()));
        }
        if (office.getArea() == null || office.getArea().getId() == null) {
            office.setArea(user.getOffice().getArea());
        }
        //校验数据
        if (!beanValidator(model, office)) {
            return ResultGenerator.genFailResult((String) model.asMap().get("message"));
        }
      //如果不存在ID则新增ID
        if(office.getId() == null){
        	 office.setId(officeService.selectOfficeId().getId());
        	 officeService.save(office);
        }else{
        	officeService.update(office);
        }
        
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
        return ResultGenerator.genSuccessResult(saveOrgan+"  " + office.getName() + "  " +success);
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
    
    @RequestMapping(value = "selectOfficeUser")
    public @ResponseBody Result selectOfficeUserCount(String id) {
    	 Office office = new Office(id);
         int count=officeService.selectOfficeUserCount(office);
	        if(count >0){
	        	return ResultGenerator.genFailResult(
	        			messageSourceUtil.getMessage("common.TheUserFirstRemoveTheUserOfTheInstitution"));
	        }else{
	            return ResultGenerator.genSuccessResult(messageSourceUtil.getMessage("common.CanBeDelete"));
	        }

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
