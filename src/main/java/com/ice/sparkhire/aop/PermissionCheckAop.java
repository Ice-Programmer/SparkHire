package com.ice.sparkhire.aop;

import com.ice.sparkhire.annotation.MustRole;
import com.ice.sparkhire.auth.vo.UserBasicInfo;
import com.ice.sparkhire.constant.ErrorCode;
import com.ice.sparkhire.exception.BusinessException;
import com.ice.sparkhire.exception.ThrowUtils;
import com.ice.sparkhire.manager.PermissionManager;
import com.ice.sparkhire.model.enums.UserRoleEnum;
import com.ice.sparkhire.security.SecurityContext;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import java.util.Arrays;
import java.util.Set;

/**
 * 权限校验切面
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/6/9 14:20
 */
@Slf4j
@Aspect
@Component
public class PermissionCheckAop {

    @Resource
    private PermissionManager permissionManager;

    @Before("@annotation(mustRole)")
    public void check(JoinPoint joinPoint, MustRole mustRole) {
        // 获取当前登陆用户
        UserBasicInfo currentUser = SecurityContext.getCurrentUser();
        ThrowUtils.throwIf(currentUser == null, ErrorCode.NOT_LOGIN_ERROR);

        // 校验角色
        UserRoleEnum[] roleEnums = mustRole.value();

        if (roleEnums != null && roleEnums.length > 0) {
            String userRole = currentUser.getRole();
            boolean hasRole = checkRoles(roleEnums, userRole, mustRole.logical());

            if (!hasRole) {
                String message = String.format("用户【%s】访问【%s】角色不足，需要角色:【%s】, 用户角色: 【%s】",
                        currentUser.getUsername(),
                        joinPoint.getSignature().toShortString(),
                        Arrays.toString(roleEnums),
                        userRole);
                log.error(message);
                throw new BusinessException(ErrorCode.NO_AUTH_ERROR, "权限不足");
            }
        }

        // 校验权限
        String[] permissions = mustRole.permissions();
        if (permissions != null && permissions.length > 0) {
            // 检查是否允许超级管理员跳过权限检查
            if (mustRole.allowSuperAdmin() && UserRoleEnum.SUPER_ADMIN.getValue().equals(currentUser.getRole())) {
                return;
            }

            // 获取用户权限
            Set<String> userPermissions = permissionManager.getUserPermissions(currentUser.getId());
            String[] userPermissionArray = userPermissions.toArray(new String[0]);

            boolean hasPermission = checkPermission(permissions, userPermissionArray, mustRole.logical());

            if (!hasPermission) {
                String message = String.format("用户【%s】访问【%s】权限不足，需要权限:【%s】, 用户权限: 【%s】",
                        currentUser.getUsername(),
                        joinPoint.getSignature().toShortString(),
                        Arrays.toString(permissions),
                        Arrays.toString(userPermissionArray));
                log.error(message);
                throw new BusinessException(ErrorCode.NO_AUTH_ERROR, message);
            }
        }
    }

    /**
     * 校验用户权限
     *
     * @param needRoles 当前用户角色集合
     * @param userRole  需要用户角色
     * @return 是否拥有足够权限
     */
    private boolean checkRoles(UserRoleEnum[] needRoles, String userRole, MustRole.Logical logical) {
        for (UserRoleEnum needRole : needRoles) {
            if (needRole.getValue().equals(userRole)) {
                return true;
            }
        }
        return false;
    }

    /**
     * 校验用户权限
     *
     * @param permissions     需要的权限数组
     * @param userPermissions 用户拥有的权限数组
     * @param logical         权限检查逻辑
     * @return 是否拥有足够权限
     */
    private boolean checkPermission(String[] permissions, String[] userPermissions, MustRole.Logical logical) {
        if (permissions == null || permissions.length == 0) {
            return true;
        }

        if (userPermissions == null || userPermissions.length == 0) {
            return false;
        }

        // 将用户权限转换为Set以提高查找效率
        Set<String> userPermissionSet = Set.of(userPermissions);

        return switch (logical) {
            case AND -> Arrays.stream(permissions).allMatch(userPermissionSet::contains);
            case OR -> Arrays.stream(permissions).anyMatch(userPermissionSet::contains);
            case NOT -> Arrays.stream(permissions).noneMatch(userPermissionSet::contains);
        };
    }
}

