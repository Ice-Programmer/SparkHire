package com.ice.sparkhire.auth.vo;

import lombok.Data;

/**
 * token 返回类
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/3/10 13:02
 */
@Data
public class TokenVO {

    /**
     * accessToken
     */
    private String accessToken;

    /**
     * 过期时间
     */
    private Long expireTime;
}
