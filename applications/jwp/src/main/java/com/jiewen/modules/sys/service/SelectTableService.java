
package com.jiewen.modules.sys.service;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipOutputStream;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.jiewen.modules.sys.dao.SelectTableDao;
import com.jiewen.modules.sys.entity.Columns;
import com.jiewen.modules.sys.entity.SelectTable;
import com.jiewen.modules.sys.utils.GenUtils;

/**
 * 系统生成代码实现类
 */
@Service
@Transactional
public class SelectTableService   {

    @Autowired
    private SelectTableDao selectTableDao;

    /**
     * 获取分页查询
     *
     * @param user
     * @return
     */
    @Transactional
    public PageInfo<SelectTable> findPage(SelectTable selectTable) {
    	
        PageHelper.startPage(selectTable);
        
        return new PageInfo<SelectTable>(selectTableDao.selectTableList(selectTable));
    }
  



	public  byte[] generatorCode(String[] tableNames) {

		ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
		
		ZipOutputStream zip = new ZipOutputStream(outputStream);
		
		for(String tableName : tableNames){
			
			Map<String, String> table =  selectTableDao.get(tableName); // 查询表信息
			
			List<Columns> columns = selectTableDao.listColumns(tableName); // 查询列信息
			
			GenUtils.generatorCode(table, columns, zip); // 生成代码
		}
		IOUtils.closeQuietly(zip);
		
		return outputStream.toByteArray();
		
	
	}
    
   
}
