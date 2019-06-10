package com.jiewen.spp.modules.tms.service;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.jiewen.base.core.service.CrudService;
import com.jiewen.spp.modules.tms.dao.UpdateItemsDao;
import com.jiewen.spp.modules.tms.entity.UpdateItems;
import com.jiewen.utils.StringUtil;

/**
 * 更新物业务处理
 * 
 * @author guofengzhi
 */
@Service
public class UpdateItemsService extends CrudService<UpdateItemsDao, UpdateItems> {

	@Autowired
	private UpdateItemsDao updateItemsDao;

	@Transactional(readOnly = false)
	public String saveItems(UpdateItems updateItems) {
		if (updateItems != null) {
			if (StringUtil.isEmpty(updateItems.getId())) {
				updateItems.setUploadTime(new Date());
				updateItems.setDelFlag("0");
				updateItems.setOrganId(updateItems.getCurrentUser().getOfficeId());
				try {
					updateItemsDao.insert(updateItems);
					return "common.saveSuccess";
				} catch (Exception e) {
					logger.error(e.toString());
					return "common.saveFailed";
				}
			} else {
				try {
					updateItemsDao.update(updateItems);
					return "common.updateSuccess";
				} catch (Exception e) {
					logger.error(e.toString());
					return "common.updateFailed";
				}
			}
		}
		return null;
	}

	@Transactional
	public PageInfo<UpdateItems> findPage(UpdateItems updateItems) {
		updateItems.setOrganId(updateItems.getCurrentUser().getOfficeId());
		PageHelper.startPage(updateItems);
		return new PageInfo<>(updateItemsDao.findList(updateItems));
	}

	/**
	 * 删除
	 * 
	 * @param updateItems
	 */
	@Transactional(readOnly = false)
	public void deleteById(UpdateItems updateItems) {
		updateItemsDao.delete(updateItems);
	}

	/**
	 * 根据厂商、类型、版本、名称查询唯一更新物，如果四者其一为空则返回空
	 * 
	 * @param updateItems
	 * @return
	 */
	@Transactional
	public UpdateItems findByCondition(UpdateItems updateItems) {
		String manufactureNo = updateItems.getManufactureNo();
		String fileType = updateItems.getFileType();
		String fileVersion = updateItems.getFileVersion();
		String fileName = updateItems.getFileName();
		if (StringUtil.isEmpty(manufactureNo) || StringUtil.isEmpty(fileType)
				|| StringUtil.isEmpty(fileVersion) || StringUtil.isEmpty(fileName)) {
			return null;
		}
		return updateItemsDao.findByCondition(updateItems);
	}

	/**
	 * 查询没有被关联的更新物列表
	 * 
	 * @param updateItems
	 * @return
	 */
	@Transactional
	public PageInfo<UpdateItems> findNotConfigList(UpdateItems updateItems) {
		updateItems.setOrganId(updateItems.getCurrentUser().getOfficeId());
		PageHelper.startPage(updateItems);
		return new PageInfo<>(updateItemsDao.findNotConfigList(updateItems));
	}

}
