package com.jiewen.modules.upload.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.jiewen.jwp.base.service.CrudService;
import com.jiewen.modules.upload.dao.SysFileDao;
import com.jiewen.modules.upload.entity.SysFile;

@Service
public class UploaderService extends CrudService<SysFileDao, SysFile> {

    public List<SysFile> findByArray(String[] fileIds) {
        return dao.findByArray(fileIds);
    }

}
