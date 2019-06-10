package com.jiewen.base.core.web;

import com.alibaba.fastjson.JSON;

/**
 *
 */
public class Result {

    /**
     * 结果集
     */
    private Object data;

    /**
     * 返回信息
     */
    private String message;

    /**
     * 返回状态码
     */
    private int code;

    public Result setCode(ResultCode rc) {
        this.code = rc.code;
        return this;
    }

    public int getCode() {

        return code;
    }

    public Result setCode(int code) {
        this.code = code;
        return this;
    }

    public Object getData() {

        return data;
    }

    public Result setData(Object data) {

        this.data = data;
        return this;
    }

    public String getMessage() {

        return message;
    }

    public Result setMessage(String message) {

        this.message = message;

        return this;
    }

    @Override
    public String toString() {
        return JSON.toJSONString(this);
    }

}
