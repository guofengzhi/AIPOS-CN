package com.jiewen.utils;

import java.io.UnsupportedEncodingException;

import org.apache.commons.lang3.StringUtils;

import com.jiewen.commons.Encodings;

public class StringUtil extends com.jiewen.commons.util.StringUtil {

    public static String encrypt(String strOld, String timestamp, String strKey) {
        byte[] data = null;
        byte[] tempData = null;
        byte[] keyData = null;
        try {
            data = addRightSpace(strOld, 50).getBytes(Encodings.UTF8);
            tempData = addRightSpace(timestamp, 50).getBytes(Encodings.UTF8);
            keyData = addRightSpace(strKey, 50).getBytes(Encodings.UTF8);

        } catch (UnsupportedEncodingException e) {
            e.getMessage();
        }
        int keyIndex = 0;
        for (int x = 0; x < data.length; x++) {
            data[x] = (byte) (data[x] ^ tempData[x]);
        }
        for (; keyIndex < keyData.length; keyIndex++) {
            data[keyIndex] = (byte) (data[keyIndex] ^ keyData[keyIndex]);
        }
        return hexDump(data);
    }

    public static int compareVersion(String oldVersion, String newVersion) {
        oldVersion = StringUtils.removeAll(oldVersion, "[A-Za-z]");
        newVersion = StringUtils.removeAll(newVersion, "[A-Za-z]");
        if (StringUtils.isBlank(newVersion)) {
            return 0;
        }
        if (StringUtils.isBlank(oldVersion)) {
            return 0;
        }
        if (oldVersion.equals(newVersion)) {
            return 0;
        }

        String[] oldArray = oldVersion.split("\\.");
        String[] newArray = newVersion.split("\\.");

        int index = 0;
        int minLen = Math.min(oldArray.length, newArray.length);
        int diff = 0;

        while (index < minLen && (diff = Integer.parseInt(oldArray[index])
                - Integer.parseInt(newArray[index])) == 0) {
            index++;
        }

        if (diff == 0) {
            for (int i = index; i < oldArray.length; i++) {
                if (Integer.parseInt(oldArray[i]) > 0) {
                    return 1;
                }
            }

            for (int i = index; i < newArray.length; i++) {
                if (Integer.parseInt(newArray[i]) > 0) {
                    return -1;
                }
            }

            return 0;
        } else {
            return diff > 0 ? 1 : -1;
        }
    }

    /**
     * 格式化版本的格式
     * 
     * @param osVersion
     * @return
     */
    public static String formatVersion(String version) {
        if (StringUtils.isBlank(version)) {
            return "000000000";
        }
        version = StringUtils.removeAll(version, "[A-Za-z]");
        StringBuilder sb = new StringBuilder();
        String[] fields = version.split("\\.");
        for (String field : fields) {
            sb.append(StringUtil.addLeftZero(field, 6));
        }
        return sb.toString();
    }

}
