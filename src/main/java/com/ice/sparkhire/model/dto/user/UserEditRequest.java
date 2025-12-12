package com.ice.sparkhire.model.dto.user;

import com.ice.sparkhire.annotation.EnumCheck;
import com.ice.sparkhire.model.enums.UserGenderEnum;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import org.hibernate.validator.constraints.Length;

import java.io.Serializable;

/**
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/11/29 21:40
 */
@Data
public class UserEditRequest implements Serializable {

    /**
     * 用户名称
     */
    @Length(max = 20, message = "用户名称长度不得超过 20")
    @NotBlank(message = "用户名称不得为空！")
    private String username;

    /**
     * 用户性别
     */
    @EnumCheck(enumClass = UserGenderEnum.class, message = "用户性别错误！")
    private Integer gender;

    /**
     * 用户头像
     */
    private String userAvatar;


    /**
     * 自我评价
     */
    @Length(max = 1000, message = "自我介绍长度不能超过 1000 字!")
    private String profile;
}
