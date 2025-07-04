package com.ice.sparkhire.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.util.Date;

import lombok.Data;

/**
 * 角色权限关联
 *
 * @TableName role_permission
 */
@TableName(value = "role_permission")
@Data
public class RolePermission {
    /**
     * id
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 角色 id
     */
    private Long roleId;

    /**
     * 权限 id
     */
    private Long permissionId;

    /**
     * 创建时间
     */
    private Date createTime;
}