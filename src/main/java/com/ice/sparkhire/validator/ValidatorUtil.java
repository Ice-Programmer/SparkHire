package com.ice.sparkhire.validator;

import com.ice.sparkhire.constant.ErrorCode;
import com.ice.sparkhire.exception.BusinessException;
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

    /**
     * 校验年份
     *
     * @param beginYear 开始年份
     * @param endYear   结束年份
     */
    public static void checkYearRange(Integer beginYear, Integer endYear) {
        if (beginYear == null || endYear == null || beginYear > endYear) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "开始年份不能大于结束年份！");
        }
    }

}
