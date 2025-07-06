package com.ice.sparkhire.constant;

import lombok.Getter;

/**
 * 错误信息返回枚举类
 */
@Getter
public enum ErrorCode {

    SUCCESS(200, "ok"),
    PARAMS_ERROR(40000, "请求参数错误"),
    NOT_LOGIN_ERROR(40100, "未登录"),
    NO_AUTH_ERROR(40101, "无权限"),
    NO_TOKEN_ERROR(40102, "登录凭证错误"),
    TOKEN_EXPIRE_ERROR(40103, "token已过期"),
    TOKEN_PARSE_ERROR(40104, "token 解析错误"),
    NOT_FOUND_ERROR(40400, "请求数据不存在"),
    FORBIDDEN_ERROR(40300, "禁止访问"),
    SYSTEM_ERROR(50000, "系统内部异常"),
    OPERATION_ERROR(50001, "操作失败");

    /**
     * 状态码
     */
    private final int code;

    /**
     * 信息
     */
    private final String message;

    ErrorCode(int code, String message) {
        this.code = code;
        this.message = message;
    }

}