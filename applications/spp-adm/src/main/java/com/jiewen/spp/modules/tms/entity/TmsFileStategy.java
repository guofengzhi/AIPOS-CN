package com.jiewen.spp.modules.tms.entity;

import com.jiewen.base.core.entity.DataEntity;

/**
 * 关联表
 * 
 * @author Pang.M
 */
public class TmsFileStategy extends DataEntity<TmsFileStategy> {

	private static final long serialVersionUID = -9024717637870914377L;

	private String strategyId; // 策略ID

	private String fileId;

	public String getStrategyId() {
		return strategyId;
	}

	public void setStrategyId(String strategyId) {
		this.strategyId = strategyId;
	}

	public String getFileId() {
		return fileId;
	}

	public void setFileId(String fileId) {
		this.fileId = fileId;
	}

}
