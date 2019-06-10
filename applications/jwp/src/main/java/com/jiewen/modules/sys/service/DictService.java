package com.jiewen.modules.sys.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jiewen.jwp.base.service.CrudService;
import com.jiewen.jwp.base.utils.CacheUtils;
import com.jiewen.modules.sys.dao.DictDao;
import com.jiewen.modules.sys.entity.Dict;
import com.jiewen.modules.sys.utils.DictUtils;

/**
 * 字典Service
 */
@Service
@Transactional(readOnly = true)
public class DictService extends CrudService<DictDao, Dict> {

	 @Autowired
	 private DictDao dictDao;
	
    /**
     * 查询字段类型列表
     * 
     * @return
     */
    public List<String> findTypeList() {
        return dao.findTypeList(new Dict());
    }
    
    /**
     * 查询语言类型列表
     * 
     * @return
     */
    public List<Dict> findLangTypeList(Dict dict) {
    	return dao.findLangTypeList(dict);
    }

    @Override
    public Dict get(Dict dict) {
        return dao.get(dict);
    }

    @Override
    @Transactional(readOnly = false)
    public void save(Dict dict) {
        super.save(dict);
        CacheUtils.remove(DictUtils.CACHE_DICT_MAP);
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(Dict dict) {
        super.delete(dict);
        CacheUtils.remove(DictUtils.CACHE_DICT_MAP);
    }
    
    /**
    *
    * @param id
    * @return
    */
	 public Dict getDict() {
	      return dictDao.selectDictId();
	 }
}
