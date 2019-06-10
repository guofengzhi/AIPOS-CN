
package com.jiewen.spp.rpc.api;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.googlecode.jsonrpc4j.spring.AutoJsonRpcServiceImpl;
import com.jiewen.commons.toolkit.annotation.JsonApiMethod;
import com.jiewen.spp.modules.baseinfo.entity.ClientEntity;
import com.jiewen.spp.modules.device.entity.Device;

@Service
@AutoJsonRpcServiceImpl
public class SynchronizeServerImpl implements SynchronizeServer {

    protected static final Logger logger = LoggerFactory.getLogger(SynchronizeServerImpl.class);

    @Override
    @JsonApiMethod
    public int synDevice(List<Device> params) {
        return 0;
    }

    @Override
    // @JsonApiMethod
    public int synClientInfo(List<ClientEntity> params) {
        for (ClientEntity client : params) {
            logger.info(client.getCustomerName());
        }
        return 0;
    }
}