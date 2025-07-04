package com.ice.sparkhire.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ice.sparkhire.model.entity.User;
import com.ice.sparkhire.service.UserService;
import com.ice.sparkhire.mapper.UserMapper;
import org.springframework.stereotype.Service;

/**
* @author chenjiahan
* @description 针对表【user(用户)】的数据库操作Service实现
* @createDate 2025-07-04 14:56:55
*/
@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User>
    implements UserService{

}




