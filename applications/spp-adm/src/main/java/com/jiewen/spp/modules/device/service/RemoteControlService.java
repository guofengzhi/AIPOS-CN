
package com.jiewen.spp.modules.device.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.jiewen.base.core.service.CrudService;
import com.jiewen.constant.ControlCommand;
import com.jiewen.spp.modules.device.dao.DeviceDao;
import com.jiewen.spp.modules.device.entity.Device;
import com.jiewen.spp.modules.device.entity.Message;
import com.jiewen.spp.modules.rom.dao.PushRecDao;
import com.jiewen.spp.modules.rom.entity.PushRec;
import com.jiewen.spp.utils.RemotePushUtils;

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
