package com.ice.sparkhire.manager;

import com.ice.sparkhire.cache.constant.CacheConstant;
import com.ice.sparkhire.mapper.UserPermissionMapper;
import com.ice.sparkhire.model.entity.Permission;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Set;
import java.util.concurrent.TimeUnit;

/**
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/8/30 08:20
 */
@Service
@Slf4j
public class PermissionManager {

    @Resource
    private RedisManager redisManager;

    @Resource
    private UserPermissionMapper userPermissionMapper;

    /**
     * 存储用户权限列表
     *
     * @param userId      用户 id
     * @param permissions 权限列表
     */
    public void storeUserPermission(Long userId, Set<String> permissions) {
        String key = CacheConstant.USER_PERMISSION_PREFIX + userId;
        redisManager.addToSet(
                key,
                permissions,
                CacheConstant.MONTH_EXPIRE_TIME,
                TimeUnit.SECONDS
        );
    }

    /**
     * 获取用户权限
     *
     * @param userId 用户 id
     * @return 用户权限集合
     */
    public synchronized Set<String> getUserPermissions(Long userId) {
        String key = CacheConstant.USER_PERMISSION_PREFIX + userId;

        // 判断是否存在
        if (redisManager.exists(key)) {
            return redisManager.getSet(key, String.class);
        }

        Set<String> permissions = userPermissionMapper.selectUserActivePermissions(userId);
        storeUserPermission(userId, permissions);

        return permissions;
    }
}
