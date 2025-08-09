package com.ice.sparkhire.utils;

import jakarta.servlet.http.HttpServletRequest;

/**
 * ip 工具类
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/8/9 16:29
 */
public class IpUtil {

    /**
     * 获取当前登录 ip 地址
     *
     * @param request 网络请求
     * @return ip 地址
     */
    public static String getCurrentIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        // 处理多级代理的情况（如：X-Forwarded-For: IP1, IP2, IP3）
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        return ip;
    }
}
