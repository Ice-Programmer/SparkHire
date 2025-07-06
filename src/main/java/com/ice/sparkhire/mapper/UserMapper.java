package com.ice.sparkhire.mapper;

import com.ice.sparkhire.auth.UserBasicInfo;
import com.ice.sparkhire.model.entity.User;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;

/**
 * @author chenjiahan
 * @description 针对表【user(用户)】的数据库操作Mapper
 * @createDate 2025-07-04 14:56:55
 * @Entity com.ice.sparkhire.model.entity.User
 */
public interface UserMapper extends BaseMapper<User> {

    /**
     * 查询用户基础信息
     *
     * @param email 邮箱地址
     * @return 用户基础信息
     */
    UserBasicInfo getUserBasicInfoByEmail(@Param("email") String email);
}




