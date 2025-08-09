package com.ice.sparkhire.utils;

import com.ice.sparkhire.cache.constant.CacheConstant;

/**
 * 缓存 key 生成工具类
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/8/9 20:46
 */
public class CacheKeyUtil {

    public static String getUserInfoKey(Long userId) {
        return CacheConstant.USER_INFO_PREFIX + userId;
    }
}
