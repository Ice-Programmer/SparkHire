package com.ice.sparkhire.config;

import com.ice.sparkhire.constant.InterceptorConstant;
import com.ice.sparkhire.interceptor.AuthInterceptor;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import jakarta.annotation.Resource;

/**
 * 拦截器配置类
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/3/10 15:34
 */
@Component
public class AuthInterceptorConfig implements WebMvcConfigurer {

    @Resource
    private AuthInterceptor authInterceptor;

    /**
     * 设置权限校验拦截器
     */
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(authInterceptor)
                .addPathPatterns(InterceptorConstant.AUTH_INTERCEPTOR_PATH_PATTERN)
                .excludePathPatterns(InterceptorConstant.AUTH_INTERCEPTOR_EXCLUDE_PATH_PATTERN)
                .order(0);
    }
}
