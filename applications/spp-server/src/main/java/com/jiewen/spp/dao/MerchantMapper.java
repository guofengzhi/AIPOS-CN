package com.jiewen.spp.dao;


import com.jiewen.base.core.Mapper;
import com.jiewen.spp.model.Merchant;

public interface MerchantMapper extends Mapper<Merchant> {
	
	public Merchant getByMerId(Merchant merchant);

}
