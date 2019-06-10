package com.jiewen.modules.baseinfo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jiewen.jwp.base.service.CrudService;
import com.jiewen.modules.baseinfo.dao.StrategyDao;
import com.jiewen.modules.baseinfo.entity.Strategy;

@Service
public class StrategyService extends CrudService<StrategyDao, Strategy> {

    @Autowired
    private StrategyDao strategyDao;

    @Transactional(readOnly = false)
    public void deleteById(Strategy strategy) {
        dao.delete(strategy);
    }

    @Transactional(readOnly = false)
    public void saveStrategy(Strategy strategy) {
        strategy.preInsert(true);
        dao.insert(strategy);
    }

    @Transactional(readOnly = false)
    public void update(Strategy strategy) {
        strategy.preUpdate();
        dao.update(strategy);
    }

    public Strategy findStrategyByName(String strategyName) {
        return strategyDao.findStrategyByName(strategyName);
    }

}
