package com.ice.sparkhire.aop;

import com.google.gson.Gson;
import com.ice.sparkhire.annotation.CustomCache;
import com.ice.sparkhire.cache.constant.CacheConstant;
import com.ice.sparkhire.manager.RedisManager;
import com.ice.sparkhire.model.enums.CacheMode;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;

/**
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/6/7 11:52
 */
@Aspect
@Component
@Slf4j
public class CustomCacheAop {

    private final static Gson GSON = new Gson();

    @Resource
    private RedisManager redisManager;

    @Around("@annotation(customCache)")
    public Object aroundCache(ProceedingJoinPoint joinPoint, CustomCache customCache) throws Throwable {
        String cacheKey = generationKey(customCache.key(), joinPoint.getArgs());
        CacheMode cacheMode = customCache.cacheMode();
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        Class<?> returnType = signature.getReturnType();

        // 1. 判断当前是否有缓存
        switch (cacheMode) {
            case LOCAL -> {
            }
            case REDIS -> {
                // 2.1 有缓存值直接返回
                log.info("查询到缓存 「{}」, 直接返回，模式：「{}」", cacheKey, cacheMode);
                String schoolListStr = redisManager.get(cacheKey);
                if (StringUtils.isNotBlank(schoolListStr)) {
                    return GSON.fromJson(schoolListStr, returnType);
                }
            }
        }

        // 2.2 没有缓存，执行方法
        Object result = joinPoint.proceed();
        String cacheValue = GSON.toJson(result);
        // 3. 放入缓存中
        switch (cacheMode) {
            case LOCAL -> {
            }
            case REDIS -> redisManager.set(cacheKey, cacheValue, customCache.duration(), customCache.timeUnit());
        }
        log.info("保存缓存 「{}」，模式：「{}」", cacheKey, cacheMode);

        return result;
    }

    /**
     * 生成缓存 key
     *
     * @param key  key 前缀
     * @param args 参数
     * @return 缓存 key 值
     */
    private String generationKey(String key, Object[] args) {
        StringBuilder builder = new StringBuilder();
        builder.append(key);
        if (args != null) {
            for (Object arg : args) {
                builder.append(CacheConstant.UNION).append(arg);
            }
        }
        return builder.toString();
    }
}