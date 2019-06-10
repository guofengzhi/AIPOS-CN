package com.jiewen.spp.service.impl;

import java.util.List;

import org.apache.ibatis.exceptions.TooManyResultsException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.jiewen.spp.dao.TmsStrategyMapper;
import com.jiewen.spp.model.TmsStrategy;
import com.jiewen.spp.service.TmsStrategyService;

import tk.mybatis.mapper.entity.Condition;

@Service
public class TmsStrategyServiceImpl implements TmsStrategyService {

	@Autowired
	private TmsStrategyMapper tmsStrategyMapper;
	
	@Override
	public void save(TmsStrategy model) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void save(List<TmsStrategy> models) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteById(Integer id) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteByIds(String ids) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void update(TmsStrategy model) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public TmsStrategy findById(Integer id) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public TmsStrategy findBy(String fieldName, Object value) throws TooManyResultsException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<TmsStrategy> findByIds(String ids) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<TmsStrategy> findByCondition(Condition condition) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<TmsStrategy> findAll() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public TmsStrategy getStrategyByFileId(String id) {
		return tmsStrategyMapper.getStrategyByFileId(id);
	}


}
