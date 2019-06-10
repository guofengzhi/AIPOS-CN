package com.jiewen.spp.modules.app.dao;

import java.util.List;

import com.jiewen.base.core.dao.CrudDao;
import com.jiewen.spp.modules.app.entity.ApprovalRecord;

public interface ApprovalRecordDao extends CrudDao<ApprovalRecord> {

	public List<ApprovalRecord> getRecordListByAppId(ApprovalRecord approvalRecord);
}
