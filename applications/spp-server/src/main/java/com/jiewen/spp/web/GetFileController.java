package com.jiewen.spp.web;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.jiewen.base.core.AbstractController;
import com.jiewen.commons.toolkit.annotation.JsonApiMethod;
import com.jiewen.spp.model.TmsFile;
import com.jiewen.spp.service.impl.TmsFileServiceImpl;
import com.jiewen.spp.wrapper.GetFileWrapper;
import com.jiewen.utils.RspCode;
import com.jiewen.utils.RspJsonNode;

/**
 * 文件下载controller类
 * 
 * @author Pang.M
 *
 */
@RestController
public class GetFileController extends AbstractController {

	@Autowired
	private TmsFileServiceImpl tmsFileService;

	@JsonApiMethod
	@RequestMapping(value = "/tms/getFile")
	public @ResponseBody String getFile(@RequestBody String params) {

		GetFileWrapper requestWrapper = JSON.parseObject(params, GetFileWrapper.class);
		if (!validParams(requestWrapper)) {
			return setRspMessage(RspCode.PARAM_ERROR, "参数不能为空", requestWrapper.getSn());
		}
		TmsFile tmsFile = tmsFileService.getFileInfo(requestWrapper);
		JSONObject respJson = setRspJsonCommonObject(requestWrapper);
		if (tmsFile != null) {
			respJson.put(RspJsonNode.MERNO, requestWrapper.getMerNo());
			respJson.put(RspJsonNode.TERMNO, requestWrapper.getTermNo());
			List<JSONObject> upgradeInfo = new ArrayList<>();
			JSONObject fileJson = new JSONObject();
			fileJson.put(RspJsonNode.FILE_NAME, tmsFile.getFileName());
			fileJson.put(RspJsonNode.FILE_TYPE, tmsFile.getFileType());
			fileJson.put(RspJsonNode.FILE_SIZE, tmsFile.getFileSize());
			fileJson.put(RspJsonNode.FILE_VERSION, tmsFile.getFileVersion());
			fileJson.put(RspJsonNode.START_POSI, requestWrapper.getStartPosi());
			fileJson.put(RspJsonNode.FILE_BODY, tmsFile.getRemarks());
			upgradeInfo.add(fileJson);
			respJson.put(RspJsonNode.UPGRADE_INFO, upgradeInfo);
		}
		return respJson.toJSONString();
	}

	/**
	 * 验证参数是否为空
	 * 
	 * @param params
	 * @return
	 */
	private boolean validParams(GetFileWrapper params) {
		if (!this.verifyString(params.getSn(), params.getVersion(), params.getManufacturer(),
				params.getDeviceType(), params.getFileName(), params.getFileType(),
				params.getFileVersion(), params.getStartPosi())) {
			logger.debug("参数不能为空");
			return false;
		}
		return true;
	}
}
