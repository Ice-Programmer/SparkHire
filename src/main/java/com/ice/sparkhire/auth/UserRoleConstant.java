package com.ice.sparkhire.auth;

import java.util.Objects;

/**
 * 用户角色常量
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/3/10 12:32
 */
public interface UserRoleConstant {

    /**
     * 求职者权限
     */
    String EMPLOYEE_ROLE = "employee";

    /**
     * 招聘者权限
     */
    String EMPLOYER_ROLE = "employer";

    /**
     * 管理员权限
     */
    String ADMIN_ROLE = "admin";


    /**
     * 超级管理员权限
     */
    String SUPER_ADMIN_ROLE = "super_admin";

    /**
     * 被禁用
     */
    String BAN = "ban";

    /**
     * 是否为普通用户（招聘者 & 求职者）
     */
    static boolean isCommonUser(String userRole) {
        return Objects.equals(userRole, UserRoleConstant.EMPLOYER_ROLE)
                || Objects.equals(userRole, UserRoleConstant.EMPLOYEE_ROLE);
    }

}
