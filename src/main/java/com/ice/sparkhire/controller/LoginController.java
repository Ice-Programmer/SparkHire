package com.ice.sparkhire.controller;

import com.ice.sparkhire.auth.IgnoreAuth;
import com.ice.sparkhire.auth.TokenVO;
import com.ice.sparkhire.auth.UserBasicInfo;
import com.ice.sparkhire.common.BaseResponse;
import com.ice.sparkhire.common.ResultUtils;
import com.ice.sparkhire.constant.ErrorCode;
import com.ice.sparkhire.exception.BusinessException;
import com.ice.sparkhire.exception.ThrowUtils;
import com.ice.sparkhire.manager.TokenManager;
import com.ice.sparkhire.model.dto.login.UserMailLoginRequest;
import com.ice.sparkhire.service.UserService;
import com.ice.sparkhire.utils.DeviceUtil;
import com.ice.sparkhire.validator.ValidatorUtil;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 登陆相关接口
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/7/4 14:33
 */
@Slf4j
@RestController
@RequestMapping("/user/login")
public class LoginController {

    @Resource
    private UserService userService;

    @Resource
    private TokenManager tokenManager;

    /**
     * 根据邮箱登陆
     *
     * @param userMailLoginRequest 用户邮箱登陆请求
     * @param request              网络请求
     * @return tokenVO
     */
    @IgnoreAuth
    @PostMapping("/mail")
    public BaseResponse<TokenVO> userLoginByMail(@RequestBody UserMailLoginRequest userMailLoginRequest, HttpServletRequest request) {
        if (userMailLoginRequest == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        String email = userMailLoginRequest.getEmail();
        String verifyCode = userMailLoginRequest.getVerifyCode();

        // 校验参数
        ThrowUtils.throwIf(!ValidatorUtil.isValidEmail(email), ErrorCode.PARAMS_ERROR, "邮箱格式错误");
        ThrowUtils.throwIf(verifyCode.length() != 6, ErrorCode.PARAMS_ERROR, "验证码长度错误");

        // 登录
        UserBasicInfo userBasicInfo = userService.userLoginByMail(email, verifyCode);

        // 保存 redis
        String userRole = userBasicInfo.getRole();
        String device = DeviceUtil.getRequestDevice(request);
        TokenVO tokenVO = tokenManager.createTokenVOAndStore(userBasicInfo, device);
        log.info("User {} ({} role) Login by {} Successfully! userId: {}",
                userBasicInfo.getUsername(), userRole, device, userBasicInfo.getId());

        return ResultUtils.success(tokenVO);
    }
}
