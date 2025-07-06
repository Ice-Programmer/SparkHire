package com.ice.sparkhire.model.dto.login;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

/**
 * 用户邮箱登录
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/3/10 10:47
 */
@Data
public class UserMailLoginRequest implements Serializable {

    /**
     * 邮箱
     */
    private String email;

    /**
     * 验证码
     */
    private String verifyCode;

    @Serial
    private static final long serialVersionUID = -8775526746995733192L;
}
