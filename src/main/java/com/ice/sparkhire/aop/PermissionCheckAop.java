package com.ice.sparkhire.aop;

import com.ice.sparkhire.annotation.MustRole;
import com.ice.sparkhire.auth.vo.UserBasicInfo;
import com.ice.sparkhire.constant.ErrorCode;
import com.ice.sparkhire.exception.BusinessException;
import com.ice.sparkhire.exception.ThrowUtils;
import com.ice.sparkhire.model.enums.UserRoleEnum;
import com.ice.sparkhire.security.SecurityContext;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import java.util.Arrays;

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

    @Before("@annotation(mustRole)")
    public void check(JoinPoint joinPoint, MustRole mustRole) {
        // 获取当前登陆用户
        UserBasicInfo currentUser = SecurityContext.getCurrentUser();
        ThrowUtils.throwIf(currentUser == null, ErrorCode.NOT_LOGIN_ERROR);

        // 获取角色信息
        String userRole = currentUser.getRole();
        UserRoleEnum[] roleEnums = mustRole.value();

        // 校验权限
        boolean hasPermission = checkPermissions(roleEnums, userRole);

        if (!hasPermission) {
            String message = String.format("用户【%s】访问【%s】权限不足，需要权限:【%s】, 用户权限: 【%s】",
                    currentUser.getUsername(),
                    joinPoint.getSignature().toShortString(),
                    Arrays.toString(roleEnums),
                    userRole);
            log.error(message);
            throw new BusinessException(ErrorCode.NO_AUTH_ERROR, "权限不足");
        }
    }

    /**
     * 校验用户权限
     *
     * @param needRoles 当前用户角色集合
     * @param userRole  需要用户角色
     * @return 是否拥有足够权限
     */
    private boolean checkPermissions(UserRoleEnum[] needRoles, String userRole) {
        for (UserRoleEnum needRole : needRoles) {
            if (needRole.getValue().equals(userRole)) {
                return true;
            }
        }
        return false;
    }

}

