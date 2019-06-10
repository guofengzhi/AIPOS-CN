package com.jiewen.base.core.web;

/**
 * 响应结果生成工具
 */
public class ResultGenerator {

    private static final String DEFAULT_SUCCESS_MESSAGE = "SUCCESS";

    private ResultGenerator() {
    }

    public static Result genSuccessResult() {
        return new Result().setCode(ResultCode.SUCCESS).setMessage(DEFAULT_SUCCESS_MESSAGE);
    }

    public static Result genSuccessResult(String message) {
        return new Result().setCode(ResultCode.SUCCESS).setMessage(message);
    }

    public static Result genSuccessResult(Object data) {
        return new Result().setCode(ResultCode.SUCCESS).setMessage(DEFAULT_SUCCESS_MESSAGE)
                .setData(data);
    }

    public static Result genFailResult(String message) {
        return new Result().setCode(ResultCode.FAIL).setMessage(message);
    }

    public static Result genFailResult(ResultCode resultCode, String message) {
        return new Result().setCode(resultCode).setMessage(message);
    }

    public static Result genFailResult(int code, String message) {
        return new Result().setCode(code).setMessage(message);
    }
}