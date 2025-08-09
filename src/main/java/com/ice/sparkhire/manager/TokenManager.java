package com.ice.sparkhire.manager;

import cn.hutool.core.codec.Base64;
import com.ice.sparkhire.auth.vo.TokenCacheVO;
import com.ice.sparkhire.auth.vo.TokenVO;
import com.ice.sparkhire.auth.vo.UserBasicInfo;
import com.ice.sparkhire.auth.UserRoleConstant;
import com.ice.sparkhire.cache.constant.UserConstant;
import com.ice.sparkhire.constant.ErrorCode;
import com.ice.sparkhire.auth.JwtConstant;
import com.ice.sparkhire.constant.LogColorConstant;
import com.ice.sparkhire.cache.constant.CacheConstant;
import com.ice.sparkhire.exception.BusinessException;
import com.ice.sparkhire.mapper.UserMapper;
import com.ice.sparkhire.mq.constant.MailMessageConstant;
import com.ice.sparkhire.mq.producer.EmailMessageProducer;
import com.ice.sparkhire.mq.task.EmailMessageTask;
import com.ice.sparkhire.security.SecurityContext;
import com.ice.sparkhire.utils.DateUtil;
import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.TimeUnit;

/**
 * token 管理类
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/7/4 15:28
 */
@Slf4j
@Service
public class TokenManager {
    @Resource
    private RedisManager redisManager;

    @Resource
    private EmailMessageProducer emailMessageProducer;
    @Autowired
    private UserMapper userMapper;

    /**
     * 生成 token 并存储在缓存中
     *
     * @param userBasicInfo 用户基础信息
     * @param device        当前登录设备
     * @return tokenVO
     */
    public TokenVO createTokenVOAndStore(UserBasicInfo userBasicInfo, String device, String ip) {
        long current = System.currentTimeMillis();
        String userRole = userBasicInfo.getRole();
        long expireCacheTime = getExpireTime(userRole);
        Date date = new Date(current + expireCacheTime);
        Long userId = userBasicInfo.getId();

        // 生成 jwt token
        SecretKey key = Keys.hmacShaKeyFor(JwtConstant.JWT_SECRET_KEY.getBytes(StandardCharsets.UTF_8));

        Map<String, String> claims = new HashMap<>();
        claims.put(JwtConstant.CLAIMS_USER_ID, String.valueOf(userId));
        claims.put(JwtConstant.CLAIMS_DEVICE, device);

        JwtBuilder builder = Jwts.builder()
                .signWith(key)
                .claims(claims)
                .expiration(date);
        String accessToken = builder.compact();

        TokenVO tokenVO = new TokenVO();
        tokenVO.setAccessToken(accessToken);
        tokenVO.setExpireTime(current + expireCacheTime);

        // 存储 token 缓存信息
        String cacheKey = CacheConstant.ACCESS + getCacheKey(String.valueOf(userId), device);
        TokenCacheVO tokenCacheVO = new TokenCacheVO();
        tokenCacheVO.setAccessToken(accessToken);
        tokenCacheVO.setDevice(device);
        tokenCacheVO.setIp(ip);
        storeToken(cacheKey, tokenCacheVO, userBasicInfo, expireCacheTime);

        // 存储用户信息
        redisManager.setObject(
                UserConstant.getUserInfoKey(userId),
                userBasicInfo,
                expireCacheTime,
                TimeUnit.MILLISECONDS
        );
        return tokenVO;
    }


    /**
     * 获取过期时间
     *
     * @param userRole 用户身份
     * @return 过期时间
     */
    private long getExpireTime(String userRole) {
        // 一个月过期时间
        long expireTimeMills = 3600 * 24 * 30 * 1000L;

        // 普通用户token过期时间 一个月
        if (UserRoleConstant.isCommonUser(userRole)) {
            return expireTimeMills;
        }
        // 系统管理员的token过期时间 2 小时
        if (Objects.equals(userRole, UserRoleConstant.ADMIN_ROLE) ||
                Objects.equals(userRole, UserRoleConstant.SUPER_ADMIN_ROLE)) {
            expireTimeMills = expireTimeMills * 2;
        }
        return expireTimeMills;
    }

    /**
     * 存储 AccessToken
     *
     * @param key           缓存键
     * @param tokenCacheVO  缓存存储用户凭证信息
     * @param userBasicInfo 用户信息
     * @param expireTime    过期时间
     */
    public void storeToken(String key, TokenCacheVO tokenCacheVO, UserBasicInfo userBasicInfo, long expireTime) {
        // 判断是当前设备是否已经登录
        if (redisManager.exists(key)) {
            // 把上一个 token 删除，踢下线
            redisManager.delete(key);
            log.info(LogColorConstant.BLUE + "用户 {} 在 {} 设备已踢下线", key, tokenCacheVO.getDevice());
            // 发布邮件
            sendMultiLoginWarningEmail(userBasicInfo, tokenCacheVO.getIp(), tokenCacheVO.getDevice());
        }

        // 存储 token
        redisManager.setObject(key, tokenCacheVO, expireTime, TimeUnit.MILLISECONDS);
    }

    /**
     * 校验 token 并获取用户基础信息
     *
     * @param accessToken accessToken
     * @return 用户基础信息
     */
    public Long checkTokenAndGetUserBasicInfo(String accessToken) {
        if (StringUtils.isEmpty(accessToken)) {
            throw new BusinessException(ErrorCode.NOT_LOGIN_ERROR, "用户未登录");
        }

        // 解析 token
        SecretKey key = Keys.hmacShaKeyFor(JwtConstant.JWT_SECRET_KEY.getBytes(StandardCharsets.UTF_8));
        String userId;
        String device;
        Date expireDate;
        try {
            JwtParser jwtParser = Jwts.parser()
                    // 设置签名的秘钥
                    .verifyWith(key)
                    .build();
            Jws<Claims> claims = jwtParser.parseSignedClaims(accessToken);
            Claims payload = claims.getPayload();
            userId = payload.get(JwtConstant.CLAIMS_USER_ID, String.class);
            device = payload.get(JwtConstant.CLAIMS_DEVICE, String.class);
            expireDate = payload.getExpiration();
        } catch (ExpiredJwtException e) {
            throw new BusinessException(ErrorCode.TOKEN_EXPIRE_ERROR);
        } catch (Exception e) {
            log.error("token 解析错误: {}", e.getMessage());
            throw new BusinessException(ErrorCode.TOKEN_PARSE_ERROR);
        }

        // 判断 token 是否过期
        if (expireDate.before(new Date())) {
            throw new BusinessException(ErrorCode.TOKEN_EXPIRE_ERROR);
        }

        // 获取缓存键值
        String cacheKey = CacheConstant.ACCESS + getCacheKey(userId, device);

        // 判断 Redis 是否过期
        if (!redisManager.exists(cacheKey)) {
            throw new BusinessException(ErrorCode.TOKEN_EXPIRE_ERROR, "用户登录状态过期，请重新登录");
        }
        // 取出缓存中 token 信息
        TokenCacheVO tokenCacheVO = redisManager.getObject(cacheKey, TokenCacheVO.class);

        // 返回用户基础信息
        return tokenCacheVO.getUserId();
    }

    /**
     * 移除当前用户 token 缓存
     *
     * @param userBasicInfo 用户基础信息
     * @param device        当前登录设备
     */
    public void removeTokenCache(UserBasicInfo userBasicInfo, String device) {
        String cacheKey = CacheConstant.ACCESS + getCacheKey(String.valueOf(userBasicInfo.getId()), device);
        redisManager.delete(cacheKey);
        log.info("当前用户名: {}, id: {}, 退出 {} 端登录",
                userBasicInfo.getUsername(), userBasicInfo.getId(), device);
    }

    /**
     * 生成存储在缓存中的 key（Base64加密）
     *
     * @param userId 用户id
     * @param device 设备信息
     * @return 缓存中的 key
     */
    private String getCacheKey(String userId, String device) {
        String key = userId + CacheConstant.UNION + device;
        return Base64.encode(key);
    }

    /**
     * 发送多地登录邮件
     *
     * @param currentUser   当前登录用户
     * @param currentUserIp ip 地址
     * @param device        设备
     */
    private void sendMultiLoginWarningEmail(UserBasicInfo currentUser, String currentUserIp, String device) {
        EmailMessageTask emailMessageTask = new EmailMessageTask();
        emailMessageTask.setContent(MailMessageConstant.multiLoginWarningMessage(DateUtil.getCurrentDateStr(), currentUserIp, device));
        emailMessageTask.setTargetEmail(currentUser.getEmail());
        emailMessageTask.setSubject(MailMessageConstant.MULTI_LOGIN_WARNING_SUBJECT);
        emailMessageProducer.sendEmailMessage(emailMessageTask);
    }
}
