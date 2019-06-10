
package com.jiewen.base.sys.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jiewen.base.common.utils.CacheUtils;
import com.jiewen.base.core.service.CrudService;
import com.jiewen.base.sys.dao.DictDao;
import com.jiewen.base.sys.entity.Dict;
import com.jiewen.base.sys.utils.DictUtils;

/**
 * 字典Service
 */
@Service
@Transactional(readOnly = true)
public class DictService extends CrudService<DictDao, Dict> {

    /**
     * 查询字段类型列表
     * 
     * @return
     */
    public List<String> findTypeList() {
        return dao.findTypeList(new Dict());
    }

    @Override
    public Dict get(Dict dict) {
        return dao.get(dict);
    }

    @Transactional(readOnly = false)
    @Override
    public void save(Dict dict) {
        super.save(dict);
        CacheUtils.remove(DictUtils.CACHE_DICT_MAP);
    }

    @Transactional(readOnly = false)
    @Override
    public void delete(Dict dict) {
        super.delete(dict);
        CacheUtils.remove(DictUtils.CACHE_DICT_MAP);
    }

}
