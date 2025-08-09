package com.ice.sparkhire.controller;

import com.ice.sparkhire.auth.vo.UserBasicInfo;
import com.ice.sparkhire.common.BaseResponse;
import com.ice.sparkhire.common.ResultUtils;
import com.ice.sparkhire.constant.ErrorCode;
import com.ice.sparkhire.exception.ThrowUtils;
import com.ice.sparkhire.security.SecurityContext;
import org.apache.commons.lang3.ObjectUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 用户相关接口
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/7/25 23:47
 */
@RestController
@RequestMapping("/user")
public class UserController {

    /**
     * 获取当前登录用户
     *
     * @return 当前登录用户
     */
    @GetMapping("/current")
    public BaseResponse<UserBasicInfo> getCurrentLoginUser() {
        UserBasicInfo currentUser = SecurityContext.getCurrentUser();
        ThrowUtils.throwIf(ObjectUtils.isEmpty(currentUser), ErrorCode.NOT_LOGIN_ERROR);
        return ResultUtils.success(currentUser);
    }
}
