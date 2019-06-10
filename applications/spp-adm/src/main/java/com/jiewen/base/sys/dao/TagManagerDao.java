
package com.jiewen.base.sys.dao;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import com.jiewen.base.core.dao.CrudDao;
import com.jiewen.base.sys.entity.TagManager;
import com.jiewen.spp.modules.device.entity.Device;

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
