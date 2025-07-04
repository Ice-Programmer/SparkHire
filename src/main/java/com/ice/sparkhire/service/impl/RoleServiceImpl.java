package com.ice.sparkhire.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ice.sparkhire.model.entity.Role;
import com.ice.sparkhire.service.RoleService;
import com.ice.sparkhire.mapper.RoleMapper;
import org.springframework.stereotype.Service;

/**
* @author chenjiahan
* @description 针对表【role(角色)】的数据库操作Service实现
* @createDate 2025-07-04 14:56:55
*/
@Service
public class RoleServiceImpl extends ServiceImpl<RoleMapper, Role>
    implements RoleService{

}




