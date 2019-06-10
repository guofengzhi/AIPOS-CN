package com.jiewen.modules.dao;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.modules.device.entity.Device;
import com.jiewen.modules.entity.TagManager;

/**
 * 标签DAO接口
 */
@Transactional
public interface TagManagerDao extends CrudDao<TagManager> {
	
	
	public List<TagManager> selectTagManagerList(TagManager tagManager);
	
	public void updateTagManager(TagManager tagManager);

	public List<TagManager> getAllTag(TagManager tagManager);

	public TagManager getTagByMerId(String id);

	public TagManager getTagManagerByTagId(String id);
	
	public List<TagManager> getAllTagWithStores(String organId);
	
	public int insertTagManager(TagManager tagManager);
	
	public void deleteTagManager(String id);
	
	public List<Device> getTagManagerDevices(Device device);
	
	public void batchBundTagManagerDevice(List<Device> deviceList);
	
	public void batchUnBundTagManagerDevice(List<Device> deviceList);

	public TagManager getTagManagerByTag(TagManager tagManager);

	public List<TagManager> getTagManagerBundTermByTagId(String tagId);
	
}
