package com.jiewen.modules.rpc.api;

import java.util.List;

import com.googlecode.jsonrpc4j.JsonRpcService;
import com.jiewen.modules.baseinfo.entity.ClientEntity;
import com.jiewen.modules.device.entity.Device;

@JsonRpcService("/api/synchronize")
public interface SynchronizeServer {

    int synDevice(List<Device> params);

    int synClientInfo(List<ClientEntity> params);
}