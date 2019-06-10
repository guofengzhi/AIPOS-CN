package com.jiewen.spp.dao;

import java.util.List;

import com.jiewen.base.core.Mapper;
import com.jiewen.spp.model.Advertisement;

public interface AdvertisementMapper extends Mapper<Advertisement> {

	public List<Advertisement> getAdvertisementList(Advertisement advertisement);

	public int getAdvertisementCount(Advertisement advertisement);

}
