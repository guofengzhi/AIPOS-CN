
package com.jiewen.base.core.dao;

import java.util.List;

import com.jiewen.base.core.entity.TreeEntity;

public interface TreeDao<T extends TreeEntity<T>> extends CrudDao<T> {

    /**
     * 找到所有子节点
     * 
     * @param entity
     * @return
     */
    public List<T> findByParentIdsLike(T entity);

    /**
     * 更新所有父节点字段
     * 
     * @param entity
     * @return
     */
    public int updateParentIds(T entity);

}
