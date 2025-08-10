package com.ice.sparkhire.service;

import com.ice.sparkhire.auth.vo.UserBasicInfo;
import com.ice.sparkhire.model.entity.User;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * @author chenjiahan
 * @description 针对表【user(用户)】的数据库操作Service
 * @createDate 2025-07-04 14:56:55
 */
public interface UserService extends IService<User> {
    /**
     * 用户根据邮箱登录
     *
     * @param email      邮箱
     * @param verifyCode 验证码
     * @return 用户登录信息
     */
    UserBasicInfo userLoginByMail(String email, String verifyCode);

    /**
     * 从缓存中获取用户信息
     *
     * @return 用户信息
     */
    UserBasicInfo getUserInfo(Long userId);

    /**
     * 切换当前用户身份
     *
     * @param role 用户身份
     * @return 用户信息
     */
    UserBasicInfo switchUserRole(String role);
}
