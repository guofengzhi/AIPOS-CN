
package com.jiewen.base.sys.dao;

import java.util.List;

import com.jiewen.base.core.dao.CrudDao;
import com.jiewen.base.sys.entity.Dict;

/**
 * 字典DAO接口
 */
public interface DictDao extends CrudDao<Dict> {

    public List<String> findTypeList(Dict dict);

}
