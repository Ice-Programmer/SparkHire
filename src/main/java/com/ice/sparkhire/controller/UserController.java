package com.ice.sparkhire.controller;

import com.ice.sparkhire.auth.IgnoreAuth;
import com.ice.sparkhire.auth.vo.TokenVO;
import com.ice.sparkhire.auth.vo.UserBasicInfo;
import com.ice.sparkhire.common.BaseResponse;
import com.ice.sparkhire.common.ResultUtils;
import com.ice.sparkhire.constant.ErrorCode;
import com.ice.sparkhire.exception.BusinessException;
import com.ice.sparkhire.exception.ThrowUtils;
import com.ice.sparkhire.manager.TokenManager;
import com.ice.sparkhire.model.dto.login.UserMailRegisterRequest;
import com.ice.sparkhire.model.user.UserSwitchRoleRequest;
import com.ice.sparkhire.security.SecurityContext;
import com.ice.sparkhire.service.UserService;
import com.ice.sparkhire.utils.DeviceUtil;
import com.ice.sparkhire.utils.IpUtil;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.ObjectUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.web.bind.annotation.*;

/**
 * 用户相关接口
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/7/25 23:47
 */
@Slf4j
@RestController
@RequestMapping("/user")
public class UserController {

    @Resource
    private UserService userService;

    @Resource
    private TokenManager tokenManager;

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

    /**
     * 切换用户身份
     *
     * @return 当前登录用户
     */
    @PostMapping("/role/switch")
    public BaseResponse<UserBasicInfo> switchUserRole(@RequestBody UserSwitchRoleRequest userSwitchRoleRequest) {
        if (ObjectUtils.isEmpty(userSwitchRoleRequest)) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        String role = userSwitchRoleRequest.getRole();
        ThrowUtils.throwIf(StringUtils.isBlank(role), ErrorCode.PARAMS_ERROR, "role 为空！");
        return ResultUtils.success(userService.switchUserRole(role));
    }

    /**
     * 用户邮箱注册
     *
     * @param userMailRegisterRequest 用户邮箱注册
     * @param request                 网络请求
     * @return 用户基础信息
     */
    @IgnoreAuth
    @PostMapping("/mail/register")
    public BaseResponse<TokenVO> userRegisterByMail(@RequestBody @Valid UserMailRegisterRequest userMailRegisterRequest, HttpServletRequest request) {
        String email = userMailRegisterRequest.getEmail();
        String verifyCode = userMailRegisterRequest.getVerifyCode();

        // 注册
        UserBasicInfo userBasicInfo = userService.userRegisterByMail(email, verifyCode);

        // 保存 redis
        String userRole = userBasicInfo.getRole();
        String device = DeviceUtil.getRequestDevice(request);
        String ip = IpUtil.getCurrentIp(request);
        TokenVO tokenVO = tokenManager.createTokenVOAndStore(userBasicInfo, device, ip);
        log.info("User {} ({} role) Register by {} Successfully! userId: {}",
                userBasicInfo.getUsername(), userRole, device, userBasicInfo.getId());

        return ResultUtils.success(tokenVO);
    }
}
