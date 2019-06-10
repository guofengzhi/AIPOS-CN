package com.jiewen.modules.app.dao;

import java.util.List;

import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.modules.app.entity.ApprovalRecord;

public interface ApprovalRecordDao extends CrudDao<ApprovalRecord> {

	public List<ApprovalRecord> getRecordListByAppId(ApprovalRecord approvalRecord);
}
