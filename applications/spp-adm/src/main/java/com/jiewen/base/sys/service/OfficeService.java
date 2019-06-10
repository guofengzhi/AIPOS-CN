
package com.jiewen.base.sys.service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jiewen.base.core.entity.TreeNode;
import com.jiewen.base.core.service.TreeService;
import com.jiewen.base.sys.dao.OfficeDao;
import com.jiewen.base.sys.entity.Office;
import com.jiewen.base.sys.utils.UserUtils;
import com.jiewen.jwp.common.utils.StringUtils;

/**
 * 机构Service
 */
@Service
@Transactional
public class OfficeService extends TreeService<OfficeDao, Office> {

    public List<Office> findAll() {
        return UserUtils.getOfficeList();
    }

	public List<Office> findUserOrgs() {
		return UserUtils.getUserOfficeList();
	}
    
    public List<Office> findList(Boolean isAll) {
        if (isAll != null && isAll) {
            return UserUtils.getOfficeAllList();
        } else {
            return UserUtils.getOfficeList();
        }
    }

    public List<TreeNode> getOrgTreeData() {
        List<Office> offices = findAll();
        Map<String, TreeNode> nodelist = new LinkedHashMap<>();
        List<TreeNode> tnlist = new ArrayList<>();
        String officeId = UserUtils.getUser().getOfficeId();
        for (Office office : offices) {
            TreeNode node = new TreeNode();
            node.setId(office.getId());
            node.setParentId(office.getParentId());
            node.setText(office.getName());
            node.setLevelCode(String.valueOf(office.getSort()));
            nodelist.put(node.getId(), node);
        }
        // 构造树形结构
        for (Map.Entry<String, TreeNode> entry : nodelist.entrySet()) {
            TreeNode node = entry.getValue();
            if (StringUtils.equals("0", node.getParentId())||StringUtils.equals(officeId, node.getId())) {
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
    
    public List<TreeNode> getUserOrgTreeData() {
		List<Office> offices = findUserOrgs();
        Map<String, TreeNode> nodelist = new LinkedHashMap<>();
        List<TreeNode> tnlist = new ArrayList<>();
        String officeId = UserUtils.getUser().getOfficeId();
        for (Office office : offices) {
            TreeNode node = new TreeNode();
            node.setId(office.getId());
            node.setParentId(office.getParentId());
            node.setText(office.getName());
            node.setLevelCode(String.valueOf(office.getSort()));
            nodelist.put(node.getId(), node);
        }
        // 构造树形结构
        for (Map.Entry<String, TreeNode> entry : nodelist.entrySet()) {
            TreeNode node = entry.getValue();
            if (StringUtils.equals("0", node.getParentId())||StringUtils.equals(officeId, node.getId())) {
            	tnlist.add(node);
			} else {
				TreeNode treeNode = nodelist.get(node.getParentId());
				if (treeNode != null) {
					if (treeNode.getNodes() == null) {
						treeNode.setNodes(new ArrayList<TreeNode>());
					}
					treeNode.getNodes().add(node);
				}
			}
        }
        return tnlist;
	}

    @Transactional(readOnly = true)
    public List<Office> findList(Office office) {
        if (office != null) {
            office.setParentIds(office.getParentIds() + "%");
            return dao.findByParentIdsLike(office);
        }
        return new ArrayList<>();
    }

    @Transactional(readOnly = false)
    @Override
    public void save(Office office) {
        super.save(office);
        UserUtils.removeCache(UserUtils.CACHE_OFFICE_LIST);
    }

    @Transactional(readOnly = false)
    public void delete(Office office) {
        super.delete(office);
        UserUtils.removeCache(UserUtils.CACHE_OFFICE_LIST);
    }

	public Office getOffice(Office officeParam) {
		return UserUtils.get(officeParam);
	}

}
