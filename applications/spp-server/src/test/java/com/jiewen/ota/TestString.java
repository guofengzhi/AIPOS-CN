package com.jiewen.ota;

import java.io.UnsupportedEncodingException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.jiewen.commons.util.StringUtil;

public class TestString {
    private static final Logger logger = LoggerFactory.getLogger(TestString.class);

    public static void main(String[] args) {

        String s1 = "112233445566qqwweerr";
        String s2 = "0000014KDJAFKDJFKDJFKDKD09304932049203";

        logger.info(encrypt(s2, s1));

    }

    public static String encrypt(String strOld, String strKey) {
        byte[] data = null;
        byte[] keyData = null;
        try {
            data = strOld.getBytes("UTF-8");
            keyData = strKey.getBytes("UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.getMessage();
        }

        int keyIndex = 0;
        for (int x = 0; x < strOld.length(); x++) {
            data[x] = (byte) (data[x] ^ keyData[keyIndex]);
            if (++keyIndex == keyData.length) {
                keyIndex = 0;
            }
        }
        return StringUtil.hexDump(data);
    }

    public void test() {
        // do somthing
    }

}
