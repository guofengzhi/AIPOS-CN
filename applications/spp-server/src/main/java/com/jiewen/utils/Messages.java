package com.jiewen.utils;

import java.util.ResourceBundle;

import com.jiewen.commons.StringManager;

public class Messages {

    private static final Object syncObj = new Object();

    private static String resource = "message";

    private static StringManager sm;

    private static void load() {
        if (sm != null) {
            return;
        }
        synchronized (syncObj) {
            ResourceBundle bundle = ResourceBundle.getBundle(resource);
            sm = StringManager.getManager(bundle);
        }
    }

    public static String get(String key, Object... args) {
        try {
            return sm.getString(key, args);
        } catch (NullPointerException e) {
            load();
            return sm.getString(key, args);
        }
    }
    
    private Messages(){}

}