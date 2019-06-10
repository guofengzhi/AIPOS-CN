package com.jiewen.modules.advertisement.dao;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.modules.advertisement.entity.Advertisement;

/**
 * 广告管理DAO接口
 */
@Transactional
public interface AdvertisementDao extends CrudDao<Advertisement> {

	int deleteAdvertisementByPrimaryKey(String adId);

	int insertAdvertisement(Advertisement record);

	int insertAdvertisementSelective(Advertisement record);

	Advertisement selectAdvertisementByPrimaryKey(String adId);

	Advertisement selectByAdId(Advertisement record);

	int updateAdvertisementByPrimaryKeySelective(Advertisement record);

	int updateAdvertisementAdStatus(Advertisement record);

	int updateAdvertisementApprovalStatus(Advertisement record);

	int updateAdvertisementByPrimaryKeyWithBLOBs(Advertisement record);

	int updateAdvertisementByPrimaryKey(Advertisement record);

	Advertisement getAdvertisementByAdName(Advertisement record);

	List<Advertisement> findListAdvertisement(Advertisement record);

	List<Advertisement> findListAdvertisementCount(Advertisement record);

	Integer getAdCount(Advertisement record);
}