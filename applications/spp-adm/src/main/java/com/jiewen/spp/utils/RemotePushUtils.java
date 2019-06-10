
package com.jiewen.spp.utils;

import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.jiewen.base.config.Global;
import com.jiewen.constant.ControlCommand;
import com.jiewen.jwp.common.utils.Collections3;
import com.jiewen.spp.modules.device.entity.Device;

import cn.jiguang.common.ClientConfig;
import cn.jiguang.common.resp.APIConnectionException;
import cn.jiguang.common.resp.APIRequestException;
import cn.jpush.api.JPushClient;
import cn.jpush.api.push.PushResult;
import cn.jpush.api.push.model.Message;
import cn.jpush.api.push.model.Options;
import cn.jpush.api.push.model.Platform;
import cn.jpush.api.push.model.PushPayload;
import cn.jpush.api.push.model.audience.Audience;

/**
 * java后台极光推送：使用Java SDK
 */
public class RemotePushUtils {

    private static final Logger logger = LoggerFactory.getLogger(RemotePushUtils.class);

    private RemotePushUtils() {
    }

    private static final String MASTERSECRET = Global.getConfig("jpush.masterSecret");

    private static final String APPKEY = Global.getConfig("jpush.appKey");

    private static final boolean DEVENV = Boolean.parseBoolean(Global.getConfig("jpush.env"));

    private static final Long TIMETOLIEVE = Long.parseLong(Global.getConfig("jpush.timetolive"));

    /**
     * 处理设备推送分批推送
     * 
     * @param devices
     * @param action
     * @param jPushDes
     */
    public static void batchPush(List<Device> devices, String action, String jPushDes) {
        if (devices != null && !devices.isEmpty()) {
            if (devices.size() <= 1000) {
                sendRemotePush(devices, action, jPushDes);
            } else {
                for (int i = 0; i < devices.size(); i = i + 1000) {
                    List<Device> subList;
                    int temp = 0;
                    if (i + 1000 < devices.size()) {
                        temp = i + 1000;
                    } else {
                        temp = devices.size();
                    }
                    subList = devices.subList(i, temp);
                    sendRemotePush(subList, action, jPushDes);
                }
            }
        }
    }

    /**
     * 发送极光推送消息
     * 
     * @param devices
     * @param jPushDes
     */
    public static void sendRemotePush(List<Device> devices, String action, String jPushDes) {
        @SuppressWarnings("unchecked")
        List<String> alias = Collections3.extractToList(devices, "deviceSn");
        try {
            remotePush(alias, action, jPushDes);
        } catch (Exception e) {
            // 极光推送失败
            logger.error(e.getMessage(), e);
        }
    }

    /**
     * 极光推送
     */
    public static void remotePush(List<String> alias, String action, String message) {
        PushResult result = push(alias, action, message);
        if (result != null && result.isResultOK()) {
            logger.info("针对别名{}的信息推送成功！", alias);
        }
    }

    /**
     * 生成极光推送对象PushPayload（采用java SDK）
     * 
     * @param alias
     * @param alert
     * @return PushPayload
     */
    public static PushPayload buildPushObjectAndroidAliasAlert(List<String> alias, String action,
            String mesaage) {

        return PushPayload.newBuilder().setPlatform(Platform.android())
                .setAudience(Audience.alias(alias))
                .setMessage(Message.newBuilder().setMsgContent(ControlCommand.MSGCONTENT)
                        .addExtra(ControlCommand.ACTION, action)
                        .addExtra(ControlCommand.MESSAGE, mesaage).build())
                .setOptions(Options.newBuilder()
                        // true-推送生产环境 false-推送开发环境（测试使用参数）
                        .setApnsProduction(DEVENV)
                        // 消息在JPush服务器的失效时间（测试使用参数）
                        .setTimeToLive(TIMETOLIEVE).build())
                .build();
    }

    /**
     * 极光推送方法(采用java SDK)
     * 
     * @param alias
     * @param alert
     * @return PushResult
     */
    public static PushResult push(List<String> alias, String action, String mesaage) {
        ClientConfig clientConfig = ClientConfig.getInstance();
        JPushClient jpushClient = new JPushClient(MASTERSECRET, APPKEY, null, clientConfig);
        PushPayload payload = buildPushObjectAndroidAliasAlert(alias, action, mesaage);
        try {
            if (logger.isInfoEnabled() && alias != null) {
                logger.info("对别名{}的用户推送信息", alias.toString());
            }
            return jpushClient.sendPush(payload);
        } catch (APIConnectionException e) {
            logger.error("Connection error. Should retry later. ", e);
            if (logger.isInfoEnabled() && alias != null) {
                logger.info("对别名{}的用户推送信息失败", alias.toString());
            }
            return null;
        } catch (APIRequestException e) {
            logger.error("Error response from JPush server. Should review and fix it. ", e);
            logger.info("HTTP Status: " + e.getStatus());
            logger.info("Error Code: " + e.getErrorCode());
            logger.info("Error Message: " + e.getErrorMessage());
            logger.info("Msg ID: " + e.getMsgId());
            if (logger.isInfoEnabled() && alias != null) {
                logger.info("对别名{}的用户推送信息失败", alias.toString());
            }
            return null;
        }
    }

    public static void main(String[] args) {
        List<String> ailas = new ArrayList<>();
        ailas.add("00021000064");
        remotePush(ailas, ControlCommand.SYSTEM_UPGRADE, "");
    }
}