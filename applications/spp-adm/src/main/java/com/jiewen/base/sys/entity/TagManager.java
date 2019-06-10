
package com.jiewen.base.sys.entity;

import com.jiewen.base.core.entity.DataEntity;

/**
 * 标签Entity
 */
public class TagManager extends DataEntity<TagManager> {

    private static final long serialVersionUID = 1L;
    
    private String id;
    
    private String tagName;
    
    private String tagCreateDate;
    
    private String tagStatus;
    
    private String orgId;
    
    private String orgName;
  
    private String deviceCount;
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getTagName() {
		return tagName;
	}

	public void setTagName(String tagName) {
		this.tagName = tagName;
	}


	public String getTagCreateDate() {
		return tagCreateDate;
	}

	public void setTagCreateDate(String tag_createDate) {
		this.tagCreateDate = tag_createDate;
	}

	public String getTagStatus() {
		return tagStatus;
	}

	public void setTagStatus(String tagStatus) {
		this.tagStatus = tagStatus;
	}

	public String getOrgId() {
		return orgId;
	}

	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}
	
	public String getOrgName() {
		return orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getDeviceCount() {
		return deviceCount;
	}

	public void setDeviceCount(String deviceCount) {
		this.deviceCount = deviceCount;
	}
	
}
