package com.jiewen.modules.sys.service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.jiewen.jwp.base.entity.TreeNode;
import com.jiewen.jwp.base.service.TreeService;
import com.jiewen.modules.sys.dao.AreaDao;
import com.jiewen.modules.sys.dao.OfficeDao;
import com.jiewen.modules.sys.entity.Area;
import com.jiewen.modules.sys.entity.AreaTreeNode;
import com.jiewen.modules.sys.entity.Office;
import com.jiewen.modules.sys.utils.UserUtils;

/**
 * 区域Service
 */
@Service
@Transactional(readOnly = true)
public class AreaService extends TreeService<AreaDao, Area> {
	
	
	@Autowired
    private AreaDao areaDao;
	
	public Area selectAreaId() {
        return areaDao.selectAreaId();
    }
 
	@Autowired
	public OfficeDao officeDao;

	public List<Area> findAll() {
        return UserUtils.getAreaList();
    }

    @Override
    @Transactional(readOnly = false)
    public void save(Area area) {
        super.save(area);
        UserUtils.removeCache(UserUtils.CACHE_AREA_LIST);
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(Area area) {
        super.delete(area);
        UserUtils.removeCache(UserUtils.CACHE_AREA_LIST);
    }
    
    public List<AreaTreeNode> getOrgTreeData(){
    	List<Area> areas=findAll();
    	Map<String, AreaTreeNode> nodeList=new LinkedHashMap<String, AreaTreeNode>();
    	List<AreaTreeNode> treeNodeList=new ArrayList<>();
    	
    	//循环遍历，得到一个存储AreaTreeNode的Map
     	for (Area area:areas) {
    		AreaTreeNode node=new AreaTreeNode();
    		node.setId(area.getId());
    		node.setParentId(area.getParentId());
    		node.setText(area.getName());
    		node.setLevelCode(String.valueOf(area.getSort()));
    		nodeList.put(node.getId(), node);
    	}
     	
    	//造树
    	for (String id:nodeList.keySet()) {
    		AreaTreeNode node=nodeList.get(id);
    		if (org.apache.commons.lang3.StringUtils.equals("0", node.getParentId())) {
    			node=linkOffice(node);
    			treeNodeList.add(node);
    		}else {
    			if (nodeList.get(node.getParentId()).getNodes()==null) {
    				nodeList.get(node.getParentId()).setNodes(new ArrayList<AreaTreeNode>());
    			}
    			node=linkOffice(node);
    			nodeList.get(node.getParentId()).getNodes().add(node);
    		
    		}
    	}
    	return treeNodeList;
    }
    
    private AreaTreeNode linkOffice(AreaTreeNode areaTreeNode) {
    	String areaid=areaTreeNode.getId();
		Map<String, TreeNode> nodeList=new LinkedHashMap<String, TreeNode>();
    	List<TreeNode> officeNodeList=new ArrayList<>();
    	List<Office> offices=officeDao.selectOfficeByAreaId(new Area(areaid));
    	//遍历构造TreeNode的Map
    	for (Office office:offices) {
    		TreeNode node=new TreeNode();
    		node.setId(office.getId());
    		node.setParentId(office.getParentId());
    		node.setText(office.getName());
    		node.setLevelCode(String.valueOf(office.getSort()));
    		nodeList.put(node.getId(), node);
    	}
    	
    	//造树
    	for (String id:nodeList.keySet()) {
    		TreeNode node=nodeList.get(id);
    		if (org.apache.commons.lang3.StringUtils.equals("0", node.getParentId())) {
    			officeNodeList.add(node);
    		}else {
    			if (nodeList.get(node.getParentId())==null) {
    				//如果该节点的父节点不在列表当中，说明这是当前地区中的一个顶级机构
    				officeNodeList.add(node);
    			}else {
        			if (nodeList.get(node.getParentId()).getNodes()==null) {
        				nodeList.get(node.getParentId()).setNodes(new ArrayList<TreeNode>());
        			}
        			nodeList.get(node.getParentId()).getNodes().add(node);     				
    			}
    			
    		}
    	}
    	areaTreeNode.setOfficeNodes(officeNodeList);
    	return areaTreeNode;
    }
    
}
