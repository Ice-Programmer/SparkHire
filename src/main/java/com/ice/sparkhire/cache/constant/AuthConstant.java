package com.ice.sparkhire.cache.constant;

/**
 * 授权缓存相关常量
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/3/10 13:14
 */
public interface AuthConstant {

    /**
     * auth 相关key
     */
    String AUTH_PREFIX = "auth:";

    /**
     * token 授权相关key
     */
    String AUTH_TOKEN_PREFIX = AUTH_PREFIX + "token:";

    /**
     * 保存token 缓存使用key
     */
    String ACCESS = AUTH_TOKEN_PREFIX + "access:";

}
