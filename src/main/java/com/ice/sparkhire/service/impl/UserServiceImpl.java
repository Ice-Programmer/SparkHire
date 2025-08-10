package com.ice.sparkhire.service.impl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ice.sparkhire.annotation.CustomCache;
import com.ice.sparkhire.auth.vo.UserBasicInfo;
import com.ice.sparkhire.constant.CommonConstant;
import com.ice.sparkhire.constant.ErrorCode;
import com.ice.sparkhire.constant.UserConstant;
import com.ice.sparkhire.cache.constant.CacheConstant;
import com.ice.sparkhire.exception.BusinessException;
import com.ice.sparkhire.exception.ThrowUtils;
import com.ice.sparkhire.manager.RedisManager;
import com.ice.sparkhire.mapper.RoleMapper;
import com.ice.sparkhire.mapper.UserRoleMapper;
import com.ice.sparkhire.model.entity.Role;
import com.ice.sparkhire.model.entity.User;
import com.ice.sparkhire.model.entity.UserRole;
import com.ice.sparkhire.model.enums.UserRoleEnum;
import com.ice.sparkhire.security.SecurityContext;
import com.ice.sparkhire.service.UserService;
import com.ice.sparkhire.mapper.UserMapper;
import com.ice.sparkhire.utils.CacheKeyUtil;
import jakarta.annotation.Resource;
import org.apache.commons.lang3.ObjectUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.util.DigestUtils;

import java.util.Objects;

/**
 * @author chenjiahan
 * @description 针对表【user(用户)】的数据库操作Service实现
 * @createDate 2025-07-04 14:56:55
 */
@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User>
        implements UserService {

    @Resource
    private RedisManager redisManager;

    @Resource
    private TransactionTemplate transactionTemplate;

    @Resource
    private RoleMapper roleMapper;

    @Resource
    private UserRoleMapper userRoleMapper;

    @Override
    public UserBasicInfo userLoginByMail(String email, String verifyCode) {
        // 1. 校验邮箱验证码是否正确
        verifyEmailCode(email, verifyCode);

        // 2. 判断用户是否存在
        UserBasicInfo userBasicInfo = baseMapper.getUserBasicInfoByEmail(email);

        // 2.1 不存在新用户插入数据库
        if (ObjectUtils.isEmpty(userBasicInfo)) {
            userBasicInfo = registerUser(email);
        }

        // 3. 判断用户身份是否被 ban
        if (UserRoleEnum.BAN.getValue().equals(userBasicInfo.getRole())) {
            throw new BusinessException(ErrorCode.NO_AUTH_ERROR, "用户当前已禁用，请联系管理员");
        }

        // 4. 填充基础信息
        return userBasicInfo;
    }

    @Override
    @CustomCache(key = CacheConstant.USER_INFO_PREFIX, duration = CacheConstant.MONTH_EXPIRE_TIME)
    public UserBasicInfo getUserInfo(Long userId) {
        UserBasicInfo userBasicInfo = baseMapper.getUserBasicInfoById(userId);
        ThrowUtils.throwIf(ObjectUtils.isEmpty(userBasicInfo), ErrorCode.SYSTEM_ERROR, "获取用户信息失败，用户 id 不存在");
        return userBasicInfo;
    }

    @Override
    public UserBasicInfo switchUserRole(String role) {
        // 获取当前登录用户
        UserBasicInfo currentUser = SecurityContext.getCurrentUser();

        // 1. 校验参数
        if (Objects.equals(currentUser.getRole(), role)) {
            throw new BusinessException(ErrorCode.OPERATION_ERROR, String.format("当前用户角色已经是 「%s」", role));
        }

        if (!UserRoleEnum.EMPLOYEE.getValue().equals(role) && !UserRoleEnum.EMPLOYER.getValue().equals(role)) {
            throw new BusinessException(ErrorCode.NO_AUTH_ERROR, "仅能切换 「招聘者」身份和 「应聘者」身份");
        }

        // 2. 切换用户身份
        // 2.1 删除缓存
        redisManager.delete(CacheKeyUtil.getUserInfoKey(currentUser.getId()));

        transactionTemplate.executeWithoutResult(status -> {
            // 2.2 更新数据库
            userRoleMapper.updateUserRole(currentUser.getId(), role);

            // 2.3 todo 更新用户权限列表
        });



        return getUserInfo(currentUser.getId());
    }

    /**
     * 注册新用户
     *
     * @param email 邮箱
     * @return 用户
     */
    private UserBasicInfo registerUser(String email) {
        transactionTemplate.executeWithoutResult(status -> {
            try {
                User user = new User();
                user.setEmail(email);
                user.setUsername(UserConstant.generateUniqueUsername());
                user.setUserAvatar(UserConstant.getRandomUserAvatar());
                baseMapper.insert(user);
                // 插入用户默认权限（guest）
                Role guestRole = roleMapper.selectOne(Wrappers.<Role>lambdaQuery()
                        .eq(Role::getRoleName, UserRoleEnum.GUEST.getValue())
                        .select(Role::getId)
                        .last(CommonConstant.LIMIT_ONE));
                ThrowUtils.throwIf(ObjectUtils.isEmpty(guestRole), ErrorCode.NOT_FOUND_ERROR, "访客身份 id 不存在");
                UserRole userRole = new UserRole();
                userRole.setRoleId(guestRole.getId());
                userRole.setUserId(user.getId());
                userRoleMapper.insert(userRole);
            } catch (DuplicateKeyException e) {
                status.setRollbackOnly();
                throw new BusinessException(ErrorCode.OPERATION_ERROR, "该邮箱已注册");
            } catch (Exception e) {
                status.setRollbackOnly();
                throw new BusinessException(ErrorCode.SYSTEM_ERROR, "用户注册失败, " + e.getMessage());
            }
        });

        // 返回完整用户信息
        return baseMapper.getUserBasicInfoByEmail(email);
    }

    /**
     * 校验当前邮箱验证码是否错误
     *
     * @param email      邮箱
     * @param verifyCode 验证码
     */
    private void verifyEmailCode(String email, String verifyCode) {
        // 1. 从缓存中判断验证码是否正确
        String emailHash = DigestUtils.md5DigestAsHex(email.getBytes());
        String verifyCodeCacheKey = CacheConstant.EMAIL_VERIFY_CODE_PREFIX + emailHash;
        String cacheVerifyCode = redisManager.get(verifyCodeCacheKey);
        ThrowUtils.throwIf(StringUtils.isBlank(cacheVerifyCode), ErrorCode.OPERATION_ERROR, "验证码已失效，请重新发送");
        if (!verifyCode.equals(cacheVerifyCode)) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "验证码错误！");
        }
    }
}




