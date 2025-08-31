package com.ice.sparkhire.manager;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

/**
 * redis 缓存服务类
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/3/9 19:52
 */
@Slf4j
@Service
public class RedisManager {

    @Resource
    private StringRedisTemplate stringRedisTemplate;

    @Resource
    private RedisTemplate<String, Object> redisTemplate;

    private static final Gson GSON = new Gson();

    // ============================== 通用方法 ==============================

    /**
     * 设置缓存值
     *
     * @param key        缓存键
     * @param value      缓存值
     * @param expireTime 过期时间
     * @param timeUnit   时间单位
     */
    public void set(String key, String value, long expireTime, TimeUnit timeUnit) {
        validateKeyAndValue(key, value);
        try {
            stringRedisTemplate.opsForValue().set(key, value, expireTime, timeUnit);
            log.info("Redis set success - key: {}, value: {}, expire: {} {}", key, value, expireTime, timeUnit);
        } catch (Exception e) {
            log.error("Redis set error - key: {}", key, e);
            throw new RuntimeException("Redis set error", e);
        }
    }

    /**
     * 获取缓存值
     *
     * @param key 缓存键
     * @return 缓存值
     */
    public String get(String key) {
        validateKey(key);
        try {
            return stringRedisTemplate.opsForValue().get(key);
        } catch (Exception e) {
            log.error("Redis get error - key: {}", key, e);
            throw new RuntimeException("Redis get error", e);
        }
    }

    /**
     * 删除缓存键
     *
     * @param key 缓存键
     */
    public void delete(String key) {
        validateKey(key);
        try {
            stringRedisTemplate.delete(key);
            log.info("Redis delete success - key: {}", key);
        } catch (Exception e) {
            log.error("Redis delete error - key: {}", key, e);
            throw new RuntimeException("Redis delete error", e);
        }
    }

    /**
     * 判断缓存键是否存在
     *
     * @param key 缓存键
     * @return 是否存在
     */
    public boolean exists(String key) {
        validateKey(key);
        try {
            return Boolean.TRUE.equals(stringRedisTemplate.hasKey(key));
        } catch (Exception e) {
            log.error("Redis exists error - key: {}", key, e);
            throw new RuntimeException("Redis exists error", e);
        }
    }

    // ============================== 对象操作 ==============================

    /**
     * 设置对象缓存
     *
     * @param key        缓存键
     * @param value      缓存对象
     * @param expireTime 过期时间
     * @param timeUnit   时间单位
     */
    public <T> void setObject(String key, T value, long expireTime, TimeUnit timeUnit) {
        set(key, GSON.toJson(value), expireTime, timeUnit);
    }

    /**
     * 获取对象缓存
     *
     * @param key       缓存键
     * @param valueType 对象类型
     * @return 缓存对象
     */
    public <T> T getObject(String key, Class<T> valueType) {
        String value = get(key);
        if (StringUtils.isBlank(value)) {
            return null;
        }
        try {
            return GSON.fromJson(value, valueType);
        } catch (Exception e) {
            log.error("Redis getObject error - key: {}", key, e);
            throw new RuntimeException("Redis getObject error", e);
        }
    }

    /**
     * 获取对象列表缓存
     *
     * @param key       缓存键
     * @param valueType 对象类型
     * @return 缓存对象列表
     */
    public <T> List<T> getObjectList(String key, Class<T> valueType) {
        String value = get(key);
        if (StringUtils.isBlank(value)) {
            return Collections.emptyList();
        }
        try {
            return GSON.fromJson(value, TypeToken.getParameterized(List.class, valueType).getType());
        } catch (Exception e) {
            log.error("Redis getObjectList error - key: {}", key, e);
            throw new RuntimeException("Redis getObjectList error", e);
        }
    }

    // ============================== 集合操作 ==============================

    /**
     * 添加元素到集合
     *
     * @param key        缓存键
     * @param values     元素集合
     * @param expireTime 过期时间
     * @param timeUnit   时间单位
     */
    public void addToSet(String key, Set<?> values, long expireTime, TimeUnit timeUnit) {
        validateKey(key);
        if (CollectionUtils.isEmpty(values)) {
            return;
        }
        try {
            redisTemplate.opsForSet().add(key, values.toArray(Object[]::new));
            stringRedisTemplate.expire(key, expireTime, timeUnit);
            log.info("Redis addToSet success - key: {}, values: {}", key, values);
        } catch (Exception e) {
            log.error("Redis addToSet error - key: {}", key, e);
            throw new RuntimeException("Redis addToSet error", e);
        }
    }

    /**
     * 获取集合
     *
     * @param key       缓存键
     * @param valueType 值类型
     * @return 集合
     */
    public <T> Set<T> getSet(String key, Class<T> valueType) {
        validateKey(key);
        try {
            Set<Object> set = redisTemplate.opsForSet().members(key);
            if (CollectionUtils.isEmpty(set)) {
                return Collections.emptySet();
            }
            return set.stream()
                    .filter(valueType::isInstance)
                    .map(valueType::cast)
                    .collect(Collectors.toSet());
        } catch (Exception e) {
            log.error("Redis getSet error - key: {}", key, e);
            throw new RuntimeException("Redis getSet error", e);
        }
    }

    /**
     * 从集合中移除元素
     *
     * @param key   缓存键
     * @param value 元素值
     */
    public void removeFromSet(String key, Long value) {
        validateKey(key);
        try {
            stringRedisTemplate.opsForSet().remove(key, value.toString());
            log.info("Redis removeFromSet success - key: {}, value: {}", key, value);
        } catch (Exception e) {
            log.error("Redis removeFromSet error - key: {}", key, e);
            throw new RuntimeException("Redis removeFromSet error", e);
        }
    }

    // ============================== 工具方法 ==============================

    private void validateKey(String key) {
        if (StringUtils.isBlank(key)) {
            throw new IllegalArgumentException("Redis key cannot be empty");
        }
    }

    private void validateKeyAndValue(String key, String value) {
        validateKey(key);
        if (StringUtils.isBlank(value)) {
            throw new IllegalArgumentException("Value cannot be null or empty");
        }
    }

    // ============================== 分布式锁方法 ==============================

    /**
     * 尝试获取分布式锁
     *
     * @param lockKey    锁键
     * @param waitTime   等待时间
     * @param leaseTime  锁持有时间
     * @param timeUnit   时间单位
     * @return 是否获取成功
     */
    public boolean tryLock(String lockKey, long waitTime, long leaseTime, TimeUnit timeUnit) {
        validateKey(lockKey);
        try {
            String lockValue = Thread.currentThread().getId() + ":" + System.currentTimeMillis();
            long waitTimeMillis = timeUnit.toMillis(waitTime);
            long leaseTimeMillis = timeUnit.toMillis(leaseTime);
            long startTime = System.currentTimeMillis();
            
            while (System.currentTimeMillis() - startTime < waitTimeMillis) {
                Boolean success = stringRedisTemplate.opsForValue().setIfAbsent(lockKey, lockValue, leaseTimeMillis, TimeUnit.MILLISECONDS);
                if (Boolean.TRUE.equals(success)) {
                    return true;
                }
                // 短暂等待后重试
                Thread.sleep(50);
            }
            return false;
        } catch (Exception e) {
            log.error("Redis tryLock error - lockKey: {}", lockKey, e);
            return false;
        }
    }

    /**
     * 释放分布式锁
     *
     * @param lockKey 锁键
     */
    public void releaseLock(String lockKey) {
        validateKey(lockKey);
        try {
            String lockValue = stringRedisTemplate.opsForValue().get(lockKey);
            if (lockValue != null && lockValue.startsWith(Thread.currentThread().getId() + ":")) {
                stringRedisTemplate.delete(lockKey);
            }
        } catch (Exception e) {
            log.error("Redis releaseLock error - lockKey: {}", lockKey, e);
        }
    }
}
