
package com.jiewen.base.core.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.jiewen.base.core.dao.CrudDao;
import com.jiewen.base.core.entity.DataEntity;
import com.jiewen.jwp.common.utils.StringUtils;

/**
 * Service基类
 */
@Transactional(readOnly = true)
public abstract class CrudService<D extends CrudDao<T>, T extends DataEntity<T>>
        extends BaseService {

    /**
     * 获取redis连接
     */

    protected static RedisTemplate<Object, Object> redisTemplate;

    public RedisTemplate<Object, Object> getRedisTemplate() {
        return redisTemplate;
    }

    @Autowired
    public void setRedisTemplate(RedisTemplate<Object, Object> redisTemplate) {
        CrudService.redisTemplate = redisTemplate;
    }

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
        PageHelper.startPage(entity);
        return new PageInfo<>(findList(entity));

    }

    /**
     * 保存数据（插入或更新）
     * 
     * @param entity
     */
    @Transactional(readOnly = false)
    public void save(T entity) {
        if (StringUtils.isBlank(entity.getId())) {
            entity.preInsert();
            dao.insert(entity);
        } else {
            entity.preUpdate();
            dao.update(entity);
        }
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

    public static void cachePut(String key, Object value) {
        try {
            ValueOperations<Object, Object> opts = redisTemplate.opsForValue();
            opts.set(key, value);
        } catch (Exception e) {
            logger.error("操作内存数据错误" + e.getMessage(), e);
        }

    }

    public static void cacheRemove(String key) {
        try {
            redisTemplate.delete(key);
        } catch (Exception e) {
            logger.error("连接redis错误" + e.getMessage(), e);
        }

    }

}
