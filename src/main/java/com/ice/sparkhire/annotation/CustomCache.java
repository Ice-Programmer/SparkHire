package com.ice.sparkhire.annotation;


import com.ice.sparkhire.model.enums.CacheMode;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.util.concurrent.TimeUnit;

/**
 * 自定义缓存注解
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/6/7 11:49
 */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface CustomCache {

    /**
     * 缓存键值
     */
    String key();

    /**
     * 缓存时间
     */
    long duration();

    /**
     * 缓存时间单位
     */
    TimeUnit timeUnit() default TimeUnit.SECONDS;

    /**
     * 缓存类型
     */
    CacheMode cacheMode() default CacheMode.REDIS;
}
