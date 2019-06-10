package com.jiewen.modules.sys.entity;

import com.jiewen.jwp.base.entity.DataEntity;

/**
 * 角色用户实体
 * @author liyuze
 *
 */
public class SysUserRole  extends DataEntity {

    private static final long serialVersionUID = 1L;
    
    private String userId; // 用户ID
    
    private String roleId; // 角色ID
    
    private String selectedType; // 查询类型
    
	public String getUserId() {
		return userId;
	}
	
	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	public String getRoleId() {
		return roleId;
	}
	
	public void setRoleId(String roleId) {
		this.roleId = roleId;
	}
	
	public String getSelectedType() {
		return selectedType;
	}
	
	public void setSelectedType(String selectedType) {
		this.selectedType = selectedType;
	}
    
}
