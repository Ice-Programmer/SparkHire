-- 创建库
create database if not exists spark_hire;

-- 切换库
use spark_hire;

-- 用户表
create table if not exists `user`
(
    `id`          bigint auto_increment comment 'id' primary key,
    `username`    varchar(128)                       not null comment '用户昵称',
    `email`       varchar(256)                       not null comment '邮箱',
    `gender`      tinyint  default 1                 not null comment '0-女 1-男',
    `status`      tinyint  default 0                 not null comment '用户状态(0-正常 1-封禁)',
    `create_time` datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    `update_time` datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    `is_delete`   tinyint  default 0                 not null comment '是否删除',
    unique key uk_email (`email`),
    unique key uk_username (`username`),
    index idx_email (`email`)
) comment '用户' collate = utf8mb4_unicode_ci;

-- 角色表
create table if not exists `role`
(
    `id`           bigint auto_increment comment 'id' primary key,
    `role_name`    varchar(64)                        not null comment '角色名称',
    `display_name` varchar(64)                        not null comment '角色显示名称（如管理员、HR）',
    `description`  varchar(256)                       null comment '角色描述',
    `status`       tinyint  default 1                 not null comment '状态 0-禁用 1-启用',
    `create_time`  datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    `update_time`  datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    `is_delete`    tinyint  default 0                 not null comment '是否删除',
    unique key `uk_role_name` (`role_name`),
    key `idx_role_name` (`role_name`)
) comment '角色' collate = utf8mb4_unicode_ci;

-- 权限表
create table if not exists `permission`
(
    `id`              bigint auto_increment comment 'id' primary key,
    `permission_name` varchar(128)                       not null comment '权限名称',
    `status`          tinyint  default 1                 not null comment '状态 0-禁用 1-启用',
    `description`     varchar(256)                       null comment '权限描述',
    `create_time`     datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    `update_time`     datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    `is_delete`       tinyint  default 0                 not null comment '是否删除',
    unique key `idx_permission_name` (`permission_name`)
) comment '权限' collate = utf8mb4_unicode_ci;

-- 用户角色关联表
create table if not exists `user_role`
(
    `id`          bigint auto_increment comment 'id' primary key,
    `user_id`     bigint                             not null comment '用户 id',
    `role_id`     bigint                             not null comment '角色 id',
    `create_time` datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    unique key `uk_user_role` (`user_id`, `role_id`),
    index `idx_user_id` (`user_id`),
    index `idx_role_id` (`role_id`)
) comment '用户角色关联' collate = utf8mb4_unicode_ci;

-- 角色权限关联表
create table if not exists `role_permission`
(
    `id`            bigint auto_increment comment 'id' primary key,
    `role_id`       bigint                             not null comment '角色 id',
    `permission_id` bigint                             not null comment '权限 id',
    `create_time`   datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    unique key `uk_role_permission` (`role_id`, `permission_id`),
    index `idx_role_id` (`role_id`),
    index `idx_permission_id` (`permission_id`)
) comment '角色权限关联' collate = utf8mb4_unicode_ci;