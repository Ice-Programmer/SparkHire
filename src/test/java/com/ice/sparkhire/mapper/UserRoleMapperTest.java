package com.ice.sparkhire.mapper;


import com.ice.sparkhire.auth.UserRoleConstant;
import jakarta.annotation.Resource;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

/**
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/7/26 00:11
 */
@SpringBootTest
class UserRoleMapperTest {
    @Resource
    private UserRoleMapper userRoleMapper;

    @Test
    void updateUserRole() {
        userRoleMapper.updateUserRole(1941727358157537281L, UserRoleConstant.EMPLOYEE_ROLE);
    }
}