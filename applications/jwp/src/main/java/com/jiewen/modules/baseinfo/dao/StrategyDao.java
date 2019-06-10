package com.jiewen.modules.baseinfo.dao;

import org.springframework.transaction.annotation.Transactional;

import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.modules.baseinfo.entity.Strategy;

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
