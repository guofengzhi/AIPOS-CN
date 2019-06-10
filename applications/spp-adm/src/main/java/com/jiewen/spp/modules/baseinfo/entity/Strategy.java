
package com.jiewen.spp.modules.baseinfo.entity;

import java.util.Date;

import com.jiewen.base.core.entity.DataEntity;

public class Strategy extends DataEntity<Strategy> {

	private static final long serialVersionUID = 1L;

	private String strategyName;

	private String upgradeType;

	protected Date beginDate;

	protected Date endDate;

	private String strategyDesc;

	private String organId;

	public String getOrganId() {
		return organId;
	}

	public void setOrganId(String organId) {
		this.organId = organId;
	}

	public String getStrategyName() {
		return strategyName;
	}

	public void setStrategyName(String strategyName) {
		this.strategyName = strategyName;
	}

	public String getUpgradeType() {
		return upgradeType;
	}

	public void setUpgradeType(String upgradeType) {
		this.upgradeType = upgradeType;
	}

	public Date getBeginDate() {
		return beginDate;
	}

	public void setBeginDate(Date beginDate) {
		this.beginDate = beginDate;
	}

	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

	public String getStrategyDesc() {
		return strategyDesc;
	}

	public void setStrategyDesc(String strategyDesc) {
		this.strategyDesc = strategyDesc;
	}

	@Override
	public String toString() {
		return "Strategy [strategyName=" + strategyName + ", upgradeType=" + upgradeType + ", beginDate=" + beginDate
				+ ", endDate=" + endDate + ", strategyDesc=" + strategyDesc + "]";
	}
}
