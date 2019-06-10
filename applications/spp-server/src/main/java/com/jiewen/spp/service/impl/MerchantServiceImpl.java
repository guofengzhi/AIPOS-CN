package com.jiewen.spp.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.jiewen.base.core.AbstractService;
import com.jiewen.spp.dao.MerchantMapper;
import com.jiewen.spp.model.Merchant;
import com.jiewen.spp.service.MerchantService;

@Service
public class MerchantServiceImpl extends AbstractService<Merchant> implements MerchantService {
	
	@Autowired
	private MerchantMapper merchantMapper;

	@Override
	public Merchant getByMerId(String merId) {
		Merchant merchant = new Merchant();
		merchant.setMerId(merId);
		return merchantMapper.getByMerId(merchant);
	}

}
