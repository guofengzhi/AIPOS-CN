package com.jiewen.modules.workflow.utils;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import com.jiewen.jwp.common.SpringUtil;
import com.jiewen.modules.workflow.dao.TblActModuleDao;
import com.jiewen.modules.workflow.entity.TblActModule;

/**
 * 工作流工具类
 * 
 * @author Pang.M
 *
 */
@Transactional
public class WorkflowUtils {

	private static TblActModuleDao tblActModuleDao = SpringUtil.getBean(TblActModuleDao.class);

	public static List<TblActModule> getModuleList() {
		return tblActModuleDao.getAll();
	}
}
