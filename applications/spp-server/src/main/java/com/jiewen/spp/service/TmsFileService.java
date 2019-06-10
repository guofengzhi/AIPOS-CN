package com.jiewen.spp.service;

import java.util.List;

import com.alibaba.fastjson.JSONObject;
import com.jiewen.base.core.Service;
import com.jiewen.spp.model.TmsFile;
import com.jiewen.spp.wrapper.GetFileWrapper;
import com.jiewen.spp.wrapper.TmsCheckVersionWrapper;

public interface TmsFileService extends Service<TmsFile> {

	public TmsFile getFileInfo(GetFileWrapper requestWrapper);

	public TmsFile findByCondition(GetFileWrapper requestWrapper);

	public List<JSONObject> getFileList(TmsCheckVersionWrapper requestWrapper);

}
