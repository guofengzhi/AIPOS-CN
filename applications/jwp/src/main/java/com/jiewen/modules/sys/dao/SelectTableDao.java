package com.jiewen.modules.sys.dao;

import java.util.List;
import java.util.Map;

import org.springframework.transaction.annotation.Transactional;

import com.jiewen.modules.sys.entity.Columns;
import com.jiewen.modules.sys.entity.SelectTable;

/**
 * 查询数据库结构表DAO接口
 */
@Transactional
public interface SelectTableDao {
	
	/**
     * 查询数据列表;
     * 
     * @param entity
     * @return
     */
    public  List<SelectTable> selectTableList(SelectTable selectTable);
    
    public  List<Columns> listColumns(String  tableName);
    
    public  Map<String, String> get(String  tableName);
    
    public  int count();
}
