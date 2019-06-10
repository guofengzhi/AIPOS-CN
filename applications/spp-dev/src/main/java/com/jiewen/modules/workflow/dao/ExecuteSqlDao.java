package com.jiewen.modules.workflow.dao;

import java.util.List;
import java.util.Map;

import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.modules.workflow.entity.ExecuteSqlVo;

public interface ExecuteSqlDao extends CrudDao<ExecuteSqlVo> {

    public List<Map<String, Object>> executeSql(ExecuteSqlVo vo);
}
