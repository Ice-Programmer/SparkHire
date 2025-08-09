package com.ice.sparkhire.security;


import com.ice.sparkhire.auth.vo.UserBasicInfo;

import java.util.HashMap;
import java.util.Map;

/**
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/3/10 15:15
 */
public class SecurityContext {

    private static final String CURRENT_LOGIN_USER = "LOGIN_USER";

    private static final ThreadLocal<Map<String, Object>> requestContext = ThreadLocal.withInitial(HashMap::new);

    /**
     * 获取当前登录用户信息
     *
     * @return 当前登录用户信息
     */
    public static UserBasicInfo getCurrentUser() {
        return (UserBasicInfo) requestContext.get().get(CURRENT_LOGIN_USER);
    }

    /**
     * 设置当前登录用户信息
     *
     * @param user 当前登录用户
     */
    public static void setCurrentUser(UserBasicInfo user) {
        requestContext.get().put(CURRENT_LOGIN_USER, user);
    }

    /**
     * 移除当前登录用户
     */
    public static void removeCurrentUser() {
        requestContext.get().remove(CURRENT_LOGIN_USER);
    }

    /**
     * 清楚所有字段
     */
    public static void clearAll() {
        requestContext.get().clear();
    }

}
