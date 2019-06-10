package com.jiewen.modules.sys.entity;

import java.util.List;

import com.jiewen.jwp.base.entity.TreeNode;
/**
 * 由于TreeNode中的nodes成员变量类型和此类不同，继承过来会导致父类变量和子类变量同时存在，不理想
 * 因此将TreeNode中变量完全复制过来
 * @author fengcongcong
 *
 */

public class AreaTreeNode {
	private List<TreeNode> officeNodes;
	
	private String text;

    private List<String> tags;

    private String id;

    private String parentId;

    private String levelCode;

    private List<AreaTreeNode> nodes;

    private String icon;
    
	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public List<String> getTags() {
		return tags;
	}

	public void setTags(List<String> tags) {
		this.tags = tags;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getParentId() {
		return parentId;
	}

	public void setParentId(String parentId) {
		this.parentId = parentId;
	}

	public String getLevelCode() {
		return levelCode;
	}

	public void setLevelCode(String levelCode) {
		this.levelCode = levelCode;
	}

	public List<AreaTreeNode> getNodes() {
		return nodes;
	}

	public void setNodes(List<AreaTreeNode> nodes) {
		this.nodes = nodes;
	}

	public String getIcon() {
		return icon;
	}

	public void setIcon(String icon) {
		this.icon = icon;
	}

	public List<TreeNode> getOfficeNodes() {
		return officeNodes;
	}

	public void setOfficeNodes(List<TreeNode> officeNodes) {
		this.officeNodes = officeNodes;
	}
}
