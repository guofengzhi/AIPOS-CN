package com.jiewen.modules.upload.dao;

import java.util.List;

import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.modules.upload.entity.SysFile;

public interface SysFileDao extends CrudDao<SysFile> {
    public List<SysFile> findByArray(String[] fileIds);

}