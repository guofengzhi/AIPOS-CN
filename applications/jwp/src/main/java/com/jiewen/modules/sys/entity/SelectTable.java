package com.jiewen.modules.sys.entity;

import java.io.Serializable;

import com.jiewen.jwp.base.entity.DataEntity;

/**
 * 数据库表Entity
 */
public class SelectTable extends DataEntity implements Serializable {

    private static final long serialVersionUID = 1L;

   
    private String tableName; 
    
    private String engine; 
    
	private String tableComment; 
    
    private String createTime; 

    public SelectTable() {
        super();
    }

    public SelectTable(String id) {
        super(id);
    }

    
	public String getTableName() {
		return tableName;
	}

	public void setTableName(String tableName) {
		this.tableName = tableName;
	}

	public String getEngine() {
		return engine;
	}

	public void setEngine(String eNGINE) {
		engine = eNGINE;
	}

	public String getTableComment() {
		return tableComment;
	}

	public void setTableComment(String tableComment) {
		this.tableComment = tableComment;
	}

	public String getCreateTime() {
		return createTime;
	}

	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}
    



}