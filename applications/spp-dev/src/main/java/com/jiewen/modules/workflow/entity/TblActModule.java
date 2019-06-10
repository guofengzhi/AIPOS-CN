package com.jiewen.modules.workflow.entity;

import java.util.Date;

import com.jiewen.jwp.base.entity.DataEntity;

/**
 * 业务定义Entity
 * 
 * @author Pang.M 2018年1月15日
 *
 */
public class TblActModule extends DataEntity {

	private static final long serialVersionUID = 1L;

	private Date createDateTime;

	private Date updateDateTime;

	private int deleted;

	private int version;

	private String code;

	private String name;

	private String remark;

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public Date getCreateDateTime() {
		return createDateTime;
	}

	public void setCreateDateTime(Date createDateTime) {
		this.createDateTime = createDateTime;
	}

	public Date getUpdateDateTime() {
		return updateDateTime;
	}

	public void setUpdateDateTime(Date updateDateTime) {
		this.updateDateTime = updateDateTime;
	}

	public int getDeleted() {
		return deleted;
	}

	public void setDeleted(int deleted) {
		this.deleted = deleted;
	}

	public int getVersion() {
		return version;
	}

	public void setVersion(int version) {
		this.version = version;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

}
