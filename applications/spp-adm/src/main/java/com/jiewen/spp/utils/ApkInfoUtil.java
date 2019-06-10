
package com.jiewen.spp.utils;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.Iterator;

import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.jiewen.apkutils.packinfo.bean.ApkInfo;
import com.jiewen.apkutils.packinfo.utils.AXMLPrinter;

public class ApkInfoUtil {

    private static final Logger logger = LoggerFactory.getLogger(ApkInfoUtil.class);

    public static void getApkInfo(String apkPath, ApkInfo info) {
        File apkFile = new File(apkPath);
        getApkInfo(apkFile, info);
    }

    public static void getApkInfo(File apkFile, ApkInfo info) {
        SAXReader builder = new SAXReader();
        Document document = null;
        try {
            InputStream stream = new ByteArrayInputStream(
                    AXMLPrinter.getManifestXMLFromAPK(apkFile).getBytes(StandardCharsets.UTF_8));
            document = builder.read(stream);
        } catch (Exception e) {
            logger.error("SaxReader error apk xml {}", e.getMessage());
        }
        if (document != null) {
            Element root = document.getRootElement();
            info.setVersionCode(root.attributeValue("versionCode"));
            info.setVersionName(root.attributeValue("versionName"));
            info.setPackageName(root.attributeValue("package"));

            Element book = root.element("uses-sdk");
            info.setMinSdkVersion(book.attributeValue("minSdkVersion"));
            info.setTargetSdkVersion(book.attributeValue("targetSdkVersion"));

            for (Iterator<?> iter = root.elements("uses-permission").iterator(); iter.hasNext();) {
                Element tempBook = (Element) iter.next();
                info.getPermissions().add(tempBook.attributeValue("name"));
            }
        }
    }

    private ApkInfoUtil() {
        throw new IllegalStateException("Utility class");
    }

}