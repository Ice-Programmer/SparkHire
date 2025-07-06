package com.ice.sparkhire.validation;

import org.apache.commons.lang3.StringUtils;

import java.util.regex.Pattern;

/**
 * 正则校验工具类
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/3/9 22:31
 */
public class ValidatorUtil {

    // 邮箱正则表达式
    private static final String EMAIL_PATTERN = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";

    // 校验邮箱是否有效
    public static boolean isValidEmail(String email) {
        if (StringUtils.isBlank(email)) {
            return false;
        }
        return Pattern.matches(EMAIL_PATTERN, email);
    }

}
