package com.ice.sparkhire.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ice.sparkhire.model.entity.Permission;
import com.ice.sparkhire.service.PermissionService;
import com.ice.sparkhire.mapper.PermissionMapper;
import org.springframework.stereotype.Service;

/**
* @author chenjiahan
* @description 针对表【permission(权限)】的数据库操作Service实现
* @createDate 2025-07-04 14:56:55
*/
@Service
public class PermissionServiceImpl extends ServiceImpl<PermissionMapper, Permission>
    implements PermissionService{

}




