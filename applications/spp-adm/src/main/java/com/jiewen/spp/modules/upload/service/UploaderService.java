
package com.jiewen.spp.modules.upload.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.jiewen.base.core.service.CrudService;
import com.jiewen.spp.modules.upload.dao.SysFileDao;
import com.jiewen.spp.modules.upload.entity.SysFile;

@Service
public class UploaderService extends CrudService<SysFileDao, SysFile> {

    public List<SysFile> findByArray(String[] fileIds) {
        return dao.findByArray(fileIds);
    }

}
