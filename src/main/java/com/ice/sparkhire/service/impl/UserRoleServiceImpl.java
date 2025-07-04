package com.ice.sparkhire.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ice.sparkhire.model.entity.UserRole;
import com.ice.sparkhire.service.UserRoleService;
import com.ice.sparkhire.mapper.UserRoleMapper;
import org.springframework.stereotype.Service;

/**
* @author chenjiahan
* @description 针对表【user_role(用户角色关联)】的数据库操作Service实现
* @createDate 2025-07-04 14:56:55
*/
@Service
public class UserRoleServiceImpl extends ServiceImpl<UserRoleMapper, UserRole>
    implements UserRoleService{

}




