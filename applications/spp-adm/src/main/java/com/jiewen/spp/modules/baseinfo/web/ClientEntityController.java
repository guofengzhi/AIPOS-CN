
package com.jiewen.spp.modules.baseinfo.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageInfo;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.jiewen.base.core.entity.TreeNode;
import com.jiewen.base.core.web.BaseController;
import com.jiewen.base.core.web.ParamResult;
import com.jiewen.base.core.web.Result;
import com.jiewen.base.core.web.ResultGenerator;
import com.jiewen.jwp.common.utils.StringUtils;
import com.jiewen.spp.modules.baseinfo.entity.ClientEntity;
import com.jiewen.spp.modules.baseinfo.service.ClientEntityService;

@Controller
@RequestMapping("${adminPath}/client")
public class ClientEntityController extends BaseController {

    @Autowired
    private ClientEntityService clientEntityService;

    @RequestMapping(value = "index")
    public String index() {
        return "modules/client/clientIndex";
    }

    @ModelAttribute
    public ClientEntity get(@RequestParam(required = false) String id) {
        if (!StringUtils.isBlank(id)) {
            ClientEntity clientEntity = new ClientEntity();
            clientEntity.setCustomerId(id);
            return clientEntityService.get(clientEntity);
        } else {
            return new ClientEntity();
        }
    }

    @RequiresPermissions("client:view")
    @RequestMapping(value = { "list", "" })
    @ResponseBody
    public Map<String, Object> list(String reqObj) throws Exception {
        ClientEntity clientEntity = new ParamResult<ClientEntity>(reqObj)
                .getEntity(ClientEntity.class);
        PageInfo<ClientEntity> pageInfo = clientEntityService.findPage(clientEntity);
        return resultMap(clientEntity, pageInfo);
    }

    /**
     * isShowHide是否显示隐藏菜单
     * 
     * @param extId
     * @param isShowHidden
     * @param response
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/clientTreeData", method = { RequestMethod.GET, RequestMethod.POST })
    public List<TreeNode> clientTreeData() {
        return clientEntityService.getClientTreeData();
    }

    @RequestMapping(value = "getClientEntityById")
    public @ResponseBody Result getClientEntityById(ClientEntity clientEntity) {

        String searchError = messageSourceUtil.getMessage("common.search.error");
        ClientEntity client = clientEntityService.get(clientEntity);
        if (client != null) {

            return ResultGenerator.genSuccessResult(client);
        }
        return ResultGenerator.genFailResult(searchError);
    }

    @RequestMapping(value = "treeData/{industryId}")
    @ResponseBody
    public List<Map<String, Object>> treeData(@RequestParam(required = false) String extId,
            @PathVariable String industryId, HttpServletResponse response) {
        List<Map<String, Object>> mapList = Lists.newArrayList();
        ClientEntity client = new ClientEntity();
        if (!"0".equals(industryId)) {
            client.setIndustry(industryId);
        }
        List<ClientEntity> list = clientEntityService.findAllList(client);
        for (int i = 0; i < list.size(); i++) {
            ClientEntity e = list.get(i);
            Map<String, Object> map = Maps.newHashMap();
            map.put("id", e.getCustomerId());
            map.put("pId", e.getParentId());
            map.put("name", e.getCustomerName());
            mapList.add(map);
        }
        return mapList;
    }

    @RequestMapping(value = { "getClientBySn", "" })
    @ResponseBody
    public Result getClientIdBySn(String sn) {
        String message = messageSourceUtil.getMessage("modules.baseinfo.not.corresponding.custom");
        ClientEntity client = clientEntityService.findClientBySn(sn);
        if (client != null) {
            return ResultGenerator.genSuccessResult(client);
        }
        return ResultGenerator.genFailResult(message);
    }

}
