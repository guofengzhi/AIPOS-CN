
package com.jiewen.spp.modules.upload.dao;

import java.util.List;

import com.jiewen.base.core.dao.CrudDao;
import com.jiewen.spp.modules.upload.entity.SysFile;

public interface SysFileDao extends CrudDao<SysFile> {

    public List<SysFile> findByArray(String[] fileIds);

}