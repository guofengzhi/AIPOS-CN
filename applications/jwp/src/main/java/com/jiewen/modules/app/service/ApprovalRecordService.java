package com.jiewen.modules.app.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.jiewen.jwp.base.service.CrudService;
import com.jiewen.modules.app.dao.AppInfoDao;
import com.jiewen.modules.app.dao.ApprovalRecordDao;
import com.jiewen.modules.app.entity.AppInfo;
import com.jiewen.modules.app.entity.ApprovalRecord;
import com.jiewen.modules.sys.entity.User;

@Service
@Transactional(readOnly = true)
public class ApprovalRecordService extends CrudService<ApprovalRecordDao, ApprovalRecord> {

	@Autowired
	private ApprovalRecordDao approvalRecordDao;

	@Autowired
	private AppInfoDao appInfoDao;

	public PageInfo<ApprovalRecord> findApprovalDetailPage(ApprovalRecord approvalRecord) {
		PageHelper.startPage(approvalRecord);
		return new PageInfo<>(approvalRecordDao.getRecordListByAppId(approvalRecord));
	}

	@Transactional(readOnly = false)
	public void saveApprovalRecord(AppInfo appInfo, User user, String approveFlag, String appDataScope,
			String approveRemarks) {

		appInfo.setCurrentApproveFlag(approveFlag);
		appInfo.setCurrentApproveGrade(user.getOffice().getGrade());
		appInfo.preUpdate();
		appInfoDao.update(appInfo);

		ApprovalRecord approvalRecord = new ApprovalRecord();
		approvalRecord.setAppId(appInfo.getId());
		approvalRecord.setAppName(appInfo.getAppName());
		approvalRecord.setApproveFlag(approveFlag);
		approvalRecord.setAppDataScope(appDataScope);
		approvalRecord.setApproveRemarks(approveRemarks);
		approvalRecord.setOrganGrade(user.getOffice().getGrade());
		approvalRecord.setOrganId(user.getOfficeId());
		approvalRecord.preInsert();
		approvalRecordDao.insert(approvalRecord);
	}
}
