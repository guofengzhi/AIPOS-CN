package com.jiewen.modules.sys.domain;

import java.util.List;

import com.jiewen.modules.sys.entity.Columns;

/**
 * 表数据
 *
 */
public class TableDO {
    
    private String tableName; // 表的名称
   
    private String comments;  // 表的备注
  
    private Columns pk;  // 表的主键
   
    private List<Columns> columns;  // 表的列名(不包含主键)

   
    private String className;  // 类名(第一个字母大写)，如：sys_user => SysUser
  
    private String classname;   // 类名(第一个字母小写)，如：sys_user => sysUser

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    public Columns getPk() {
        return pk;
    }

    public void setPk(Columns pk) {
        this.pk = pk;
    }

    public List<Columns> getColumns() {
        return columns;
    }

    public void setColumns(List<Columns> columns) {
        this.columns = columns;
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public String getClassname() {
        return classname;
    }

    public void setClassname(String classname) {
        this.classname = classname;
    }

    @Override
    public String toString() {
        return "TableDO{" +
                "tableName='" + tableName + '\'' +
                ", comments='" + comments + '\'' +
                ", pk=" + pk +
                ", columns=" + columns +
                ", className='" + className + '\'' +
                ", classname='" + classname + '\'' +
                '}';
    }
}
