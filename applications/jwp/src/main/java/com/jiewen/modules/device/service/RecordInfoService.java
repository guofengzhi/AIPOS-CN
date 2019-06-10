package com.jiewen.modules.device.service;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Random;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jiewen.commons.util.DateTimeUtil;
import com.jiewen.commons.util.StringUtil;
import com.jiewen.jwp.base.service.CrudService;
import com.jiewen.modules.device.dao.RecordInfoDao;
import com.jiewen.modules.device.entity.Device;
import com.jiewen.modules.device.entity.RecordInfo;

@Service
public class RecordInfoService extends CrudService<RecordInfoDao, RecordInfo> {

    @Autowired
    private RecordInfoDao recordInfoDao;

    public String getDeviceAppTreeString(Device device) {
        List<JSONObject> lstTree = new ArrayList<>();
        // 设置ztree属性
        JSONObject deviceInfo = new JSONObject();
        deviceInfo.put("id", device.getDeviceSn());
        deviceInfo.put("name", device.getDeviceSn());
        deviceInfo.put("target", "0");
        deviceInfo.put("open", "true");
        deviceInfo.put("nocheck", "true");
        deviceInfo.put("isParent", "true");
        lstTree.add(deviceInfo);
        getAppTreeString(device, lstTree);
        return JSONArray.toJSONString(lstTree);
    }

    public void getAppTreeString(Device device, List<JSONObject> lstTree) {
        JSONArray appInfoArray = null;
        if (device.getAppInfo() != null) {
            appInfoArray = JSONArray.parseArray(device.getAppInfo().toString());
            Iterator<Object> it = appInfoArray.iterator();
            int i = 0;
            while (it.hasNext()) {
                i++;
                JSONObject object = (JSONObject) it.next();
                // 组叶子节点属性
                JSONObject ob = new JSONObject();
                ob.put("id", i);
                ob.put("pId", device.getDeviceSn());
                ob.put("name", object.getString("appPackage"));
                ob.put("target", "1");
                ob.put("isParent", "true");
                lstTree.add(ob);
            }
        }
    }

    /**
     * 记录操作流水
     * 
     * @return
     */
    @Transactional(readOnly = false)
    public RecordInfo recOperationRecord(String id, String packageName) {
        RecordInfo record = new RecordInfo();
        record.setId(getRecordId());
        record.setParentId(id);
        record.setRecordDateTime(DateTimeUtil.getSystemDateTime("yyyyMMddHHmmss"));
        record.setStatus("1");
        if (StringUtils.isNotEmpty(id) && !StringUtils.endsWithIgnoreCase(id, "1")) {
            RecordInfo frecord = new RecordInfo();
            frecord.setId(id);
            frecord = recordInfoDao.findById(frecord);
            if (frecord != null) {
                record.setPackageName(frecord.getPackageName());
                record.setPackagePath(packageName);
            }
        } else {
            record.setPackageName(packageName);
            record.setPackagePath("");
        }
        recordInfoDao.insert(record);

        return record;
    }

    /**
     * 生成流水ID
     * 
     * @return
     */
    public String getRecordId() {
        String dateTime = DateTimeUtil.getSystemDateTime("yyyyMMddHHmmssSSS");
        Random random = new Random();
        String randomNum = StringUtil.leftPad0ToBytes(String.valueOf(random.nextInt(1000)), 3);
        return dateTime + randomNum;
    }

    public RecordInfo findById(String recordId) {
        RecordInfo recordInfo = new RecordInfo();
        recordInfo.setId(recordId);
        return recordInfoDao.findById(recordInfo);
    }
}
