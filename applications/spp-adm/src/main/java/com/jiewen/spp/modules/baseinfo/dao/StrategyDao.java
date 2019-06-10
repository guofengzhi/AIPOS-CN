
package com.jiewen.spp.modules.baseinfo.dao;

import org.springframework.transaction.annotation.Transactional;

import com.jiewen.base.core.dao.CrudDao;
import com.jiewen.spp.modules.baseinfo.entity.Strategy;

/**
 * 策略Dao
 * 
 * @author Administrator
 *
 */
@Transactional
public interface StrategyDao extends CrudDao<Strategy> {

    public Strategy findStrategyByName(String strategyName);

}
