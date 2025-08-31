package com.ice.sparkhire.annotation;

import com.ice.sparkhire.model.enums.UserRoleEnum;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 必须角色校验注解
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/7/7 10:36
 */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface MustRole {
    /**
     * 所需角色
     */
    UserRoleEnum[] value() default {};

    /**
     * 所需权限
     */
    String[] permissions() default {};

    /**
     * 是否允许超级管理员跳过权限检查
     */
    boolean allowSuperAdmin() default true;

    /**
     * 逻辑关系
     */
    Logical logical() default Logical.AND;

    enum Logical {
        AND,
        OR,
        NOT
    }
}
