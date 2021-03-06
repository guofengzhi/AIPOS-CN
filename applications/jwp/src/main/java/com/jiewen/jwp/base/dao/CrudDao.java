package com.jiewen.jwp.base.dao;

import java.util.List;

/**
 * DAO支持类实现
 * 
 * @author Administrator
 *
 * @param <T>
 */
public interface CrudDao<T> extends BaseDao, BaseMapper<T> {
    /**
     * 获取单条数据
     * 
     * @param id
     * @return
     */
    public T get(String id);

    /**
     * 获取单条数据
     * 
     * @param entity
     * @return
     */
    public T get(T entity);

    /**
     * 查询数据列表;
     * 
     * @param entity
     * @return
     */
    public List<T> findList(T entity);

    /**
     * 查询所有数据列表
     * 
     * @param entity
     * @return
     */
    public List<T> findAllList(T entity);

    /**
     * 查询所有数据列表
     * 
     * @see public List<T> findAllList(T entity)
     * @return
     */
    public List<T> findAllList();

    /**
     * 插入数据
     * 
     * @param entity
     * @return
     */
    @Override
    public int insert(T entity);

    /**
     * 批量插入数据
     */
    @Override
    public int insertList(List<T> entityList);

    /**
     * 更新数据
     * 
     * @param entity
     * @return
     */
    public int update(T entity);

    /**
     * 删除数据（一般为逻辑删除，更新del_flag字段为1）
     * 
     * @param id
     * @see public int delete(T entity)
     * @return
     */
    public int delete(String id);

    /**
     * 删除数据（一般为逻辑删除，更新del_flag字段为1）
     * 
     * @param entity
     * @return
     */
    @Override
    public int delete(T entity);
    
    /**
     * 查询数据列表;
     * 
     * @param entity
     * @return
     */
    public List<T> findRoleUserList(T entity);

}
