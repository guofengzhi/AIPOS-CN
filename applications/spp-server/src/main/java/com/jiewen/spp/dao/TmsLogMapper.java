package com.jiewen.spp.dao;

import java.util.List;

import com.jiewen.base.core.Mapper;
import com.jiewen.spp.model.TmsFile;
import com.jiewen.spp.model.TmsLog;
import com.jiewen.spp.model.TmsStrategy;

public interface TmsLogMapper extends Mapper<TmsLog>  {

	TmsLog getLogInfoByFile(TmsFile file);

	/**
	 * 从日志表中根据策略查询更新文件列表
	 * @param tmsStrategy
	 * @return
	 */
	List<TmsFile> getFilesByStrategy(TmsStrategy tmsStrategy);

}
