package com.jiewen.modules.sys.entity;

import java.io.Serializable;

import com.jiewen.jwp.base.entity.DataEntity;

/**
 * 数据库表Entity
 */
public class Columns extends DataEntity implements Serializable {

    private static final long serialVersionUID = 1L;

    private String columnName; 
    
    private String dataType; 
    
	private String columnComment; 
    
    private String columnKey; 
    
    private String extra; 
    
    
    private String cloumnId;

    public String getCloumnId() {
		return cloumnId;
	}

	public void setCloumnId(String cloumnId) {
		this.cloumnId = cloumnId;
	}


 	private String comments; 	// 列名备注

 	
 	private String attrName; // 属性名称(第一个字母大写)，如：user_name => UserName
 	
 
 	private String attrname; 	// 属性名称(第一个字母小写)，如：user_name => userName
 	
 
 	private String attrType; 	// 属性类型
 	
 	 public Columns() {
         super();
     }

     public Columns(String id) {
         super(id);
     }

	public String getComments() {
		return comments;
	}

	public void setComments(String comments) {
		this.comments = comments;
	}

	public String getAttrName() {
		return attrName;
	}

	public void setAttrName(String attrName) {
		this.attrName = attrName;
	}

	public String getAttrname() {
		return attrname;
	}

	public void setAttrname(String attrname) {
		this.attrname = attrname;
	}

	public String getAttrType() {
		return attrType;
	}

	public void setAttrType(String attrType) {
		this.attrType = attrType;
	}

	public String getColumnName() {
		return columnName;
	}

	public void setColumnName(String columnName) {
		this.columnName = columnName;
	}

	public String getDataType() {
		return dataType;
	}

	public void setDataType(String dataType) {
		this.dataType = dataType;
	}

	public String getColumnComment() {
		return columnComment;
	}

	public void setColumnComment(String columnComment) {
		this.columnComment = columnComment;
	}

	public String getColumnKey() {
		return columnKey;
	}

	public void setColumnKey(String columnKey) {
		this.columnKey = columnKey;
	}

	public String getExtra() {
		return extra;
	}

	public void setExtra(String extra) {
		this.extra = extra;
	}
}