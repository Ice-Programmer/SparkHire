package com.ice.sparkhire.auth.vo;

import lombok.Data;

/**
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/3/10 13:15
 */
@Data
public class TokenCacheVO {

    /**
     * 用户登录凭证
     */
    private String accessToken;

    /**
     * 当前登录设备
     */
    private String device;

    /**
     * 用户 id
     */
    private Long userId;

    /**
     * 登录 ip 地址
     */
    private String ip;
}
