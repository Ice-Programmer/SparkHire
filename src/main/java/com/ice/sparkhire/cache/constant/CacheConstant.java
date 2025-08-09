package com.ice.sparkhire.cache.constant;

/**
 * 缓存相关常量
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/7/4 15:37
 */
public interface CacheConstant extends AuthConstant, BizConstant, UserConstant {

    /**
     * key内部的连接字符
     */
    String UNION = ":";

    /**
     * 限流
     */
    String LIMIT = "limit:";

    /**
     * 空值
     */
    String STRING_EMPTY_VALUE = "EMPTY";

    /**
     * 真值
     */
    String TRUE_VALUE = "TRUE";

    /**
     * set 空值（防止缓存穿透）
     */
    Long SET_EMPTY_VALUE = 0L;

    /**
     * 一个月过期时间
     */
    long MONTH_EXPIRE_TIME = 3600 * 24 * 30;

    /**
     * 一周过期时间
     */
    long WEEK_EXPIRE_TIME = 3600 * 24 * 7;

    /**
     * 一天过期时间
     */
    long DAY_EXPIRE_TIME = 3600 * 24;

    /**
     * 一小时过期时间
     */
    long HOUR_EXPIRE_TIME = 3600;

    /**
     * 十分钟过期时间
     */
    long TEN_MINUTE_EXPIRE_TIME = 60 * 10;

    /**
     * 一分钟国旗时间
     */
    long MINUTE_EXPIRE_TIME = 60;
}
