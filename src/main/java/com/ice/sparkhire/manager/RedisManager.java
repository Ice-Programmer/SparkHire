package com.ice.sparkhire.manager;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
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
    public void addToSet(String key, Set<Long> values, long expireTime, TimeUnit timeUnit) {
        validateKey(key);
        if (CollectionUtils.isEmpty(values)) {
            return;
        }
        try {
            stringRedisTemplate.opsForSet().add(key, values.stream().map(String::valueOf).toArray(String[]::new));
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
     * @param key 缓存键
     * @return 集合
     */
    public Set<Long> getSet(String key) {
        validateKey(key);
        try {
            Set<String> stringSet = stringRedisTemplate.opsForSet().members(key);
            if (CollectionUtils.isEmpty(stringSet)) {
                return Collections.emptySet();
            }
            return stringSet.stream().map(Long::valueOf).collect(Collectors.toSet());
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
            throw new IllegalArgumentException("Redis value cannot be empty");
        }
    }

}
