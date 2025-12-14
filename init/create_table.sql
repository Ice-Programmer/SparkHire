-- 创建库
create database if not exists spark_hire;

-- 切换库
use spark_hire;

-- 用户表
create table if not exists `user`
(
    `id`          bigint auto_increment comment 'id' primary key,
    `username`    varchar(128)                       not null comment '用户昵称',
    `user_avatar` varchar(128)                       null comment '用户头像',
    `email`       varchar(256)                       not null comment '邮箱',
    `gender`      tinyint  default 1                 not null comment '0-女 1-男',
    `profile`     text     default ''                not null comment '自我评价',
    `status`      tinyint  default 0                 not null comment '用户状态(0-正常 1-封禁)',
    `create_time` datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    `update_time` datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    `is_delete`   tinyint  default 0                 not null comment '是否删除',
    unique key uk_email (`email`),
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

-- 用户权限表
create table if not exists `user_permission`
(
    `id`            bigint auto_increment comment 'id' primary key,
    `user_id`       bigint                             not null comment '用户 id',
    `permission_id` bigint                             not null comment '权限 id',
    `type`          tinyint  default 1                 not null comment '1=额外授予, -1=回收',
    `operation_id`  bigint                             not null comment '操作用户 id',
    `expire_time`   datetime                           null comment '过期时间',
    `create_time`   datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    `update_time`   datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    `is_delete`     tinyint  default 0                 not null comment '是否删除',
    index (`user_id`, `permission_id`)
) comment '用户权限表' collate = utf8mb4_unicode_ci;

-- 求职者表
create table if not exists `employee`
(
    `id`              bigint auto_increment comment 'id' primary key,
    `user_id`         bigint                                  not null comment '用户id',
    `age`             int           default 20                not null comment '年龄',
    `qualifications`  varchar(1024) default '[]'              not null comment '技能证书列表',
    `education`       int           default 1                 not null comment '最高学历',
    `graduation_year` int                                     not null comment '毕业年份',
    `job_status`      tinyint                                 not null comment '求职状态',
    `city_id`         bigint                                  not null comment '居住地',
    `latitude`        decimal(10, 7)                          null comment '纬度',
    `longitude`       decimal(10, 7)                          null comment '经度',
    `create_time`     datetime      default CURRENT_TIMESTAMP not null comment '创建时间',
    `update_time`     datetime      default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    `is_delete`       tinyint       default 0                 not null comment '是否删除',
    unique key `uk_user_id` (`user_id`),
    index idx_user_id (`user_id`)
) comment '求职者' collate = utf8mb4_unicode_ci;

-- tag 表
create table if not exists `tag`
(
    `id`             bigint auto_increment comment 'id' primary key,
    `tag_name`       varchar(256)                       not null comment '标签名称',
    `create_user_id` bigint                             not null comment '创建用户 id',
    `create_time`    datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    `update_time`    datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    unique key `uk_tag_name_del` (`tag_name`)
) comment 'tag 表' collate = utf8mb4_unicode_ci;

-- tag 关系表
create table if not exists `tag_obj_rel`
(
    `id`          bigint auto_increment comment 'id' primary key,
    `tag_id`      bigint                             not null comment 'tag id',
    `obj_id`      bigint                             not null comment 'obj_id',
    `obj_type`    int                                not null comment 'obj type(1-employee/2-recruitment)',
    `create_time` datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    unique key `uk_tag_obj` (`tag_id`, `obj_id`, `obj_type`),
    index `uk_obj_id_type` (`obj_id`, `obj_type`)
) comment 'tag_obj_rel' collate = utf8mb4_unicode_ci;

-- 行业表
create table if not exists `industry`
(
    `id`            bigint auto_increment comment 'id' primary key,
    `industry_name` varchar(256)                       not null comment '行业名称',
    `industry_type` int                                not null comment '行业类型',
    `post_num`      int      default 0                 not null comment '相关数量',
    `create_time`   datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    `update_time`   datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    `is_delete`     tinyint  default 0                 not null comment '是否删除'
) comment '行业' collate = utf8mb4_unicode_ci;

-- 专业表
create table if not exists `major`
(
    `id`          bigint auto_increment comment 'id' primary key,
    `major_name`  varchar(256)                       not null comment '专业名称',
    `post_num`    int      default 0                 not null comment '相关数量',
    `create_time` datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    `update_time` datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间'
) comment '专业' collate = utf8mb4_unicode_ci;

-- 学校表
create table if not exists `school`
(
    `id`          bigint auto_increment comment 'id' primary key,
    `school_name` varchar(256)                       not null comment '专业名称',
    `post_num`    int      default 0                 not null comment '相关数量',
    `create_time` datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    `update_time` datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间'
) comment '学校' collate = utf8mb4_unicode_ci;

-- 教育经历表
create table if not exists `education_experience`
(
    `id`             bigint auto_increment comment 'id' primary key,
    `user_id`        bigint                             not null comment '用户id',
    `school_id`      bigint                             not null comment '学校id',
    `education_type` tinyint                            not null comment '学历类型',
    `begin_year`     int                                not null comment '开始年份',
    `end_year`       int                                not null comment '结束年份',
    `major_id`       bigint                             not null comment '专业id',
    `activity`       text                               null comment '在校经历',
    `create_time`    datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    `update_time`    datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    `is_delete`      tinyint  default 0                 not null comment '是否删除',
    unique key uk_user_education_tye (`user_id`, `education_type`),
    index idx_user_id (user_id)
) comment '教育经历' collate = utf8mb4_unicode_ci;

-- 应聘者经历表
create table if not exists `employee_experience`
(
    `id`              bigint auto_increment comment 'id' primary key,
    `user_id`         bigint                             not null comment '用户id',
    `experience_name` varchar(256)                       not null comment '经历名称',
    `begin_time`      datetime                           not null comment '开始时间',
    `end_time`        datetime                           not null comment '结束时间',
    `job_role`        varchar(256)                       not null comment '担任职务',
    `description`     text                               not null comment '经历描述',
    `experience_type` tinyint                            not null comment '经历种类',
    `create_time`     datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    `update_time`     datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    `is_delete`       tinyint  default 0                 not null comment '是否删除',
    index idx_user_id (`user_id`)
) comment '应聘者经历';

-- 行业类型表
create table if not exists `industry_type`
(
    `id`                 bigint auto_increment comment 'id' primary key,
    `industry_type_name` varchar(256)                       not null comment '行业类型名称',
    `post_num`           int      default 0                 not null comment '相关数量',
    `create_time`        datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    `update_time`        datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    `is_delete`          tinyint  default 0                 not null comment '是否删除'
) comment '行业类型' collate = utf8mb4_unicode_ci;

-- 资格证书表
create table if not exists `qualification`
(
    `id`                 bigint auto_increment comment 'id' primary key,
    `qualification_name` varchar(256)                       not null comment '资格证书名称',
    `qualification_type` int                                not null comment '资格证书类型',
    `create_time`        datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    `update_time`        datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    `is_delete`          tinyint  default 0                 not null comment '是否删除'
) comment '资格证书' collate = utf8mb4_unicode_ci;

-- 职业表
create table if not exists `career`
(
    `id`          bigint auto_increment comment 'id' primary key,
    `career_name` varchar(256)                       not null comment '职业名称',
    `description` varchar(1024)                      null comment '职业介绍',
    `career_type` int                                not null comment '职业类型',
    `post_num`    int      default 0                 not null comment '相关数量',
    `create_time` datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    `update_time` datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    `is_delete`   tinyint  default 0                 not null comment '是否删除'
) comment '职业' collate = utf8mb4_unicode_ci;

-- 职业类型表
create table if not exists `career_type`
(
    `id`               bigint auto_increment comment 'id' primary key,
    `career_type_name` varchar(256)                       not null comment '职业类型名称',
    `post_num`         int      default 0                 not null comment '相关数量',
    `create_time`      datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    `update_time`      datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    `is_delete`        tinyint  default 0                 not null comment '是否删除'
) comment '职业类型表' collate = utf8mb4_unicode_ci;

-- 应聘者期望岗位
create table if not exists `employee_wish_career`
(
    `id`                 bigint auto_increment comment 'id' primary key,
    `user_id`            bigint                                 not null comment '用户id',
    `career_id`          bigint                                 not null comment '职业id',
    `industry_id`        bigint       default 0                 not null comment '行业id',
    `salary_expectation` varchar(256) default '-'               not null comment '薪水要求（例如：10-15,-面议）',
    `create_time`        datetime     default CURRENT_TIMESTAMP not null comment '创建时间',
    `update_time`        datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    `is_delete`          tinyint      default 0                 not null comment '是否删除',
    unique key uk_user_industry_career (`user_id`, `career_id`, `industry_id`),
    index idx_user_id (`user_id`)
) comment '应聘者期望岗位' collate = utf8mb4_unicode_ci;

-- 城市表
create table if not exists `city`
(
    `id`            bigint auto_increment comment 'id' primary key,
    `city_name`     varchar(128)                       not null comment '城市名称',
    `province_type` int                                not null comment '省份类型',
    `post_num`      int      default 0                 not null comment '相关数量',
    `create_time`   datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    `update_time`   datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    `is_delete`     tinyint  default 0                 not null comment '是否删除'
) comment '城市' collate = utf8mb4_unicode_ci;

-- 招聘信息表
create table if not exists recruitment
(
    `id`             bigint auto_increment comment 'id' primary key,
    `job_name`       varchar(512)                            not null comment '岗位招聘标题',
    `user_id`        bigint                                  not null comment '岗位发布者id',
    `company_id`     bigint                                  not null comment '公司id',
    `position_id`    bigint                                  not null comment '职业id',
    `industry_id`    bigint                                  not null comment '行业id',
    `description`    text                                    not null comment '职位详情',
    `education_type` tinyint                                 null comment '最低学历要求',
    `skill_tags`     varchar(1024) default '[]'              null comment '职业技术栈 JSON',
    `type`           int                                     not null comment '职业类型（实习、兼职、春招、社招）',
    `salary_upper`   int                                     null comment '薪水上限',
    `salary_lower`   int                                     null comment '薪水下限',
    `status`         tinyint       default 0                 not null comment '招聘状态 （0 - 招聘中 1 - 结束招聘）',
    `view_count`     int           default 0                 not null comment '浏览次数',
    `apply_count`    int           default 0                 not null comment '投递次数',
    `latitude`       decimal(10, 6)                          not null comment '纬度',
    `longitude`      decimal(10, 6)                          not null comment '经度',
    `city_id`        bigint                                  not null comment '工作城市 id',
    `work_address`   varchar(255)                            null comment '详细地址',
    `create_time`    datetime      default CURRENT_TIMESTAMP not null comment '创建时间',
    `update_time`    datetime      default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    `is_delete`      tinyint       default 0                 not null comment '是否删除',
    index idx_user_id (`user_id`),
    index idx_company_id (`company_id`)
) comment '招聘信息' collate = utf8mb4_unicode_ci;

-- 公司信息表
create table if not exists company
(
    `id`               bigint auto_increment comment 'id' primary key,
    `company_name`     varchar(256)                            not null comment '公司名称',
    `create_user_id`   bigint                                  not null comment '创建用户 id',
    `description`      text                                    not null comment '公司介绍',
    `post_num`         int           default 0                 not null comment '相关数量',
    `logo`             varchar(256)                            not null comment '公司 Logo',
    `background_image` varchar(256)                            null comment '公司背景图片',
    `company_images`   varchar(1024) default '[]'              null comment '公司图片',
    `industry_id`      bigint                                  not null comment '公司产业',
    `latitude`         decimal(10, 6)                          not null comment '纬度',
    `longitude`        decimal(10, 6)                          not null comment '经度',
    `city_id`          bigint                                  not null comment '工作城市 id',
    `address`          varchar(255)                            null comment '详细地址',
    `create_time`      datetime      default CURRENT_TIMESTAMP not null comment '创建时间',
    `update_time`      datetime      default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    `is_delete`        tinyint       default 0                 not null comment '是否删除'
) comment '公司信息' collate = utf8mb4_unicode_ci;
