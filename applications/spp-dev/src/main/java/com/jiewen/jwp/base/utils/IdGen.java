package com.jiewen.jwp.base.utils;

import java.io.Serializable;
import java.security.SecureRandom;
import java.util.UUID;

import org.apache.shiro.session.Session;
import org.apache.shiro.session.mgt.eis.SessionIdGenerator;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;

import com.jiewen.jwp.common.Encodes;

/**
 * 封装各种生成唯一性ID算法的工具类.
 */
@Service
@Lazy(false)
public class IdGen implements SessionIdGenerator {

    private static SecureRandom random = new SecureRandom();

    /**
     * 封装JDK自带的UUID, 通过Random数字生成, 中间无-分割.
     */
    public static String uuid() {
        return UUID.randomUUID().toString().replaceAll("-", "");
    }

    /**
     * 封装JDK自带的UUID, 通过Random数字生成, 使用hashCode数据.
     */
    public static String uuidNumber() {
        return String.valueOf(UUID.randomUUID().toString().hashCode());
    }

    /**
     * 使用SecureRandom随机生成Long.
     */
    public static long randomLong() {
        return random.nextLong();
    }

    /**
     * 使用SecureRandom随机生成int.
     */
    public static int randomInt() {
        return random.nextInt();
    }

    /**
     * 基于Base62编码的SecureRandom随机生成bytes.
     */
    public static String randomBase62(int length) {
        byte[] randomBytes = new byte[length];
        random.nextBytes(randomBytes);
        return Encodes.encodeBase62(randomBytes);
    }

    @Override
    public Serializable generateId(Session session) {
        return IdGen.uuid();
    }

}
