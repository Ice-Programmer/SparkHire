package com.ice.sparkhire.model.user;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

/**
 * 用户基础信息 VO
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/7/26 10:19
 */
@Data
public class UserBasicInfoVO implements Serializable {

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

    @Serial
    private static final long serialVersionUID = 7108900264660692189L;
}
