package com.ice.sparkhire.utils;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * 时间工具
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/8/9 16:16
 */
public class DateUtil {

    /**
     * 时间模版
     */
    public static final DateTimeFormatter FORMATTER_PATTEN = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    /**
     * 获取当前时间
     *
     * @return 获取当前时间字符串
     */
    public static String getCurrentDateStr() {
        return LocalDateTime.now().format(FORMATTER_PATTEN);
    }
}
