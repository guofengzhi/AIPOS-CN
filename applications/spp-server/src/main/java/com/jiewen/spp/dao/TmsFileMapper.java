package com.jiewen.spp.dao;

import java.util.List;

/**
 * 更新物DAO
 * 
 * @author Pang.M
 * 
 */
import org.springframework.stereotype.Repository;

import com.jiewen.base.core.Mapper;
import com.jiewen.spp.model.TmsFile;
import com.jiewen.spp.wrapper.TmsCheckVersionWrapper;

@Repository
public interface TmsFileMapper extends Mapper<TmsFile> {

	TmsFile findByCondition(TmsFile tmsFile);

	// 根据文件参数或者更新物文件信息
	public TmsFile getDownLoadFileByFileParams(TmsFile file);

	List<TmsFile> getFileInfoByStrategy(TmsCheckVersionWrapper requestWrapper);

	List<TmsFile> getFileInfoByDetailStrategy(TmsCheckVersionWrapper requestWrapper);

	/**
	 * 根据厂商和SN获取所有更新物(不包括)
	 * @param requestWrapper
	 * @return
	 */
	List<TmsFile> getFilesByDevice(TmsCheckVersionWrapper requestWrapper);

}
