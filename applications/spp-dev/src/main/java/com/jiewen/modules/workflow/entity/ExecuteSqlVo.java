package com.jiewen.modules.workflow.entity;

public class ExecuteSqlVo {

    private String sql;

    public String getSql() {
        return sql;
    }

    public void setSql(String sql) {
        this.sql = sql;
    }

    public ExecuteSqlVo(String sql) {
        super();
        this.sql = sql;
    }

}
