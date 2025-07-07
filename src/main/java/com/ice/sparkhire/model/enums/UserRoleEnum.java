package com.ice.sparkhire.model.enums;

import com.ice.sparkhire.common.BaseEnum;
import lombok.Getter;

/**
 * 用户角色枚举
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/6/9 14:15
 */
@Getter
public enum UserRoleEnum implements BaseEnum<String> {

    ADMIN("管理员", "admin"),
    SUPER_ADMIN("超级管理员", "super-admin"),
    EMPLOYEE("求职者", "employee"),
    GUEST("访客", "visitor"),
    EMPLOYER("招聘者", "employer"),
    BAN("禁用", "ban");


    private final String text;

    private final String value;

    UserRoleEnum(String text, String value) {
        this.text = text;
        this.value = value;
    }
}
