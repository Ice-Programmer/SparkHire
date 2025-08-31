package com.ice.sparkhire.mapper;

import com.ice.sparkhire.model.entity.Permission;
import com.ice.sparkhire.model.entity.UserPermission;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;

import java.util.Set;

/**
* @author chenjiahan
* @description 针对表【user_permission(用户权限表)】的数据库操作Mapper
* @createDate 2025-08-30 20:13:23
* @Entity com.ice.sparkhire.model.entity.UserPermission
*/
public interface UserPermissionMapper extends BaseMapper<UserPermission> {

    /**
     * 获取用户当前生效权限
     * @param userId 用户 id
     * @return 用户当前生效权限
     */
    Set<String> selectUserActivePermissions(@Param("userId") Long userId);
}




