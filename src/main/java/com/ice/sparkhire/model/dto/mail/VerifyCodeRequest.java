package com.ice.sparkhire.model.dto.mail;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

/**
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/7/6 13:05
 */
@Data
public class VerifyCodeRequest implements Serializable {

    /**
     * 邮箱
     */
    private String email;

    @Serial
    private static final long serialVersionUID = 7002263956896729551L;
}
