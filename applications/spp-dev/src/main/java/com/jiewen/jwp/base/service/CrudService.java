package com.jiewen.jwp.base.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.PageInfo;
import com.github.pagehelper.page.PageMethod;
import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.jwp.base.entity.DataEntity;

/**
 * Service基类
 */
@Transactional(readOnly = true)
public abstract class CrudService<D extends CrudDao<T>, T extends DataEntity> extends BaseService {

    /**
     * 持久层对象
     */
    @Autowired
    protected D dao;

    /**
     * 获取单条数据
     * 
     * @param id
     * @return
     */
    public T get(String id) {
        return dao.get(id);
    }

    /**
     * 获取单条数据
     * 
     * @param entity
     * @return
     */
    public T get(T entity) {
        return dao.get(entity);
    }

    /**
     * 查询列表数据
     * 
     * @param entity
     * @return
     */
    public List<T> findList(T entity) {
        return dao.findList(entity);
    }

    /**
     * 查询分页数据
     * 
     * @param entity
     * @return
     */
    public PageInfo<T> findPage(T entity) {
        PageMethod.startPage(entity);
        return new PageInfo<>(findList(entity));

    }

    /**
     * 保存数据（插入）
     * 
     * @param entity
     */
    @Transactional(readOnly = false)
    public void save(T entity) {
        entity.preInsert(false);
        dao.insert(entity);
    }
    
    /**
     * 保存数据（更新）
     * 
     * @param entity
     */
    @Transactional(readOnly = false)
    public void update(T entity) {
            entity.preUpdate();
            dao.update(entity);
    }
    
    /**
     * 删除数据
     * 
     * @param entity
     */
    @Transactional(readOnly = false)
    public void delete(T entity) {
        dao.delete(entity);
    }

    /**
     * 批量保存数据
     * 
     * @param List
     */
    @Transactional(readOnly = false)
    public void saveBatch(List<T> entityList) {
        int batchCount = 500;
        int lastBatchIndex = batchCount - 1;
        for (int i = 0; i < entityList.size();) {
            if (lastBatchIndex < entityList.size() - 1) {
                dao.insertList(entityList.subList(i, lastBatchIndex));
                break;
            } else {
                dao.insertList(entityList.subList(i, lastBatchIndex));
                i = lastBatchIndex + 1;
                lastBatchIndex = i + (batchCount - 1);
                break;
            }
        }
        dao.insertList(entityList);
    }

}
