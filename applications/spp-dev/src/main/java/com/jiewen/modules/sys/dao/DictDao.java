package com.jiewen.modules.sys.dao;

import java.util.List;

import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.modules.sys.entity.Dict;

/**
 * 字典DAO接口
 */
public interface DictDao extends CrudDao<Dict> {

    public List<String> findTypeList(Dict dict);
    
    public List<Dict> findLangTypeList(Dict dict);

    /**
     * 查询用户ID
     */
    public Dict selectDictId();
}
