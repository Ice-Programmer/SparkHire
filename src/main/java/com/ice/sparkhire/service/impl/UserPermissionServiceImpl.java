package com.ice.sparkhire.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ice.sparkhire.model.entity.UserPermission;
import com.ice.sparkhire.service.UserPermissionService;
import com.ice.sparkhire.mapper.UserPermissionMapper;
import org.springframework.stereotype.Service;

/**
* @author chenjiahan
* @description 针对表【user_permission(用户权限表)】的数据库操作Service实现
* @createDate 2025-08-30 20:13:23
*/
@Service
public class UserPermissionServiceImpl extends ServiceImpl<UserPermissionMapper, UserPermission>
    implements UserPermissionService{

}




