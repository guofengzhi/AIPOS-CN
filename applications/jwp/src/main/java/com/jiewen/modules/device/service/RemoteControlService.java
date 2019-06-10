package com.jiewen.modules.device.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.jiewen.constant.ControlCommand;
import com.jiewen.jwp.base.service.CrudService;
import com.jiewen.jwp.base.utils.RemotePushUtils;
import com.jiewen.modules.device.dao.DeviceDao;
import com.jiewen.modules.device.entity.Device;
import com.jiewen.modules.device.entity.Message;
import com.jiewen.modules.rom.dao.PushRecDao;
import com.jiewen.modules.rom.entity.PushRec;

@Service
public class RemoteControlService extends CrudService<PushRecDao, PushRec> {

    @Autowired
    private DeviceDao deviceDao;

    public void executeComand(String ids, Message message, String isAll, String commandTye) {

        List<Device> devices;
        if ("0".equals(isAll)) {
            // 所有页
            devices = deviceDao.findList(new Device());
        } else {
            // 选择的项
            List<Integer> idList = new ArrayList<Integer>();
            String[] idArray = ids.split(",");
            for (int i = 0; i < idArray.length; i++) {
                idList.add(new Integer(idArray[i]));
            }
            devices = deviceDao.findDeviceListByIds(idList);
        }

        switch (commandTye) {
        case ControlCommand.SYSTEM_UPGRADE: {

            RemotePushUtils.batchPush(devices, message.getAction(), message.getMessage());
            break;
        }
        case ControlCommand.RESET_FACTORY_SETTINGS: {

            RemotePushUtils.batchPush(devices, message.getAction(), message.getMessage());
            break;
        }

        default:
            break;
        }
    }

}
