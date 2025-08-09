package com.ice.sparkhire.auth.vo;

import lombok.Data;

import java.util.Set;

/**
 * 用户基础信息
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/3/10 10:49
 */
@Data
public class UserBasicInfo {

    /**
     * 用户 id
     */
    private Long id;

    /**
     * 用户名
     */
    private String username;

    /**
     * 用户头像
     */
    private String userAvatar;

    /**
     * 邮箱
     */
    private String email;

    /**
     * 用户角色
     */
    private String role;

}
