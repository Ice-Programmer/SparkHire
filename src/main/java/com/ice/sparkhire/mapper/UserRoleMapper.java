package com.ice.sparkhire.mapper;

import com.ice.sparkhire.model.entity.UserRole;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;

/**
 * @author chenjiahan
 * @description 针对表【user_role(用户角色关联)】的数据库操作Mapper
 * @createDate 2025-07-04 14:56:55
 * @Entity com.ice.sparkhire.model.entity.UserRole
 */
public interface UserRoleMapper extends BaseMapper<UserRole> {

    /**
     * 更新用户当前身份
     *
     * @param userId 当前用户 id
     * @param roleName 身份
     */
    void updateUserRole(@Param("userId") Long userId, @Param("roleName") String roleName);
}




