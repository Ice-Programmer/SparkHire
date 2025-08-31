package com.ice.sparkhire.cache.constant;


/**
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/8/9 19:26
 */
public interface UserConstant {
    /**
     * auth 相关 key
     */
    String USER_PREFIX = "user:";

    /**
     * 用户信息相关 相关 key
     */
    String USER_INFO_PREFIX = USER_PREFIX + "info:";

    /**
     * 用户权限 相关 key
     */
    String USER_PERMISSION_PREFIX = USER_PREFIX + "permission:";
}
