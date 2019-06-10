package com.jiewen.base.excetion;

import com.jiewen.commons.ServiceException;
import com.jiewen.utils.Messages;

public class OTAExcetion extends ServiceException {

    /**
     * 
     */
    private static final long serialVersionUID = -609910982386177105L;

    private static String getMsg(String code) {
        return Messages.get(code);
    }

    public OTAExcetion(String code) {
        this(code, getMsg(code));
    }

    public OTAExcetion(String code, String message) {
        super(code, (message == null ? getMsg(code) : message));
    }

    public OTAExcetion(String code, Throwable cause) {
        this(code, getMsg(code), cause);
    }

    public OTAExcetion(String code, String message, Throwable cause) {
        super(code, getMsg(code), cause);
    }

}
