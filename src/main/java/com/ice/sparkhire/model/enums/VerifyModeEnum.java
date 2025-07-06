package com.ice.sparkhire.model.enums;

import lombok.Getter;

/**
 * 空间类型枚举类
 */
@Getter
public enum VerifyModeEnum {

    LOGIN("登录");

    private final String value;

    VerifyModeEnum(String value) {
        this.value = value;
    }

}