package com.jiewen.spp.service;

import java.util.List;

import com.jiewen.spp.model.Advertisement;
import com.jiewen.spp.model.DeviceInfo;
import com.jiewen.spp.wrapper.GetAdvertisementWrapper;

public interface GetAdvertisementService {

	public List<Advertisement> getAdvertisement(GetAdvertisementWrapper requestWrapper, DeviceInfo deviceInfo);

}
