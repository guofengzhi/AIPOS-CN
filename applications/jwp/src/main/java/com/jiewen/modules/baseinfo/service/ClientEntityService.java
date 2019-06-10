package com.jiewen.modules.baseinfo.service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.jiewen.jwp.base.entity.TreeNode;
import com.jiewen.jwp.base.service.CrudService;
import com.jiewen.jwp.common.StringUtils;
import com.jiewen.modules.baseinfo.dao.ClientEntityDao;
import com.jiewen.modules.baseinfo.entity.ClientEntity;

@Service
public class ClientEntityService extends CrudService<ClientEntityDao, ClientEntity> {

    @Autowired
    private ClientEntityDao clientEntityDao;

    public List<TreeNode> getClientTreeData() {

        List<ClientEntity> clientList = clientEntityDao.findAllList();

        Map<String, TreeNode> nodelist = new LinkedHashMap<>();
        List<TreeNode> tnlist = new ArrayList<>();
        for (ClientEntity func : clientList) {
            TreeNode node = new TreeNode();
            node.setText(func.getCustomerName());
            node.setId(func.getCustomerId());
            node.setParentId(func.getParentId());
            node.setLevelCode(func.getLevel());
            nodelist.put(node.getId(), node);
        }
        // 构造树形结构
        for (String id : nodelist.keySet()) {
            TreeNode node = nodelist.get(id);
            if (StringUtils.equals("0", node.getParentId())) {
                tnlist.add(node);
            } else {
                if (nodelist.get(node.getParentId()).getNodes() == null) {
                    nodelist.get(node.getParentId()).setNodes(new ArrayList<TreeNode>());
                }
                nodelist.get(node.getParentId()).getNodes().add(node);
            }
        }
        return tnlist;
    }

    public List<ClientEntity> findAllList(ClientEntity clientEntity) {
        return clientEntityDao.findAllList(clientEntity);
    }
    
    public ClientEntity findClientBySn(String sn){
    	return clientEntityDao.findClientBySn(sn);
    }

}
