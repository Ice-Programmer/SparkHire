package com.ice.sparkhire.model.user;

import lombok.Data;

/**
 * 用户切换身份请求
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/8/10 10:52
 */
@Data
public class UserSwitchRoleRequest {

    /**
     * 用户身份
     */
    private String role;
}
