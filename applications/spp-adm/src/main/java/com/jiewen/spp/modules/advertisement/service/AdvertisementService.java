package com.jiewen.spp.modules.advertisement.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.PageInfo;
import com.github.pagehelper.page.PageMethod;
import com.jiewen.base.core.service.CrudService;
import com.jiewen.spp.modules.advertisement.dao.AdvertisementDao;
import com.jiewen.spp.modules.advertisement.entity.Advertisement;

/**
 * 广告管理
 */
@Service
@Transactional
public class AdvertisementService extends CrudService<AdvertisementDao, Advertisement> {

	@Autowired
	private AdvertisementDao advertisementDao;

	public int deleteAdvertisementByPrimaryKey(String adId) {
		return advertisementDao.deleteAdvertisementByPrimaryKey(adId);
	}

	public int insertAdvertisement(Advertisement record) {
		return advertisementDao.insertAdvertisement(record);
	}

	public int insertAdvertisementSelective(Advertisement record) {
		return advertisementDao.insertAdvertisementSelective(record);
	}

	public Advertisement selectAdvertisementByPrimaryKey(String adId) {
		return advertisementDao.selectAdvertisementByPrimaryKey(adId);
	}

	public Advertisement selectByAdId(Advertisement record) {
		return advertisementDao.selectByAdId(record);
	}

	public Advertisement getAdvertisementByAdName(Advertisement record) {
		return advertisementDao.getAdvertisementByAdName(record);
	}

	public int updateAdvertisementByPrimaryKeySelective(Advertisement record) {
		return advertisementDao.updateAdvertisementByPrimaryKeySelective(record);
	}

	public int updateAdvertisementByPrimaryKeyWithBLOBs(Advertisement record) {
		return advertisementDao.updateAdvertisementByPrimaryKeyWithBLOBs(record);
	}

	public int updateAdvertisementByPrimaryKey(Advertisement record) {
		return advertisementDao.updateAdvertisementByPrimaryKey(record);
	}

	public int updateAdvertisementAdStatus(Advertisement record) {
		return advertisementDao.updateAdvertisementAdStatus(record);
	}

	public int updateAdvertisementApprovalStatus(Advertisement record) {
		return advertisementDao.updateAdvertisementApprovalStatus(record);
	}

	public List<Advertisement> findListAdvertisement(Advertisement record) {
		return advertisementDao.findListAdvertisement(record);
	}

	public List<Advertisement> findListAdvertisementCount(Advertisement record) {
		return advertisementDao.findListAdvertisementCount(record);
	}

	@Override
	public PageInfo<Advertisement> findPage(Advertisement record) {
		PageMethod.startPage(record);
		return new PageInfo<>(findList(record));

	}

	public PageInfo<Advertisement> findPageAdvertisement(Advertisement record) {
		PageMethod.startPage(record);
		return new PageInfo<>(findListAdvertisement(record));

	}

	@Transactional(readOnly = false)
	@Override
	public void save(Advertisement record) {
		super.save(record);
		// UserUtils.removeCache(UserUtils.CACHE_OFFICE_LIST);
	}

	@Override
	@Transactional(readOnly = false)
	public void delete(Advertisement record) {
		super.delete(record);
		// UserUtils.removeCache(UserUtils.CACHE_OFFICE_LIST);
	}

	@Transactional(readOnly = false)
	public Integer getAdCount(Advertisement record) {
		return advertisementDao.getAdCount(record);
	}

}
