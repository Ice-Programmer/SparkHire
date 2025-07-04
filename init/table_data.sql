use spark_hire;

-- 权限表相关语句
-- ========== 1. 账户与用户管理 ==========
INSERT INTO `permission` (`permission_name`, `description`)
VALUES ('account:register', '注册（求职者/HR）'),
       ('account:login', '登录'),
       ('account:logout', '登出'),
       ('account:pwdreset', '忘记密码重置'),
       ('user:view', '查看用户列表（管理员）'),
       ('user:detail', '查看用户详情'),
       ('user:update', '编辑用户资料'),
       ('user:disable', '冻结/解封账号'),
       ('user:delete', '逻辑删除用户');

-- ========== 2. 企业与职位管理 ==========
INSERT INTO `permission` (`permission_name`, `description`)
VALUES ('enterprise:apply', 'HR 企业认证上传执照'),
       ('enterprise:approve', '企业认证通过/驳回'),
       ('enterprise:view', '企业列表（管理员）'),
       ('job:create', '发布新职位'),
       ('job:update', '编辑职位'),
       ('job:delete', '下架/删除职位'),
       ('job:view', '查看职位详情'),
       ('job:list', '搜索/筛选职位'),
       ('job:recommend', '获取推荐职位列表'),
       ('job:favorite', '收藏职位'),
       ('job:unfavorite', '取消收藏职位');

-- ========== 3. 简历管理 ==========
INSERT INTO `permission` (`permission_name`, `description`)
VALUES ('resume:create', '新建简历'),
       ('resume:update', '编辑简历'),
       ('resume:view', '查看简历详情'),
       ('resume:preview', '简历实时预览'),
       ('resume:export', '导出 PDF 简历'),
       ('resume:version:list', '查看简历版本列表'),
       ('resume:version:create', '保存简历新版本'),
       ('resume:version:restore', '恢复历史简历版本'),
       ('resume:default:set', '设置默认投递简历');

-- ========== 4. AI 简历优化 ==========
INSERT INTO `permission` (`permission_name`, `description`)
VALUES ('ai:optimize:init', '触发简历优化任务'),
       ('ai:optimize:status', '查询优化任务状态'),
       ('ai:optimize:results', '获取优化匹配度及建议列表'),
       ('ai:optimize:accept', '接受改写建议'),
       ('ai:optimize:reject', '拒绝改写建议');

-- ========== 5. 智能推荐 ==========
INSERT INTO `permission` (`permission_name`, `description`)
VALUES ('rec:homepage:view', '查看首页推荐列表'),
       ('rec:feedback', '提交推荐反馈（不感兴趣/查看更多）'),
       ('rec:explain', '查看推荐理由');

-- ========== 6. 职位申请 ==========
INSERT INTO `permission` (`permission_name`, `description`)
VALUES ('application:create', '一键投递职位'),
       ('application:list', '查询投递记录'),
       ('application:detail', '查看投递详情'),
       ('application:cancel', '撤回投递'),
       ('application:reject', 'HR 拒绝并填写原因'),
       ('application:invite', 'HR 发起面试邀请');

-- ========== 7. 实时沟通（聊天） ==========
INSERT INTO `permission` (`permission_name`, `description`)
VALUES ('chat:conversation:list', '查看会话列表'),
       ('chat:conversation:create', '发起新会话'),
       ('chat:message:list', '获取消息历史'),
       ('chat:message:send', '发送聊天消息'),
       ('chat:message:read', '标记消息已读');

-- ========== 8. 知识图谱与职业路径 ==========
INSERT INTO `permission` (`permission_name`, `description`)
VALUES ('kg:skills:view', '查看技能图谱页面'),
       ('kg:skill:detail', '查看技能详情及相关职位'),
       ('kg:path:view', '查看职业路径推荐');

-- ========== 9. 数据统计与报表 ==========
INSERT INTO `permission` (`permission_name`, `description`)
VALUES ('stats:personal:view', '查看个人数据分析页'),
       ('stats:global:view', '查看全局数据报表页'),
       ('stats:personal:api', '获取个人统计数据'),
       ('stats:global:api', '获取全局统计数据');

-- ========== 10. 求职社区 ==========
INSERT INTO `permission` (`permission_name`, `description`)
VALUES ('community:posts:view', '查看社区首页'),
       ('community:post:create', '发布新帖'),
       ('community:post:view', '查看帖子详情'),
       ('community:post:edit', '编辑帖子'),
       ('community:post:delete', '删除帖子'),
       ('community:comment:add', '添加评论'),
       ('community:comment:reply', '回复评论'),
       ('community:like', '点赞帖子'),
       ('community:dislike', '点踩帖子'),
       ('community:post:collect', '收藏帖子');

-- ========== 11. 通知系统 ==========
INSERT INTO `permission` (`permission_name`, `description`)
VALUES ('notif:list', '列出通知（未读/已读）'),
       ('notif:read', '标记通知已读'),
       ('notif:settings:view', '查看通知设置'),
       ('notif:settings:update', '更新通知设置');

-- ========== 12. 后台管理与审核 ==========
INSERT INTO `permission` (`permission_name`, `description`)
VALUES ('admin:dashboard:view', '查看管理后台大盘'),
       ('admin:job:review', '职位审核（通过/驳回）'),
       ('admin:post:review', '帖子审核（通过/驳回）'),
       ('admin:reports:view', '查看举报处理列表'),
       ('admin:report:handle', '处理用户举报'),
       ('admin:user:ban', '后台冻结用户'),
       ('admin:user:unban', '后台解封用户');


-- ========== 1. 初始化角色 ==========

INSERT INTO `role` (`role_name`, `display_name`, `description`)
VALUES ('visitor', '访客', '未登录用户，只能浏览公开内容'),
       ('employee', '求职者', '普通求职用户，可以投递、管理简历'),
       ('employer', 'HR', '企业招聘用户，可以发布/管理职位'),
       ('admin', '管理员', '平台管理人员，负责审核与运营'),
       ('super-admin', '超级管理员', '最高权限用户，拥有所有操作');

-- ========== 2. 超级管理员：赋予所有权限 ==========

INSERT INTO `role_permission` (`role_id`, `permission_id`)
SELECT r.`id`, p.`id`
FROM `role` r
         CROSS JOIN `permission` p
WHERE r.`role_name` = 'super-admin';

-- ========== 3. 访客（visitor）：只读浏览权限 ==========

INSERT INTO `role_permission` (`role_id`, `permission_id`)
SELECT r.`id`, p.`id`
FROM `role` r
         JOIN `permission` p ON p.`permission_name` IN (
                                                        'job:list',
                                                        'job:view',
                                                        'community:posts:view',
                                                        'community:post:view'
    )
WHERE r.`role_name` = 'visitor';

-- ========== 4. 求职者（employee）：求职核心操作 ==========

INSERT INTO `role_permission` (`role_id`, `permission_id`)
SELECT r.`id`, p.`id`
FROM `role` r
         JOIN `permission` p ON p.`permission_name` IN (
                                                        'job:list',
                                                        'job:view',
                                                        'job:recommend',
                                                        'job:favorite',
                                                        'job:unfavorite',
                                                        'application:create',
                                                        'application:list',
                                                        'application:detail',
                                                        'resume:create',
                                                        'resume:update',
                                                        'resume:view',
                                                        'resume:preview',
                                                        'resume:export',
                                                        'resume:default:set',
                                                        'resume:version:list',
                                                        'resume:version:create',
                                                        'resume:version:restore',
                                                        'ai:optimize:init',
                                                        'ai:optimize:status',
                                                        'ai:optimize:results',
                                                        'ai:optimize:accept',
                                                        'ai:optimize:reject',
                                                        'chat:conversation:list',
                                                        'chat:conversation:create',
                                                        'chat:message:list',
                                                        'chat:message:send',
                                                        'chat:message:read'
    )
WHERE r.`role_name` = 'employee';

-- ========== 5. 企业用户（employer）：职位与企业管理 ==========

INSERT INTO `role_permission` (`role_id`, `permission_id`)
SELECT r.`id`, p.`id`
FROM `role` r
         JOIN `permission` p ON p.`permission_name` IN (
                                                        'enterprise:apply',
                                                        'enterprise:view',
                                                        'job:create',
                                                        'job:update',
                                                        'job:delete',
                                                        'job:list',
                                                        'job:view',
                                                        'application:list',
                                                        'application:detail',
                                                        'application:reject',
                                                        'application:invite',
                                                        'chat:conversation:list',
                                                        'chat:conversation:create',
                                                        'chat:message:list',
                                                        'chat:message:send',
                                                        'chat:message:read'
    )
WHERE r.`role_name` = 'employer';

-- ========== 6. 平台管理员（admin）：审核与运营权限 ==========

INSERT INTO `role_permission` (`role_id`, `permission_id`)
SELECT r.`id`, p.`id`
FROM `role` r
         JOIN `permission` p ON p.`permission_name` IN (
                                                        'user:view',
                                                        'user:detail',
                                                        'user:update',
                                                        'user:disable',
                                                        'user:delete',
                                                        'enterprise:view',
                                                        'enterprise:approve',
                                                        'admin:dashboard:view',
                                                        'admin:job:review',
                                                        'admin:post:review',
                                                        'admin:reports:view',
                                                        'admin:report:handle',
                                                        'admin:user:ban',
                                                        'admin:user:unban'
    )
WHERE r.`role_name` = 'admin';