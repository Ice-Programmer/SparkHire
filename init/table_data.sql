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

INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1, '中国人民大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2, '清华大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (3, '北京交通大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (4, '北京工业大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (5, '北京航空航天大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (6, '北京理工大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (7, '北京科技大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (8, '北方工业大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (9, '北京化工大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (10, '北京工商大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (11, '北京服装学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (12, '北京邮电大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (13, '北京印刷学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (14, '北京建筑大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (15, '北京石油化工学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (16, '北京电子科技学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (17, '中国农业大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (18, '北京农学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (19, '北京林业大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (20, '北京协和医学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (21, '首都医科大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (22, '北京中医药大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (23, '北京师范大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (24, '首都师范大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (25, '首都体育学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (26, '北京外国语大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (27, '北京第二外国语学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (28, '北京语言大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (29, '中国传媒大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (30, '中央财经大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (31, '对外经济贸易大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (32, '北京物资学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (33, '首都经济贸易大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (34, '中国消防救援学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (35, '外交学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (36, '中国人民公安大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (37, '国际关系学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (38, '北京体育大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (39, '中央音乐学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (40, '中国音乐学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (41, '中央美术学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (42, '中央戏剧学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (43, '中国戏曲学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (44, '北京电影学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (45, '北京舞蹈学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (46, '中央民族大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (47, '中国政法大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (48, '华北电力大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (49, '中华女子学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (50, '北京信息科技大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (51, '中国矿业大学（北京）', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (52, '中国石油大学（北京）', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (53, '中国地质大学（北京）', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (54, '北京联合大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (55, '北京城市学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (56, '中国青年政治学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (57, '首钢工学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (58, '中国劳动关系学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (59, '首都师范大学科德学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (60, '北京工商大学嘉华学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (61, '北京邮电大学世纪学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (62, '北京工业大学耿丹学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (63, '北京警察学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (64, '北京第二外国语学院中瑞酒店管理学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (65, '中国科学院大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (66, '中国社会科学院大学', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (67, '北京工业职业技术学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (68, '北京信息职业技术学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (69, '北京电子科技职业学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (70, '北京京北职业技术学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (71, '北京交通职业技术学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (72, '北京青年政治学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (73, '北京农业职业学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (74, '北京政法职业学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (75, '北京财贸职业学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (76, '北京北大方正软件职业技术学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (77, '北京经贸职业学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (78, '北京经济技术职业学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (79, '北京戏曲艺术职业学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (80, '北京汇佳职业学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (81, '北京科技经营管理学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (82, '北京科技职业学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (83, '北京培黎职业学院', 0, '2025-07-06 14:11:19', '2025-07-06 14:11:19');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (84, '北京经济管理职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (85, '北京劳动保障职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (86, '北京社会管理职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (87, '北京艺术传媒职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (88, '北京体育职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (89, '北京交通运输职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (90, '北京卫生职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (91, '北京网络职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (92, '南开大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (93, '天津大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (94, '天津科技大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (95, '天津工业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (96, '中国民航大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (97, '天津理工大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (98, '天津农学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (99, '天津医科大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (100, '天津中医药大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (101, '天津师范大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (102, '天津职业技术师范大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (103, '天津外国语大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (104, '天津商业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (105, '天津财经大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (106, '天津体育学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (107, '天津音乐学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (108, '天津美术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (109, '天津城建大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (110, '天津天狮学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (111, '天津中德应用技术大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (112, '天津外国语大学滨海外事学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (113, '天津传媒学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (114, '天津商业大学宝德学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (115, '天津医科大学临床医学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (116, '南开大学滨海学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (117, '天津师范大学津沽学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (118, '天津理工大学中环信息学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (119, '北京科技大学天津学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (120, '天津仁爱学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (121, '天津财经大学珠江学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (122, '天津市职业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (123, '天津滨海职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (124, '天津工程职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (125, '天津渤海职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (126, '天津电子信息职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (127, '天津机电职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (128, '天津现代职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (129, '天津公安警官职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (130, '天津轻工职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (131, '天津商务职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (132, '天津国土资源和房屋职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (133, '天津医学高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (134, '天津开发区职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (135, '天津艺术职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (136, '天津交通职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (137, '天津工业职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (138, '天津石油职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (139, '天津城市职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (140, '天津铁道职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (141, '天津工艺美术职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (142, '天津城市建设管理职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (143, '天津生物工程职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (144, '天津海运职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (145, '天津广播影视职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (146, '天津体育职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (147, '天津滨海汽车工程职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (148, '河北大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (149, '河北工程大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (150, '河北地质大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (151, '河北工业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (152, '华北理工大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (153, '河北科技大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (154, '河北建筑工程学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (155, '河北水利电力学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (156, '河北农业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (157, '河北医科大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (158, '河北北方学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (159, '承德医学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (160, '河北师范大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (161, '保定学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (162, '河北民族师范学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (163, '唐山师范学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (164, '廊坊师范学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (165, '衡水学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (166, '石家庄学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (167, '邯郸学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (168, '邢台学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (169, '沧州师范学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (170, '石家庄铁道大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (171, '燕山大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (172, '河北科技师范学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (173, '唐山学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (174, '华北科技学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (175, '中国人民警察大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (176, '河北体育学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (177, '河北金融学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (178, '北华航天工业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (179, '防灾科技学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (180, '河北经贸大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (181, '中央司法警官学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (182, '河北传媒学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (183, '河北工程技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (184, '河北美术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (185, '河北科技学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (186, '河北外国语学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (187, '河北大学工商学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (188, '华北理工大学轻工学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (189, '河北工业职业技术大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (190, '河北师范大学汇华学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (191, '河北经贸大学经济管理学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (192, '河北医科大学临床学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (193, '河北科技工程职业技术大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (194, '河北工程大学科信学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (195, '河北石油职业技术大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (196, '燕山大学里仁学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (197, '石家庄铁道大学四方学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (198, '河北地质大学华信学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (199, '河北农业大学现代科技学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (200, '华北理工大学冀唐学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (201, '保定理工学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (202, '燕京理工学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (203, '北京中医药大学东方学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (204, '沧州交通学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (205, '河北东方学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (206, '河北中医药大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (207, '张家口学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (208, '河北环境工程学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (209, '邯郸职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (210, '石家庄职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (211, '张家口职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (212, '河北软件职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (213, '河北石油职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (214, '河北建材职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (215, '河北政法职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (216, '沧州职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (217, '河北能源职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (218, '石家庄铁路职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (219, '保定职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (220, '秦皇岛职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (221, '石家庄工程职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (222, '石家庄城市经济职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (223, '唐山职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (224, '衡水职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (225, '唐山工业职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (226, '邢台医学高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (227, '河北艺术职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (228, '河北旅游职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (229, '石家庄财经职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (230, '河北交通职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (231, '河北化工医药职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (232, '石家庄信息工程职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (233, '河北对外经贸职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (234, '保定电力职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (235, '河北机电职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (236, '渤海石油职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (237, '廊坊职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (238, '唐山科技职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (239, '石家庄邮电职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (240, '河北公安警察职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (241, '石家庄工商职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (242, '石家庄理工职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (243, '石家庄科技信息职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (244, '河北司法警官职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (245, '沧州医学高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (246, '河北女子职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (247, '石家庄医学高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (248, '石家庄经济职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (249, '冀中职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (250, '石家庄人民医学高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (251, '河北正定师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (252, '河北劳动关系职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (253, '石家庄科技职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (254, '沧州幼儿师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (255, '宣化科技职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (256, '廊坊燕京职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (257, '承德护理职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (258, '石家庄幼儿师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (259, '廊坊卫生职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (260, '河北轨道运输职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (261, '保定幼儿师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (262, '河北工艺美术职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (263, '渤海理工职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (264, '唐山幼儿师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (265, '曹妃甸职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (266, '承德应用技术职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (267, '邯郸幼儿师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (268, '邯郸科技职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (269, '唐山海运职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (270, '邢台应用技术职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (271, '河北资源环境职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (272, '衡水健康科技职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (273, '沧州航空职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (274, '邯郸应用技术职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (275, '秦皇岛工业职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (276, '山西大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (277, '太原科技大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (278, '中北大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (279, '太原理工大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (280, '山西农业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (281, '山西医科大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (282, '长治医学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (283, '山西师范大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (284, '太原师范学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (285, '山西大同大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (286, '晋中学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (287, '长治学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (288, '运城学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (289, '忻州师范学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (290, '山西财经大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (291, '山西中医药大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (292, '吕梁学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (293, '太原学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (294, '山西警察学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (295, '山西应用科技学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (296, '山西工程科技职业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (297, '山西工学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (298, '晋中信息学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (299, '山西师范大学现代文理学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (300, '山西晋中理工学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (301, '山西科技学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (302, '山西医科大学晋祠学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (303, '山西财经大学华商学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (304, '山西工商学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (305, '太原工业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (306, '运城职业技术大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (307, '山西传媒学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (308, '山西工程技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (309, '山西能源学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (310, '山西省财政税务专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (311, '长治职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (312, '山西艺术职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (313, '晋城职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (314, '山西药科职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (315, '大同煤炭职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (316, '山西机电职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (317, '山西财贸职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (318, '山西林业职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (319, '山西水利职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (320, '阳泉职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (321, '临汾职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (322, '山西职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (323, '山西金融职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (324, '太原城市职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (325, '山西信息职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (326, '山西体育职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (327, '山西警官职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (328, '山西国际商务职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (329, '潞安职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (330, '太原旅游职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (331, '山西旅游职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (332, '山西管理职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (333, '山西电力职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (334, '忻州职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (335, '山西同文职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (336, '晋中职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (337, '山西华澳商贸职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (338, '山西运城农业职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (339, '运城幼儿师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (340, '山西老区职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (341, '山西经贸职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (342, '朔州职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (343, '山西铁道职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (344, '晋中师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (345, '阳泉师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (346, '山西青年职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (347, '运城护理职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (348, '运城师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (349, '朔州师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (350, '吕梁职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (351, '大同师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (352, '太原幼儿师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (353, '山西工程职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (354, '长治幼儿师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (355, '山西通用航空职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (356, '朔州陶瓷职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (357, '山西卫生健康职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (358, '吕梁师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (359, '内蒙古大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (360, '内蒙古科技大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (361, '内蒙古工业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (362, '内蒙古农业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (363, '内蒙古医科大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (364, '内蒙古师范大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (365, '内蒙古民族大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (366, '赤峰学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (367, '内蒙古财经大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (368, '呼伦贝尔学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (369, '集宁师范学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (370, '河套学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (371, '呼和浩特民族学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (372, '内蒙古大学创业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (373, '内蒙古鸿德文理学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (374, '内蒙古艺术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (375, '鄂尔多斯应用技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (376, '内蒙古建筑职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (377, '内蒙古丰州职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (378, '包头职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (379, '兴安职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (380, '呼和浩特职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (381, '包头轻工职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (382, '内蒙古电子信息职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (383, '内蒙古机电职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (384, '内蒙古化工职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (385, '内蒙古商贸职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (386, '锡林郭勒职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (387, '内蒙古警察职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (388, '内蒙古体育职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (389, '乌兰察布职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (390, '通辽职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (391, '科尔沁艺术职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (392, '内蒙古交通职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (393, '包头钢铁职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (394, '乌海职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (395, '内蒙古科技职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (396, '内蒙古北方职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (397, '赤峰职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (398, '内蒙古经贸外语职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (399, '包头铁道职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (400, '乌兰察布医学高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (401, '鄂尔多斯职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (402, '内蒙古工业职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (403, '呼伦贝尔职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (404, '满洲里俄语职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (405, '内蒙古能源职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (406, '赤峰工业职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (407, '阿拉善职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (408, '内蒙古美术职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (409, '内蒙古民族幼儿师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (410, '鄂尔多斯生态环境职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (411, '扎兰屯职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (412, '赤峰应用技术职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (413, '辽宁大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (414, '大连理工大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (415, '沈阳工业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (416, '沈阳航空航天大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (417, '沈阳理工大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (418, '东北大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (419, '辽宁科技大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (420, '辽宁工程技术大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (421, '辽宁石油化工大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (422, '沈阳化工大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (423, '大连交通大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (424, '大连海事大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (425, '大连工业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (426, '沈阳建筑大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (427, '辽宁工业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (428, '沈阳农业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (429, '大连海洋大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (430, '中国医科大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (431, '锦州医科大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (432, '大连医科大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (433, '辽宁中医药大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (434, '沈阳药科大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (435, '沈阳医学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (436, '辽宁师范大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (437, '沈阳师范大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (438, '渤海大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (439, '鞍山师范学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (440, '大连外国语大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (441, '东北财经大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (442, '中国刑事警察学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (443, '沈阳体育学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (444, '沈阳音乐学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (445, '鲁迅美术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (446, '辽宁对外经贸学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (447, '沈阳大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (448, '大连大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (449, '辽宁科技学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (450, '辽宁警察学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (451, '沈阳工程学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (452, '辽东学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (453, '大连民族大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (454, '辽宁理工职业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (455, '大连理工大学城市学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (456, '沈阳工业大学工程学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (457, '沈阳航空航天大学北方科技学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (458, '沈阳工学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (459, '大连工业大学艺术与信息工程学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (460, '大连科技学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (461, '沈阳城市建设学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (462, '大连医科大学中山学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (463, '锦州医科大学医疗学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (464, '辽宁师范大学海华学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (465, '辽宁理工学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (466, '大连财经学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (467, '沈阳城市学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (468, '大连艺术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (469, '辽宁中医药大学杏林学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (470, '辽宁何氏医学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (471, '沈阳科技学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (472, '大连东软信息学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (473, '辽宁财贸学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (474, '辽宁传媒学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (475, '营口理工学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (476, '朝阳师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (477, '抚顺师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (478, '锦州师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (479, '营口职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (480, '铁岭师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (481, '大连职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (482, '辽宁农业职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (483, '抚顺职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (484, '辽阳职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (485, '阜新高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (486, '辽宁省交通高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (487, '辽宁税务高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (488, '盘锦职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (489, '沈阳航空职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (490, '辽宁体育运动职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (491, '辽宁职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (492, '辽宁生态工程职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (493, '沈阳职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (494, '大连商务职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (495, '辽宁金融职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (496, '辽宁轨道交通职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (497, '辽宁广告职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (498, '辽宁机电职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (499, '辽宁经济职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (500, '辽宁石化职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (501, '渤海船舶职业学院 ', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (502, '大连软件职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (503, '大连翻译职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (504, '辽宁商贸职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (505, '大连枫叶职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (506, '辽宁装备制造职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (507, '辽河石油职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (508, '辽宁地质工程职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (509, '辽宁铁道职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (510, '辽宁建筑职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (511, '大连航运职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (512, '大连装备制造职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (513, '大连汽车职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (514, '辽宁现代服务职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (515, '辽宁冶金职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (516, '辽宁工程职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (517, '辽宁城市建设职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (518, '辽宁医药职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (519, '铁岭卫生职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (520, '沈阳北软信息职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (521, '辽宁政法职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (522, '辽宁民族师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (523, '辽宁轻工职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (524, '辽宁特殊教育师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (525, '辽宁师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (526, '鞍山职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (527, '吉林大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (528, '延边大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (529, '长春理工大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (530, '东北电力大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (531, '长春工业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (532, '吉林建筑大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (533, '吉林化工学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (534, '吉林农业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (535, '长春中医药大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (536, '东北师范大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (537, '北华大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (538, '通化师范学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (539, '吉林师范大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (540, '吉林工程技术师范学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (541, '长春师范大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (542, '白城师范学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (543, '吉林财经大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (544, '吉林体育学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (545, '吉林艺术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (546, '吉林外国语大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (547, '吉林工商学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (548, '长春工程学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (549, '吉林农业科技学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (550, '吉林警察学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (551, '长春大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (552, '长春光华学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (553, '长春工业大学人文信息学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (554, '长春电子科技学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (555, '长春财经学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (556, '吉林建筑科技学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (557, '长春建筑学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (558, '长春科技学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (559, '吉林动画学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (560, '吉林师范大学博达学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (561, '长春大学旅游学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (562, '长春人文学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (563, '吉林医药学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (564, '长春师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (565, '辽源职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (566, '四平职业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (567, '长春汽车工业高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (568, '长春金融高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (569, '长春医学高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (570, '吉林交通职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (571, '长春东方职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (572, '吉林司法警官职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (573, '吉林电子信息职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (574, '吉林工业职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (575, '吉林工程职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (576, '长春职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (577, '白城医学高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (578, '长春信息技术职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (579, '松原职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (580, '吉林铁道职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (581, '白城职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (582, '长白山职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (583, '吉林科技职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (584, '延边职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (585, '吉林城市职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (586, '吉林职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (587, '吉林水利电力职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (588, '长春健康职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (589, '长春早期教育职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (590, '梅河口康美职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (591, '吉林通用航空职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (592, '通化医药健康职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (593, '黑龙江大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (594, '哈尔滨工业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (595, '哈尔滨理工大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (596, '哈尔滨工程大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (597, '黑龙江科技大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (598, '东北石油大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (599, '佳木斯大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (600, '黑龙江八一农垦大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (601, '东北农业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (602, '东北林业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (603, '哈尔滨医科大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (604, '黑龙江中医药大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (605, '牡丹江医学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (606, '哈尔滨师范大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (607, '齐齐哈尔大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (608, '牡丹江师范学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (609, '哈尔滨学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (610, '大庆师范学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (611, '绥化学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (612, '哈尔滨商业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (613, '哈尔滨体育学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (614, '哈尔滨金融学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (615, '齐齐哈尔医学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (616, '黑龙江工业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (617, '黑龙江东方学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (618, '哈尔滨信息工程学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (619, '黑龙江工程学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (620, '齐齐哈尔工程学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (621, '黑龙江外国语学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (622, '黑龙江财经学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (623, '哈尔滨石油学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (624, '黑龙江工商学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (625, '哈尔滨远东理工学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (626, '哈尔滨剑桥学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (627, '黑龙江工程学院昆仑旅游学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (628, '哈尔滨广厦学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (629, '哈尔滨华德学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (630, '黑河学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (631, '哈尔滨音乐学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (632, '齐齐哈尔高等师范专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (633, '伊春职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (634, '牡丹江大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (635, '黑龙江职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (636, '黑龙江建筑职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (637, '黑龙江艺术职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (638, '大庆职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (639, '黑龙江林业职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (640, '黑龙江农业职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (641, '黑龙江农业工程职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (642, '黑龙江农垦职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (643, '黑龙江司法警官职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (644, '鹤岗师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (645, '哈尔滨电力职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (646, '哈尔滨铁道职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (647, '大兴安岭职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (648, '黑龙江农业经济职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (649, '哈尔滨职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (650, '哈尔滨传媒职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (651, '黑龙江商业职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (652, '黑龙江公安警官职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (653, '哈尔滨城市职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (654, '黑龙江旅游职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (655, '黑龙江三江美术职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (656, '黑龙江生态工程职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (657, '黑龙江能源职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (658, '七台河职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (659, '黑龙江民族职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (660, '大庆医学高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (661, '黑龙江交通职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (662, '哈尔滨应用职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (663, '黑龙江幼儿师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (664, '哈尔滨科学技术职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (665, '佳木斯职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (666, '黑龙江护理高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (667, '齐齐哈尔理工职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (668, '哈尔滨幼儿师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (669, '黑龙江冰雪体育职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (670, '哈尔滨北方航空职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (671, '复旦大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (672, '同济大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (673, '上海交通大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (674, '华东理工大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (675, '上海理工大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (676, '上海海事大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (677, '东华大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (678, '上海电力大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (679, '上海应用技术大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (680, '上海健康医学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (681, '上海海洋大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (682, '上海中医药大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (683, '华东师范大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (684, '上海师范大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (685, '上海外国语大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (686, '上海财经大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (687, '上海对外经贸大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (688, '上海海关学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (689, '华东政法大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (690, '上海体育大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (691, '上海音乐学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (692, '上海戏剧学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (693, '上海大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (694, '上海公安学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (695, '上海工程技术大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (696, '上海立信会计金融学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (697, '上海电机学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (698, '上海杉达学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (699, '上海政法学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (700, '上海第二工业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (701, '上海商学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (702, '上海立达学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (703, '上海建桥学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (704, '上海兴伟学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (705, '上海中侨职业技术大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (706, '上海视觉艺术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (707, '上海外国语大学贤达经济人文学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (708, '上海师范大学天华学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (709, '上海科技大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (710, '上海纽约大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (711, '上海旅游高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (712, '上海东海职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (713, '上海工商职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (714, '上海出版印刷高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (715, '上海行健职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (716, '上海城建职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (717, '上海交通职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (718, '上海海事职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (719, '上海电子信息职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (720, '上海震旦职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (721, '上海民远职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (722, '上海欧华职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (723, '上海思博职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (724, '上海工艺美术职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (725, '上海济光职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (726, '上海工商外国语职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (727, '上海科学技术职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (728, '上海农林职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (729, '上海邦德职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (730, '上海电影艺术职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (731, '上海中华职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (732, '上海工会管理职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (733, '上海民航职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (734, '上海南湖职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (735, '上海科创职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (736, '上海闵行职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (737, '上海现代化工职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (738, '上海建设管理职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (739, '南京大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (740, '苏州大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (741, '东南大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (742, '南京航空航天大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (743, '南京理工大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (744, '江苏科技大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (745, '中国矿业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (746, '南京工业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (747, '常州大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (748, '南京邮电大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (749, '河海大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (750, '江南大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (751, '南京林业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (752, '江苏大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (753, '南京信息工程大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (754, '南通大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (755, '盐城工学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (756, '南京农业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (757, '南京医科大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (758, '徐州医科大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (759, '南京中医药大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (760, '中国药科大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (761, '南京师范大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (762, '江苏师范大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (763, '淮阴师范学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (764, '盐城师范学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (765, '南京财经大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (766, '江苏警官学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (767, '南京体育学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (768, '南京艺术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (769, '苏州科技大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (770, '常熟理工学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (771, '南京工业职业技术大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (772, '淮阴工学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (773, '常州工学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (774, '扬州大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (775, '三江学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (776, '南京工程学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (777, '南京审计大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (778, '南京晓庄学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (779, '江苏理工学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (780, '江苏海洋大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (781, '徐州工程学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (782, '南京特殊教育师范学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (783, '南通理工学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (784, '南京警察学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (785, '东南大学成贤学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (786, '泰州学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (787, '无锡太湖学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (788, '金陵科技学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (789, '中国矿业大学徐海学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (790, '南京大学金陵学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (791, '南京理工大学紫金学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (792, '南京航空航天大学金城学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (793, '南京传媒学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (794, '南京理工大学泰州科技学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (795, '南京师范大学泰州学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (796, '南京工业大学浦江学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (797, '南京师范大学中北学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (798, '南京医科大学康达学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (799, '南京中医药大学翰林学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (800, '无锡学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (801, '苏州城市学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (802, '苏州大学应用技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (803, '苏州科技大学天平学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (804, '江苏大学京江学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (805, '扬州大学广陵学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (806, '江苏师范大学科文学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (807, '南京邮电大学通达学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (808, '南京财经大学红山学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (809, '江苏科技大学苏州理工学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (810, '常州大学怀德学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (811, '南通大学杏林学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (812, '南京审计大学金审学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (813, '宿迁学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (814, '江苏第二师范学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (815, '西交利物浦大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (816, '昆山杜克大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (817, '盐城幼儿师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (818, '苏州幼儿师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (819, '明达职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (820, '无锡职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (821, '江苏建筑职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (822, '江苏工程职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (823, '苏州工艺美术职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (824, '连云港职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (825, '镇江市高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (826, '南通职业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (827, '苏州市职业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (828, '沙洲职业工学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (829, '扬州市职业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (830, '连云港师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (831, '江苏经贸职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (832, '九州职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (833, '硅湖职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (834, '泰州职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (835, '常州信息职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (836, '江苏联合职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (837, '江苏海事职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (838, '应天职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (839, '无锡科技职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (840, '江苏医药职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (841, '扬州环境资源职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (842, '南通科技职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (843, '苏州经贸职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (844, '苏州工业职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (845, '苏州托普信息职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (846, '苏州卫生职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (847, '无锡商业职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (848, '江苏航运职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (849, '南京交通职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (850, '江苏电子信息职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (851, '江苏农牧科技职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (852, '常州纺织服装职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (853, '苏州农业职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (854, '苏州工业园区职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (855, '太湖创意职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (856, '炎黄职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (857, '南京科技职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (858, '正德职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (859, '钟山职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (860, '无锡南洋职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (861, '江南影视艺术职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (862, '金肯职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (863, '常州工业职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (864, '常州工程职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (865, '江苏农林职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (866, '江苏食品药品职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (867, '建东职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (868, '南京铁道职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (869, '徐州工业职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (870, '江苏信息职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (871, '宿迁职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (872, '南京信息职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (873, '江海职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (874, '常州机电职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (875, '江阴职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (876, '无锡城市职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (877, '无锡工艺职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (878, '金山职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (879, '苏州健雄职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (880, '盐城工业职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (881, '江苏财经职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (882, '扬州工业职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (883, '苏州百年职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (884, '昆山登云科技职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (885, '南京视觉艺术职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (886, '江苏城市职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (887, '南京城市职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (888, '南京机电职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (889, '苏州高博软件技术职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (890, '南京旅游职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (891, '江苏卫生健康职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (892, '苏州信息职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (893, '宿迁泽达职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (894, '苏州工业园区服务外包职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (895, '徐州幼儿师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (896, '徐州生物工程职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (897, '江苏商贸职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (898, '南通师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (899, '扬州中瑞酒店职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (900, '江苏护理职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (901, '江苏财会职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (902, '江苏城乡建设职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (903, '江苏航空职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (904, '江苏安全技术职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (905, '江苏旅游职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (906, '常州幼儿师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (907, '浙江大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (908, 'XXXX大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (909, '浙江工业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (910, '浙江理工大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (911, '浙江海洋大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (912, '浙江农林大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (913, '温州医科大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (914, '浙江中医药大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (915, '浙江师范大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (916, '杭州师范大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (917, '湖州师范学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (918, '绍兴文理学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (919, '台州学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (920, '温州大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (921, '丽水学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (922, '浙江工商大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (923, '嘉兴学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (924, '中国美术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (925, '中国计量大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (926, '浙江万里学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (927, '浙江科技学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (928, '宁波工程学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (929, '浙江水利水电学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (930, '浙江财经大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (931, '浙江警察学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (932, '衢州学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (933, '宁波大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (934, '浙江传媒学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (935, '浙江树人学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (936, '浙江越秀外国语学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (937, '宁波财经学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (938, '浙大城市学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (939, '浙大宁波理工学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (940, '杭州医学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (941, '浙江广厦建设职业技术大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (942, '浙江工业大学之江学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (943, '浙江师范大学行知学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (944, '宁波大学科学技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (945, '杭州电子科技大学信息工程学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (946, '杭州电子科技大学', 0, '2025-07-06 14:11:20', '2025-07-07 21:51:05');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (947, '浙江农林大学暨阳学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (948, '温州医科大学仁济学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (949, '浙江中医药大学滨江学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (950, '杭州师范大学钱江学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (951, '湖州学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (952, '绍兴文理学院元培学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (953, '温州理工学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (954, '浙江工商大学杭州商学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (955, '嘉兴南湖学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (956, '中国计量大学现代科技学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (957, '浙江财经大学东方学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (958, '温州商学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (959, '同济大学浙江学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (960, '上海财经大学浙江学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (961, '浙江外国语学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (962, '浙江音乐学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (963, '西湖大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (964, '浙江药科职业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (965, '宁波诺丁汉大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (966, '温州肯恩大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (967, '宁波职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (968, '温州职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (969, '浙江交通职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (970, '金华职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (971, '宁波城市职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (972, '浙江电力职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (973, '浙江同济科技职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (974, '浙江工商职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (975, '台州职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (976, '浙江工贸职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (977, '浙江机电职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (978, '浙江建设职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (979, '浙江艺术职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (980, '浙江经贸职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (981, '浙江商业职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (982, '浙江经济职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (983, '浙江旅游职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (984, '浙江育英职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (985, '浙江警官职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (986, '浙江金融职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (987, '浙江工业职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (988, '杭州职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (989, '嘉兴职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (990, '湖州职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (991, '绍兴职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (992, '衢州职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (993, '丽水职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (994, '浙江东方职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (995, '义乌工商职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (996, '浙江纺织服装职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (997, '杭州科技职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (998, '浙江长征职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (999, '嘉兴南洋职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1000, '杭州万向职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1001, '浙江邮电职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1002, '宁波卫生职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1003, '台州科技职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1004, '浙江国际海运职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1005, '浙江体育职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1006, '温州科技职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1007, '浙江汽车职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1008, '浙江横店影视职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1009, '浙江农业商贸职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1010, '浙江特殊教育职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1011, '浙江安防职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1012, '浙江宇翔职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1013, '浙江金华科贸职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1014, '浙江舟山群岛新区旅游与健康职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1015, '宁波幼儿师范高等专科学校', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1016, '安徽大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1017, '中国科学技术大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1018, '合肥工业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1019, '安徽工业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1020, '安徽理工大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1021, '安徽工程大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1022, '安徽农业大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1023, '安徽医科大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1024, '蚌埠医学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1025, '皖南医学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1026, '安徽中医药大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1027, '安徽师范大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1028, '阜阳师范大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1029, '安庆师范大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1030, '淮北师范大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1031, '黄山学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1032, '皖西学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1033, '滁州学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1034, '安徽财经大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1035, '宿州学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1036, '巢湖学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1037, '淮南师范学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1038, '铜陵学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1039, '安徽建筑大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1040, '安徽科技学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1041, '安徽三联学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1042, '合肥学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1043, '蚌埠学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1044, '池州学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1045, '安徽新华学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1046, '安徽文达信息工程学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1047, '亳州学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1048, '安徽外国语学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1049, '蚌埠工商学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1050, '安徽大学江淮学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1051, '安徽信息工程学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1052, '马鞍山学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1053, '合肥城市学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1054, '合肥经济学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1055, '安徽师范大学皖江学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1056, '安徽医科大学临床医学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1057, '阜阳师范大学信息工程学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1058, '淮北理工学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1059, '合肥师范学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1060, '皖江工学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1061, '安徽艺术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1062, '安徽职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1063, '淮北职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1064, '芜湖职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1065, '淮南联合大学', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1066, '安徽商贸职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1067, '安徽水利水电职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1068, '阜阳职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1069, '铜陵职业技术学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1070, '民办万博科技职业学院', 0, '2025-07-06 14:11:20', '2025-07-06 14:11:20');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1071, '安徽警官职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1072, '淮南职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1073, '安徽工业经济职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1074, '合肥通用职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1075, '安徽工贸职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1076, '宿州职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1077, '六安职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1078, '安徽电子信息职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1079, '民办合肥经济技术职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1080, '安徽交通职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1081, '安徽体育运动职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1082, '安徽中医药高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1083, '安徽医学高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1084, '合肥职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1085, '滁州职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1086, '池州职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1087, '宣城职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1088, '安徽广播影视职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1089, '民办合肥滨湖职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1090, '安徽电气工程职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1091, '安徽冶金科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1092, '安徽城市管理职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1093, '安徽机电职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1094, '安徽工商职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1095, '安徽中澳科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1096, '阜阳科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1097, '亳州职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1098, '安徽国防科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1099, '安庆职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1100, '安徽艺术职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1101, '马鞍山师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1102, '安徽财贸职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1103, '安徽国际商务职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1104, '安徽公安职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1105, '安徽林业职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1106, '安徽审计职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1107, '安徽新闻出版职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1108, '安徽邮电职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1109, '安徽工业职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1110, '民办合肥财经职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1111, '安庆医药高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1112, '安徽涉外经济职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1113, '安徽绿海商务职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1114, '合肥共达职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1115, '蚌埠经济技术职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1116, '民办安徽旅游职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1117, '徽商职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1118, '马鞍山职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1119, '安徽现代信息工程职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1120, '安徽矿业职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1121, '合肥信息技术职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1122, '桐城师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1123, '黄山职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1124, '滁州城市职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1125, '安徽汽车职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1126, '皖西卫生职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1127, '合肥幼儿师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1128, '安徽扬子职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1129, '安徽黄梅戏艺术职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1130, '安徽粮食工程职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1131, '安徽卫生健康职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1132, '合肥科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1133, '皖北卫生职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1134, '阜阳幼儿师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1135, '黄山健康职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1136, '宿州航空职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1137, '厦门大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1138, '华侨大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1139, '福州大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1140, '福建理工大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1141, '福建农林大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1142, '集美大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1143, '福建医科大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1144, '福建中医药大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1145, '福建师范大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1146, '闽江学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1147, '武夷学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1148, '宁德师范学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1149, '泉州师范学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1150, '闽南师范大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1151, '厦门理工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1152, '三明学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1153, '龙岩学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1154, '福建商学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1155, '福建警察学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1156, '莆田学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1157, '仰恩大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1158, '厦门医学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1159, '厦门华厦学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1160, '闽南理工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1161, '泉州职业技术大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1162, '闽南科技学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1163, '福州工商学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1164, '厦门工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1165, '阳光学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1166, '厦门大学嘉庚学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1167, '福州大学至诚学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1168, '集美大学诚毅学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1169, '福建师范大学协和学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1170, '福州外语外贸学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1171, '福建江夏学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1172, '泉州信息工程学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1173, '福州理工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1174, '福建农林大学金山学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1175, '福建技术师范学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1176, '福建船政交通职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1177, '漳州职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1178, '闽西职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1179, '黎明职业大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1180, '福建华南女子职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1181, '福州职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1182, '福建林业职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1183, '福建信息职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1184, '福建水利电力职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1185, '福建电力职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1186, '厦门海洋职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1187, '福建农业职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1188, '福建卫生职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1189, '泉州医学高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1190, '福州英华职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1191, '泉州纺织服装职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1192, '泉州华光职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1193, '闽北职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1194, '福州黎明职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1195, '厦门演艺职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1196, '厦门华天涉外职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1197, '福州科技职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1198, '泉州经贸职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1199, '福建对外经济贸易职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1200, '湄洲湾职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1201, '福建生物工程职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1202, '福建艺术职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1203, '福建幼儿师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1204, '厦门城市职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1205, '泉州工艺美术职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1206, '三明医学科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1207, '宁德职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1208, '福州软件职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1209, '厦门兴才职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1210, '厦门软件职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1211, '福建体育职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1212, '漳州城市职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1213, '厦门南洋职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1214, '厦门东海职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1215, '漳州科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1216, '漳州理工职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1217, '武夷山职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1218, '漳州卫生职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1219, '泉州海洋职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1220, '泉州轻工职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1221, '厦门安防科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1222, '泉州幼儿师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1223, '闽江师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1224, '泉州工程职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1225, '福州墨尔本理工职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1226, '南昌大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1227, '华东交通大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1228, '东华理工大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1229, '南昌航空大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1230, '江西理工大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1231, '景德镇陶瓷大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1232, '江西农业大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1233, '江西中医药大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1234, '赣南医学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1235, '江西师范大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1236, '上饶师范学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1237, '宜春学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1238, '赣南师范大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1239, '井冈山大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1240, '江西财经大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1241, '江西科技学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1242, '景德镇学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1243, '萍乡学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1244, '江西科技师范大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1245, '南昌工程学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1246, '江西警察学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1247, '新余学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1248, '九江学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1249, '江西工程学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1250, '南昌理工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1251, '江西应用科技学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1252, '江西服装学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1253, '南昌职业大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1254, '南昌工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1255, '南昌大学科学技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1256, '南昌大学共青学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1257, '南昌交通学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1258, '赣东学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1259, '南昌航空大学科技学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1260, '赣南科技学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1261, '景德镇艺术职业大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1262, '江西农业大学南昌商学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1263, '南昌医学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1264, '江西师范大学科学技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1265, '赣南师范大学科技学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1266, '南昌应用技术师范学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1267, '江西财经大学现代经济管理学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1268, '豫章师范学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1269, '江西软件职业技术大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1270, '南昌师范学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1271, '上饶幼儿师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1272, '抚州幼儿师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1273, '江西工业职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1274, '江西医学高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1275, '九江职业大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1276, '九江职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1277, '江西司法警官职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1278, '江西陶瓷工艺美术职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1279, '江西旅游商贸职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1280, '江西电力职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1281, '江西环境工程职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1282, '江西艺术职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1283, '鹰潭职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1284, '江西信息应用职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1285, '江西交通职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1286, '江西财经职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1287, '江西应用技术职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1288, '江西现代职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1289, '江西工业工程职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1290, '江西机电职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1291, '江西科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1292, '江西外语外贸职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1293, '江西工业贸易职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1294, '宜春职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1295, '江西应用工程职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1296, '江西生物科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1297, '江西建设职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1298, '抚州职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1299, '江西中医药高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1300, '江西经济管理职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1301, '江西制造职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1302, '江西工程职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1303, '江西青年职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1304, '上饶职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1305, '江西航空职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1306, '江西农业工程职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1307, '赣西科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1308, '江西卫生职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1309, '江西新能源科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1310, '江西枫林涉外经贸职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1311, '江西泰豪动漫职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1312, '江西冶金职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1313, '江西管理职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1314, '江西传媒职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1315, '江西工商职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1316, '景德镇陶瓷职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1317, '共青科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1318, '赣州师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1319, '江西水利职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1320, '宜春幼儿师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1321, '吉安职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1322, '江西洪州职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1323, '江西师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1324, '南昌影视传播职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1325, '赣南卫生健康职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1326, '萍乡卫生职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1327, '江西婺源茶业职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1328, '赣州职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1329, '南昌健康职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1330, '九江理工职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1331, '和君职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1332, '吉安幼儿师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1333, '上饶卫生健康职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1334, '山东大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1335, '中国海洋大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1336, '山东科技大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1337, '中国石油大学（华东）', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1338, '青岛科技大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1339, '济南大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1340, '青岛理工大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1341, '山东建筑大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1342, '齐鲁工业大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1343, '山东理工大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1344, '山东农业大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1345, '青岛农业大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1346, '潍坊医学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1347, '山东第一医科大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1348, '滨州医学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1349, '山东中医药大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1350, '济宁医学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1351, '山东师范大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1352, '曲阜师范大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1353, '聊城大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1354, '德州学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1355, '滨州学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1356, '鲁东大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1357, '临沂大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1358, '泰山学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1359, '济宁学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1360, '菏泽学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1361, '山东财经大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1362, '山东体育学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1363, '山东艺术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1364, '齐鲁医药学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1365, '青岛滨海学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1366, '枣庄学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1367, '山东工艺美术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1368, '青岛大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1369, '烟台大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1370, '潍坊学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1371, '山东警察学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1372, '山东交通学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1373, '山东工商学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1374, '山东女子学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1375, '烟台南山学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1376, '潍坊科技学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1377, '山东英才学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1378, '青岛恒星科技学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1379, '青岛黄海学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1380, '山东现代学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1381, '山东协和学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1382, '山东工程职业技术大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1383, '烟台理工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1384, '聊城大学东昌学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1385, '青岛城市学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1386, '潍坊理工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1387, '山东财经大学燕山学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1388, '山东石油化工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1389, '山东外国语职业技术大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1390, '泰山科技学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1391, '山东华宇工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1392, '山东外事职业大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1393, '青岛工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1394, '青岛农业大学海都学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1395, '齐鲁理工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1396, '山东财经大学东方学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1397, '烟台科技学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1398, '山东政法学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1399, '齐鲁师范学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1400, '山东青年政治学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1401, '青岛电影学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1402, '山东管理学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1403, '山东农业工程学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1404, '山东医学高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1405, '菏泽医学专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1406, '山东商业职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1407, '山东电力高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1408, '日照职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1409, '曲阜远东职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1410, '青岛职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1411, '威海职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1412, '山东职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1413, '山东劳动职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1414, '莱芜职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1415, '济宁职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1416, '潍坊职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1417, '烟台职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1418, '东营职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1419, '聊城职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1420, '滨州职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1421, '山东科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1422, '山东服装职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1423, '德州科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1424, '山东力明科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1425, '山东圣翰财贸职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1426, '山东水利职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1427, '山东畜牧兽医职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1428, '青岛飞洋职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1429, '东营科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1430, '山东交通职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1431, '淄博职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1432, '山东外贸职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1433, '青岛酒店管理职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1434, '山东信息职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1435, '青岛港湾职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1436, '山东胜利职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1437, '山东经贸职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1438, '山东工业职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1439, '山东化工职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1440, '青岛求实职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1441, '济南职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1442, '烟台工程职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1443, '潍坊工商职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1444, '德州职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1445, '枣庄科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1446, '淄博师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1447, '山东中医药高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1448, '济南工程职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1449, '山东电子职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1450, '山东旅游职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1451, '山东铝业职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1452, '山东杏林科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1453, '泰山职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1454, '山东药品食品职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1455, '山东商务职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1456, '山东轻工职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1457, '山东城市建设职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1458, '烟台汽车工程职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1459, '山东司法警官职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1460, '菏泽家政职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1461, '山东传媒职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1462, '临沂职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1463, '枣庄职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1464, '山东理工职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1465, '山东文化产业职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1466, '青岛远洋船员职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1467, '济南幼儿师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1468, '济南护理职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1469, '泰山护理职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1470, '山东海事职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1471, '潍坊护理职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1472, '潍坊工程职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1473, '菏泽职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1474, '山东艺术设计职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1475, '威海海洋职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1476, '山东特殊教育职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1477, '烟台黄金职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1478, '日照航海工程职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1479, '青岛工程职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1480, '青岛幼儿师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1481, '烟台幼儿师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1482, '烟台文化旅游职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1483, '临沂科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1484, '青岛航空科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1485, '潍坊环境工程职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1486, '滨州科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1487, '山东城市服务职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1488, '潍坊食品科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1489, '烟台城市科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1490, '华北水利水电大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1491, '郑州大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1492, '河南理工大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1493, '郑州轻工业大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1494, '河南工业大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1495, '河南科技大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1496, '中原工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1497, '河南农业大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1498, '河南科技学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1499, '河南牧业经济学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1500, '河南中医药大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1501, '新乡医学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1502, '河南大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1503, '河南师范大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1504, '信阳师范大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1505, '周口师范学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1506, '安阳师范学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1507, '许昌学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1508, '南阳师范学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1509, '洛阳师范学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1510, '商丘师范学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1511, '河南财经政法大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1512, '郑州航空工业管理学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1513, '黄淮学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1514, '平顶山学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1515, '郑州工程技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1516, '洛阳理工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1517, '新乡学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1518, '信阳农林学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1519, '河南工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1520, '安阳工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1521, '河南工程学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1522, '河南财政金融学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1523, '南阳理工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1524, '河南城建学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1525, '河南警察学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1526, '黄河科技学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1527, '郑州警察学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1528, '郑州科技学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1529, '郑州工业应用技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1530, '郑州师范学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1531, '郑州财经学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1532, '黄河交通学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1533, '商丘工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1534, '河南开封科技传媒学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1535, '中原科技学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1536, '信阳学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1537, '安阳学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1538, '新乡医学院三全学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1539, '新乡工程学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1540, '郑州工商学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1541, '郑州经贸学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1542, '商丘学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1543, '郑州商学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1544, '河南科技职业大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1545, '郑州升达经贸管理学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1546, '郑州西亚斯学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1547, '郑州美术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1548, '河南职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1549, '漯河职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1550, '三门峡职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1551, '郑州铁路职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1552, '开封大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1553, '焦作大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1554, '濮阳职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1555, '郑州电力高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1556, '黄河水利职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1557, '许昌职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1558, '河南工业和信息化职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1559, '河南水利与环境职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1560, '商丘职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1561, '平顶山工业职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1562, '周口职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1563, '济源职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1564, '河南司法警官职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1565, '鹤壁职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1566, '河南工业职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1567, '郑州澍青医学高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1568, '焦作师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1569, '河南检察职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1570, '河南质量工程职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1571, '郑州信息科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1572, '漯河医学高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1573, '南阳医学高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1574, '商丘医学高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1575, '郑州电子信息职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1576, '信阳职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1577, '嵩山少林武术职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1578, '郑州工业安全职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1579, '永城职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1580, '河南经贸职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1581, '河南交通职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1582, '河南农业职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1583, '郑州旅游职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1584, '郑州职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1585, '河南信息统计职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1586, '河南林业职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1587, '河南工业贸易职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1588, '郑州电力职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1589, '河南建筑职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1590, '漯河食品职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1591, '郑州城市职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1592, '安阳职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1593, '新乡职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1594, '驻马店职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1595, '焦作工贸职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1596, '许昌陶瓷职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1597, '郑州理工职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1598, '郑州信息工程职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1599, '长垣烹饪职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1600, '开封文化艺术职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1601, '河南应用技术职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1602, '河南艺术职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1603, '河南机电职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1604, '河南护理职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1605, '许昌电气职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1606, '信阳涉外职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1607, '鹤壁汽车工程职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1608, '南阳职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1609, '郑州商贸旅游职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1610, '河南推拿职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1611, '洛阳职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1612, '郑州幼儿师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1613, '安阳幼儿师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1614, '郑州黄河护理职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1615, '河南医学高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1616, '郑州财税金融职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1617, '南阳农业职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1618, '洛阳科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1619, '鹤壁能源化工职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1620, '平顶山文化艺术职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1621, '濮阳医学高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1622, '驻马店幼儿师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1623, '三门峡社会管理职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1624, '河南轻工职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1625, '河南测绘职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1626, '信阳航空职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1627, '郑州卫生健康职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1628, '河南物流职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1629, '河南地矿职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1630, '郑州亚欧交通职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1631, '河南女子职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1632, '河南对外经济贸易职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1633, '濮阳石油化工职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1634, '南阳科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1635, '兰考三农职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1636, '汝州职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1637, '林州建筑职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1638, '郑州电子商务职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1639, '郑州轨道工程职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1640, '郑州体育职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1641, '洛阳文化旅游职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1642, '周口文理职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1643, '信阳艺术职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1644, '郑州城建职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1645, '郑州医药健康职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1646, '平顶山职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1647, '南阳工艺美术职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1648, '濮阳科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1649, '商丘幼儿师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1650, '周口理工职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1651, '焦作新材料职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1652, '开封职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1653, '洛阳商业职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1654, '郑州软件职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1655, '郑州智能科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1656, '郑州食品工程职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1657, '郑州汽车工程职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1658, '武汉大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1659, '华中科技大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1660, '武汉科技大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1661, '长江大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1662, '武汉工程大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1663, '中国地质大学（武汉）', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1664, '武汉纺织大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1665, '武汉轻工大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1666, '武汉理工大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1667, '湖北工业大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1668, '华中农业大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1669, '湖北中医药大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1670, '华中师范大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1671, '湖北大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1672, '湖北师范大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1673, '黄冈师范学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1674, '湖北民族大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1675, '汉江师范学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1676, '湖北文理学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1677, '中南财经政法大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1678, '武汉体育学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1679, '湖北美术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1680, '中南民族大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1681, '湖北汽车工业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1682, '湖北工程学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1683, '湖北理工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1684, '湖北科技学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1685, '湖北医药学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1686, '江汉大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1687, '三峡大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1688, '湖北警官学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1689, '荆楚理工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1690, '武汉音乐学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1691, '湖北经济学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1692, '武汉商学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1693, '武汉东湖学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1694, '汉口学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1695, '武昌首义学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1696, '武昌理工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1697, '武汉生物工程学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1698, '武汉晴川学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1699, '湖北大学知行学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1700, '武汉城市学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1701, '三峡大学科技学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1702, '武汉文理学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1703, '湖北工业大学工程技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1704, '武汉工程大学邮电与信息工程学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1705, '武汉纺织大学外经贸学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1706, '武昌工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1707, '武汉工商学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1708, '荆州学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1709, '长江大学文理学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1710, '湖北商贸学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1711, '湖北汽车工业学院科技学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1712, '湖北医药学院药护学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1713, '湖北恩施学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1714, '湖北经济学院法商学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1715, '武汉体育学院体育科技学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1716, '湖北师范大学文理学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1717, '湖北文理学院理工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1718, '湖北工程学院新技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1719, '文华学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1720, '武汉学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1721, '武汉工程科技学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1722, '武汉华夏理工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1723, '武汉传媒学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1724, '武汉设计工程学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1725, '湖北第二师范学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1726, '武汉职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1727, '黄冈职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1728, '长江职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1729, '荆州理工职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1730, '湖北工业职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1731, '鄂州职业大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1732, '武汉城市职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1733, '湖北职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1734, '武汉船舶职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1735, '恩施职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1736, '襄阳职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1737, '武汉工贸职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1738, '荆州职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1739, '武汉工程职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1740, '仙桃职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1741, '湖北轻工职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1742, '湖北交通职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1743, '湖北中医药高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1744, '武汉航海职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1745, '武汉铁路职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1746, '武汉软件工程职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1747, '湖北三峡职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1748, '随州职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1749, '武汉电力职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1750, '湖北水利水电职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1751, '湖北城市建设职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1752, '武汉警官职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1753, '湖北生物科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1754, '湖北开放职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1755, '武汉科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1756, '武汉外语外事职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1757, '武汉信息传播职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1758, '武昌职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1759, '武汉商贸职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1760, '湖北艺术职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1761, '武汉交通职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1762, '咸宁职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1763, '长江工程职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1764, '江汉艺术职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1765, '武汉民政职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1766, '湖北黄冈应急管理职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1767, '湖北财税职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1768, '黄冈科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1769, '湖北国土资源职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1770, '湖北生态工程职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1771, '三峡电力职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1772, '湖北科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1773, '湖北青年职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1774, '湖北工程职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1775, '三峡旅游职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1776, '天门职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1777, '湖北体育职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1778, '襄阳汽车职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1779, '湖北幼儿师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1780, '湖北铁道运输职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1781, '武汉海事职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1782, '长江艺术工程职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1783, '荆门职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1784, '武汉铁路桥梁职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1785, '武汉光谷职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1786, '湖北健康职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1787, '湖北孝感美珈职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1788, '襄阳科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1789, '宜昌科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1790, '湘潭大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1791, '吉首大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1792, '湖南大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1793, '中南大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1794, '湖南科技大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1795, '长沙理工大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1796, '湖南农业大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1797, '中南林业科技大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1798, '湖南中医药大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1799, '湖南师范大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1800, '湖南理工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1801, '湘南学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1802, '衡阳师范学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1803, '邵阳学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1804, '怀化学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1805, '湖南文理学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1806, '湖南科技学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1807, '湖南人文科技学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1808, '湖南工商大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1809, '南华大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1810, '长沙医学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1811, '长沙学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1812, '湖南工程学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1813, '湖南城市学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1814, '湖南工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1815, '湖南财政经济学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1816, '湖南警察学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1817, '湖南工业大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1818, '湖南女子学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1819, '湖南第一师范学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1820, '湖南医药学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1821, '湖南涉外经济学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1822, '湘潭大学兴湘学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1823, '湖南工业大学科技学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1824, '湖南科技大学潇湘学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1825, '南华大学船山学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1826, '湘潭理工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1827, '湖南师范大学树达学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1828, '湖南农业大学东方科技学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1829, '中南林业科技大学涉外学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1830, '湖南文理学院芙蓉学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1831, '湖南理工学院南湖学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1832, '衡阳师范学院南岳学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1833, '湖南工程学院应用技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1834, '湖南中医药大学湘杏学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1835, '吉首大学张家界学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1836, '长沙理工大学城南学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1837, '长沙师范学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1838, '湖南应用技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1839, '湖南信息学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1840, '湖南交通工程学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1841, '湖南软件职业技术大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1842, '湘中幼儿师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1843, '长沙民政职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1844, '湖南工业职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1845, '株洲师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1846, '湖南信息职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1847, '湖南税务高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1848, '湖南冶金职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1849, '长沙航空职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1850, '湖南大众传媒职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1851, '永州职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1852, '湖南铁道职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1853, '湖南科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1854, '湖南生物机电职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1855, '湖南交通职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1856, '湖南商务职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1857, '湖南体育职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1858, '湖南工程职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1859, '保险职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1860, '湖南外贸职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1861, '湖南网络工程职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1862, '邵阳职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1863, '湖南司法警官职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1864, '长沙商贸旅游职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1865, '湖南环境生物职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1866, '湖南邮电职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1867, '湘潭医卫职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1868, '郴州职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1869, '娄底职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1870, '张家界航空工业职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1871, '长沙环境保护职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1872, '湖南艺术职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1873, '湖南机电职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1874, '长沙职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1875, '怀化职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1876, '岳阳职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1877, '常德职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1878, '长沙南方职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1879, '潇湘职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1880, '湖南化工职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1881, '湖南城建职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1882, '湖南石油化工职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1883, '湖南中医药高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1884, '湖南民族职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1885, '湘西民族职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1886, '湖南财经工业职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1887, '益阳职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1888, '湖南工艺美术职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1889, '湖南九嶷职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1890, '湖南理工职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1891, '湖南汽车工程职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1892, '长沙电力职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1893, '湖南水利水电职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1894, '湖南现代物流职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1895, '湖南高速铁路职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1896, '湖南铁路科技职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1897, '湖南安全技术职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1898, '湖南电气职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1899, '湖南外国语职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1900, '益阳医学高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1901, '湖南都市职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1902, '湖南电子科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1903, '湖南国防工业职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1904, '湖南高尔夫旅游职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1905, '湖南工商职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1906, '湖南三一工业职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1907, '长沙卫生职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1908, '湖南食品药品职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1909, '湖南有色金属职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1910, '湖南吉利汽车职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1911, '湖南幼儿师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1912, '湘南幼儿师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1913, '湖南劳动人事职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1914, '怀化师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1915, '永州师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1916, '衡阳幼儿师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1917, '长沙幼儿师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1918, '益阳师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1919, '娄底幼儿师范高等专科学校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1920, '常德科技职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1921, '邵阳工业职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1922, '长沙轨道交通职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1923, '长沙文创艺术职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1924, '岳阳现代服务职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1925, '郴州思科职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1926, '衡阳科技职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1927, '中山大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1928, '暨南大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1929, '汕头大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1930, '华南理工大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1931, '华南农业大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1932, '广东海洋大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1933, '广州医科大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1934, '广东医科大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1935, '广州中医药大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1936, '广东药科大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1937, '华南师范大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1938, '韶关学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1939, '惠州学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1940, '韩山师范学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1941, '岭南师范学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1942, '肇庆学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1943, '嘉应学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1944, '广州体育学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1945, '广州美术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1946, '星海音乐学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1947, '广东技术师范大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1948, '深圳大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1949, '广东财经大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1950, '广东白云学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1951, '广州大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1952, '广州航海学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1953, '广东警官学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1954, '仲恺农业工程学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1955, '五邑大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1956, '广东金融学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1957, '电子科技大学中山学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1958, '广东石油化工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1959, '东莞理工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1960, '广东工业大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1961, '广东外语外贸大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1962, '佛山科学技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1963, '广东培正学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1964, '南方医科大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1965, '广东东软学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1966, '广州城市理工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1967, '广州软件学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1968, '广州南方学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1969, '广东外语外贸大学南国商学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1970, '广州华商学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1971, '湛江科技学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1972, '华南农业大学珠江学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1973, '广州理工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1974, '北京师范大学珠海分校', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1975, '广州华立学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1976, '广州应用科技学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1977, '广州商学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1978, '北京理工大学珠海学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1979, '珠海科技学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1980, '广州工商学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1981, '广州科技职业技术大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1982, '广东科技学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1983, '广东理工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1984, '广东工商职业技术大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1985, '东莞城市学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1986, '广州新华学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1987, '广东第二师范学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1988, '南方科技大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1989, '深圳技术大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1990, '北京师范大学-香港浸会大学联合国际学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1991, '香港科技大学（广州）', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1992, '香港中文大学（深圳）', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1993, '深圳北理莫斯科大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1994, '广东以色列理工学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1995, '深圳职业技术大学', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1996, '顺德职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1997, '广东轻工职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1998, '广东交通职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (1999, '广东水利电力职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2000, '潮汕职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2001, '广东南华工商职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2002, '私立华联学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2003, '广州民航职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2004, '广州番禺职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2005, '广东松山职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2006, '广东农工商职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2007, '广东新安职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2008, '佛山职业技术学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2009, '广东科学技术职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2010, '广东食品药品职业学院', 0, '2025-07-06 14:11:21', '2025-07-06 14:11:21');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2011, '广州康大职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2012, '珠海艺术职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2013, '广东行政职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2014, '广东体育职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2015, '广东职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2016, '广东建设职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2017, '广东女子职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2018, '广东机电职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2019, '广东岭南职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2020, '汕尾职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2021, '罗定职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2022, '阳江职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2023, '河源职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2024, '广东邮电职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2025, '汕头职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2026, '揭阳职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2027, '深圳信息职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2028, '清远职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2029, '广东工贸职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2030, '广东司法警官职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2031, '广东亚视演艺职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2032, '广东省外语艺术职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2033, '广东文艺职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2034, '广州体育职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2035, '广州工程技术职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2036, '中山火炬职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2037, '江门职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2038, '茂名职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2039, '珠海城市职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2040, '广州涉外经济职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2041, '广州南洋理工职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2042, '惠州经济职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2043, '肇庆医学高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2044, '广州现代信息工程职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2045, '广东理工职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2046, '广州华南商贸职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2047, '广州华立科技职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2048, '广州城市职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2049, '广东工程职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2050, '广州铁路职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2051, '广东科贸职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2052, '广州科技贸易职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2053, '中山职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2054, '广州珠江职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2055, '广州松田职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2056, '广东文理职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2057, '广州城建职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2058, '东莞职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2059, '广东南方职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2060, '广州华商职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2061, '广州华夏职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2062, '广东环境保护工程职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2063, '广东青年职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2064, '广州东华职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2065, '广东创新科技职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2066, '广东舞蹈戏剧职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2067, '惠州卫生职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2068, '广东信息工程职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2069, '广东生态工程职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2070, '惠州城市职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2071, '广东碧桂园职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2072, '广东茂名健康职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2073, '广东酒店管理职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2074, '广东茂名幼儿师范专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2075, '广州卫生职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2076, '惠州工程职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2077, '广东江门中医药职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2078, '广东茂名农林科技职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2079, '广东江门幼儿师范高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2080, '广东财贸职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2081, '广州幼儿师范高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2082, '广东汕头幼儿师范高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2083, '广东梅州职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2084, '广东潮州卫生健康职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2085, '广东云浮中医药职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2086, '广东肇庆航空职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2087, '湛江幼儿师范专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2088, '珠海格力职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2089, '广西大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2090, '广西科技大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2091, '桂林电子科技大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2092, '桂林理工大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2093, '广西医科大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2094, '右江民族医学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2095, '广西中医药大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2096, '桂林医学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2097, '广西师范大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2098, '南宁师范大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2099, '广西民族师范学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2100, '河池学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2101, '玉林师范学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2102, '广西艺术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2103, '广西民族大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2104, '百色学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2105, '梧州学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2106, '广西科技师范学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2107, '广西财经学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2108, '南宁学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2109, '北部湾大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2110, '桂林航天工业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2111, '桂林旅游学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2112, '贺州学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2113, '广西警察学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2114, '北海艺术设计学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2115, '广西农业职业技术大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2116, '柳州工学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2117, '广西民族大学相思湖学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2118, '桂林学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2119, '南宁师范大学师园学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2120, '广西中医药大学赛恩斯新医药学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2121, '桂林信息科技学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2122, '南宁理工学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2123, '广西外国语学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2124, '北京航空航天大学北海学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2125, '广西城市职业大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2126, '广西职业师范学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2127, '桂林生命与健康职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2128, '广西机电职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2129, '广西体育高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2130, '南宁职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2131, '广西水利电力职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2132, '桂林师范高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2133, '广西职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2134, '柳州职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2135, '广西生态工程职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2136, '广西交通职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2137, '广西工业职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2138, '广西国际商务职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2139, '柳州铁道职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2140, '广西建设职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2141, '广西现代职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2142, '北海职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2143, '桂林山水职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2144, '广西经贸职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2145, '广西工商职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2146, '广西演艺职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2147, '广西电力职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2148, '广西英华国际职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2149, '柳州城市职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2150, '百色职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2151, '广西工程职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2152, '广西理工职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2153, '梧州职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2154, '广西经济职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2155, '广西幼儿师范高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2156, '广西科技职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2157, '广西卫生职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2158, '广西培贤国际职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2159, '广西金融职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2160, '广西中远职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2161, '玉柴职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2162, '广西蓝天航空职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2163, '广西安全工程职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2164, '广西自然资源职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2165, '钦州幼儿师范高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2166, '梧州医学高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2167, '广西制造工程职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2168, '广西物流职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2169, '防城港职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2170, '广西信息职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2171, '广西农业工程职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2172, '北海康养职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2173, '崇左幼儿师范高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2174, '广西质量工程职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2175, '桂林信息工程职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2176, '海南大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2177, '海南热带海洋学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2178, '海南师范大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2179, '海南医学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2180, '海口经济学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2181, '琼台师范学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2182, '三亚学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2183, '海南科技职业大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2184, '海南比勒费尔德应用科学大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2185, '海南职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2186, '三亚城市职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2187, '海南软件职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2188, '海南政法职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2189, '海南外国语职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2190, '海南经贸职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2191, '海南工商职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2192, '三亚航空旅游职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2193, '三亚理工职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2194, '海南体育职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2195, '三亚中瑞酒店管理职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2196, '海南健康管理职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2197, '海南卫生健康职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2198, '重庆大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2199, '重庆邮电大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2200, '重庆交通大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2201, '重庆医科大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2202, '西南大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2203, '重庆师范大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2204, '重庆文理学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2205, '重庆三峡学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2206, '长江师范学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2207, '四川外国语大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2208, '西南政法大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2209, '四川美术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2210, '重庆科技学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2211, '重庆理工大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2212, '重庆工商大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2213, '重庆机电职业技术大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2214, '重庆工程学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2215, '重庆城市科技学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2216, '重庆警察学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2217, '重庆人文科技学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2218, '重庆外语外事学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2219, '重庆对外经贸学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2220, '重庆财经学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2221, '重庆工商大学派斯学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2222, '重庆移通学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2223, '重庆第二师范学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2224, '重庆中医药学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2225, '重庆航天职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2226, '重庆电力高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2227, '重庆工业职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2228, '重庆三峡职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2229, '重庆工贸职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2230, '重庆电子工程职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2231, '重庆海联职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2232, '重庆信息技术职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2233, '重庆传媒职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2234, '重庆城市管理职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2235, '重庆工程职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2236, '重庆建筑科技职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2237, '重庆城市职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2238, '重庆水利电力职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2239, '重庆工商职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2240, '重庆应用技术职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2241, '重庆三峡医药高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2242, '重庆医药高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2243, '重庆青年职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2244, '重庆财经职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2245, '重庆科创职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2246, '重庆建筑工程职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2247, '重庆电讯职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2248, '重庆能源职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2249, '重庆商务职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2250, '重庆交通职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2251, '重庆化工职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2252, '重庆旅游职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2253, '重庆安全技术职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2254, '重庆公共运输职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2255, '重庆艺术工程职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2256, '重庆轻工职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2257, '重庆电信职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2258, '重庆经贸职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2259, '重庆幼儿师范高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2260, '重庆文化艺术职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2261, '重庆科技职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2262, '重庆资源与环境保护职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2263, '重庆护理职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2264, '重庆理工职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2265, '重庆智能工程职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2266, '重庆健康职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2267, '重庆工信职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2268, '重庆五一职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2269, '四川大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2270, '西南交通大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2271, '电子科技大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2272, '西南石油大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2273, '成都理工大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2274, '西南科技大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2275, '成都信息工程大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2276, '四川轻化工大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2277, '西华大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2278, '中国民用航空飞行学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2279, '四川农业大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2280, '西昌学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2281, '西南医科大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2282, '成都中医药大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2283, '川北医学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2284, '四川师范大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2285, '西华师范大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2286, '绵阳师范学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2287, '内江师范学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2288, '宜宾学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2289, '四川文理学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2290, '阿坝师范学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2291, '乐山师范学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2292, '西南财经大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2293, '成都体育学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2294, '四川音乐学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2295, '西南民族大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2296, '成都大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2297, '成都工业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2298, '攀枝花学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2299, '四川旅游学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2300, '四川民族学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2301, '四川警察学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2302, '成都东软学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2303, '成都艺术职业大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2304, '电子科技大学成都学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2305, '成都理工大学工程技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2306, '四川传媒学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2307, '成都银杏酒店管理学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2308, '成都文理学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2309, '四川工商学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2310, '四川外国语大学成都学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2311, '成都医学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2312, '四川工业科技学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2313, '成都锦城学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2314, '西南财经大学天府学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2315, '四川大学锦江学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2316, '四川文化艺术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2317, '绵阳城市学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2318, '西南交通大学希望学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2319, '成都师范学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2320, '四川电影电视学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2321, '吉利学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2322, '成都纺织高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2323, '民办四川天一学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2324, '成都航空职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2325, '四川电力职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2326, '成都职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2327, '四川化工职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2328, '四川水利职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2329, '南充职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2330, '内江职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2331, '四川航天职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2332, '四川邮电职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2333, '四川机电职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2334, '绵阳职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2335, '四川交通职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2336, '四川工商职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2337, '四川工程职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2338, '四川建筑职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2339, '达州职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2340, '四川托普信息技术职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2341, '四川国际标榜职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2342, '成都农业科技职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2343, '宜宾职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2344, '泸州职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2345, '眉山职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2346, '四川职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2347, '乐山职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2348, '雅安职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2349, '四川商务职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2350, '四川司法警官职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2351, '广安职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2352, '四川信息职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2353, '四川文化传媒职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2354, '四川华新现代职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2355, '四川铁道职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2356, '四川艺术职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2357, '四川中医药高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2358, '四川科技职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2359, '四川文化产业职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2360, '四川财经职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2361, '四川城市职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2362, '四川现代职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2363, '四川幼儿师范高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2364, '四川长江职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2365, '四川三河职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2366, '川北幼儿师范高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2367, '四川卫生康复职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2368, '四川汽车职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2369, '巴中职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2370, '四川希望汽车职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2371, '四川电子机械职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2372, '四川文轩职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2373, '川南幼儿师范高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2374, '四川护理职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2375, '成都工业职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2376, '四川西南航空职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2377, '成都工贸职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2378, '四川应用技术职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2379, '西昌民族幼儿师范高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2380, '眉山药科职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2381, '天府新区信息职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2382, '德阳城市轨道交通职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2383, '德阳科贸职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2384, '江阳城建职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2385, '天府新区航空旅游职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2386, '天府新区通用航空职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2387, '阿坝职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2388, '达州中医药职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2389, '内江卫生与健康职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2390, '南充科技职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2391, '攀枝花攀西职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2392, '资阳口腔职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2393, '资阳环境科技职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2394, '南充文化旅游职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2395, '南充电影工业职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2396, '绵阳飞行职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2397, '德阳农业科技职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2398, '泸州医疗器械职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2399, '甘孜职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2400, '自贡职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2401, '广元中核职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2402, '四川体育职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2403, '遂宁能源职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2404, '遂宁工程职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2405, '遂宁职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2406, '贵州大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2407, '贵州医科大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2408, '遵义医科大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2409, '贵州中医药大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2410, '贵州师范大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2411, '遵义师范学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2412, '铜仁学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2413, '兴义民族师范学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2414, '安顺学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2415, '贵州工程应用技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2416, '凯里学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2417, '黔南民族师范学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2418, '贵州财经大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2419, '贵州民族大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2420, '贵阳学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2421, '六盘水师范学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2422, '贵州商学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2423, '贵州警察学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2424, '贵州中医药大学时珍学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2425, '贵州黔南经济学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2426, '贵州黔南科技学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2427, '贵阳信息科技学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2428, '贵阳人文科技学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2429, '贵阳康养职业大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2430, '遵义医科大学医学与科技学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2431, '贵州医科大学神奇民族医药学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2432, '贵州师范学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2433, '贵州理工学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2434, '茅台学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2435, '黔南民族医学高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2436, '贵州交通职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2437, '贵州航天职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2438, '贵州电子信息职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2439, '安顺职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2440, '黔东南民族职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2441, '黔南民族职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2442, '遵义职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2443, '贵州城市职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2444, '贵州工业职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2445, '贵州电力职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2446, '六盘水职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2447, '铜仁职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2448, '黔西南民族职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2449, '贵州轻工职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2450, '遵义医药高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2451, '贵阳职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2452, '毕节职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2453, '贵州职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2454, '贵州盛华职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2455, '贵州工商职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2456, '贵阳幼儿师范高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2457, '铜仁幼儿师范高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2458, '黔南民族幼儿师范高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2459, '毕节医学高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2460, '贵州建设职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2461, '毕节幼儿师范高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2462, '贵州农业职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2463, '贵州工程职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2464, '贵州工贸职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2465, '贵州水利水电职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2466, '贵州电子商务职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2467, '贵州应用技术职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2468, '贵州电子科技职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2469, '贵州装备制造职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2470, '贵州健康职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2471, '贵州食品工程职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2472, '贵州经贸职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2473, '贵州护理职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2474, '六盘水幼儿师范高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2475, '毕节工业职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2476, '贵州机电职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2477, '贵州财经职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2478, '贵州民用航空职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2479, '贵州文化旅游职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2480, '贵州航空职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2481, '贵州体育职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2482, '贵州铜仁数据职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2483, '云南大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2484, '昆明理工大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2485, '云南农业大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2486, '西南林业大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2487, '昆明医科大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2488, '大理大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2489, '云南中医药大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2490, '云南师范大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2491, '昭通学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2492, '曲靖师范学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2493, '普洱学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2494, '保山学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2495, '红河学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2496, '云南财经大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2497, '云南艺术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2498, '云南民族大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2499, '玉溪师范学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2500, '楚雄师范学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2501, '云南警官学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2502, '昆明学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2503, '文山学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2504, '云南经济管理学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2505, '云南大学滇池学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2506, '丽江文化旅游学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2507, '昆明理工大学津桥学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2508, '昆明城市学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2509, '昆明文理学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2510, '昆明医科大学海源学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2511, '云南艺术学院文华学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2512, '云南工商学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2513, '滇西科技师范学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2514, '滇西应用技术大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2515, '昆明冶金高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2516, '云南国土资源职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2517, '云南交通职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2518, '昆明工业职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2519, '云南农业职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2520, '云南司法警官职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2521, '云南文化艺术职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2522, '云南体育运动职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2523, '云南科技信息职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2524, '西双版纳职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2525, '昆明艺术职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2526, '玉溪农业职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2527, '云南能源职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2528, '云南国防工业职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2529, '云南机电职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2530, '云南林业职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2531, '云南城市建设职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2532, '云南工程职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2533, '曲靖医学高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2534, '楚雄医药高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2535, '保山中医药高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2536, '丽江师范高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2537, '德宏师范高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2538, '云南新兴职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2539, '云南锡业职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2540, '云南经贸外事职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2541, '云南三鑫职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2542, '德宏职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2543, '云南商务职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2544, '昆明卫生职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2545, '云南现代职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2546, '云南旅游职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2547, '红河卫生职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2548, '云南外事外语职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2549, '大理农林职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2550, '公安消防部队高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2551, '云南财经职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2552, '昆明铁道职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2553, '昭通卫生职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2554, '大理护理职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2555, '云南水利水电职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2556, '云南轻纺职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2557, '云南特殊教育职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2558, '云南工贸职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2559, '云南交通运输职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2560, '昆明幼儿师范高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2561, '云南医药健康职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2562, '云南理工职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2563, '曲靖职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2564, '红河职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2565, '玉溪职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2566, '保山职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2567, '昭通职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2568, '文山职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2569, '丽江职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2570, '香格里拉职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2571, '西藏农牧学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2572, '西藏大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2573, '西藏民族大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2574, '西藏藏医药大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2575, '西藏警官高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2576, '拉萨师范高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2577, '西藏职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2578, '西北大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2579, '西安交通大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2580, '西北工业大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2581, '西安理工大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2582, '西安电子科技大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2583, '西安工业大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2584, '西安建筑科技大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2585, '西安科技大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2586, '西安石油大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2587, '陕西科技大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2588, '西安工程大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2589, '长安大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2590, '西北农林科技大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2591, '陕西中医药大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2592, '陕西师范大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2593, '延安大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2594, '陕西理工大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2595, '宝鸡文理学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2596, '咸阳师范学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2597, '渭南师范学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2598, '西安外国语大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2599, '西北政法大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2600, '西安体育学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2601, '西安音乐学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2602, '西安美术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2603, '西安文理学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2604, '榆林学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2605, '商洛学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2606, '安康学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2607, '西安培华学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2608, '西安财经大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2609, '西安邮电大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2610, '西安航空学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2611, '西安医学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2612, '西安欧亚学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2613, '西安外事学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2614, '西安翻译学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2615, '西京学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2616, '西安思源学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2617, '陕西国际商贸学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2618, '陕西服装工程学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2619, '西安交通工程学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2620, '西安交通大学城市学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2621, '西北大学现代学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2622, '西安建筑科技大学华清学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2623, '西安财经大学行知学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2624, '陕西科技大学镐京学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2625, '西安工商学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2626, '延安大学西安创新学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2627, '西安电子科技大学长安学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2628, '西安汽车职业大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2629, '西安明德理工学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2630, '西安信息职业大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2631, '长安大学兴华学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2632, '西安理工大学高科学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2633, '西安科技大学高新学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2634, '陕西学前师范学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2635, '陕西工业职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2636, '杨凌职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2637, '西安电力高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2638, '陕西能源职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2639, '陕西国防工业职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2640, '西安航空职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2641, '陕西财经职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2642, '陕西交通职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2643, '陕西职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2644, '西安高新科技职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2645, '西安城市建设职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2646, '陕西铁路工程职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2647, '宝鸡职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2648, '陕西航空职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2649, '陕西电子信息职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2650, '陕西邮电职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2651, '西安海棠职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2652, '西安健康工程职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2653, '陕西警官职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2654, '陕西经济管理职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2655, '西安铁路职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2656, '咸阳职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2657, '西安职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2658, '商洛职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2659, '汉中职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2660, '延安职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2661, '渭南职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2662, '安康职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2663, '铜川职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2664, '陕西青年职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2665, '陕西工商职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2666, '陕西旅游烹饪职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2667, '西安医学高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2668, '榆林职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2669, '陕西艺术职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2670, '神木职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2671, '宝鸡三和职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2672, '榆林能源科技职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2673, '宝鸡中北职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2674, '陕西机电职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2675, '兰州大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2676, '兰州理工大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2677, '兰州交通大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2678, '甘肃农业大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2679, '甘肃中医药大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2680, '西北师范大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2681, '兰州城市学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2682, '陇东学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2683, '天水师范学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2684, '河西学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2685, '兰州财经大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2686, '西北民族大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2687, '甘肃政法大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2688, '甘肃民族师范学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2689, '兰州文理学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2690, '甘肃医学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2691, '兰州工业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2692, '兰州石化职业技术大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2693, '兰州工商学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2694, '兰州资源环境职业技术大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2695, '兰州博文科技学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2696, '兰州信息科技学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2697, '陇南师范高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2698, '定西师范高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2699, '甘肃建筑职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2700, '酒泉职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2701, '兰州外语职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2702, '兰州职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2703, '甘肃警察职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2704, '甘肃林业职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2705, '甘肃工业职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2706, '武威职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2707, '甘肃交通职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2708, '甘肃农业职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2709, '甘肃畜牧工程职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2710, '甘肃钢铁职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2711, '甘肃机电职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2712, '甘肃有色冶金职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2713, '白银矿冶职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2714, '甘肃卫生职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2715, '兰州科技职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2716, '庆阳职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2717, '临夏现代职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2718, '兰州现代职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2719, '平凉职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2720, '培黎职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2721, '兰州航空职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2722, '白银希望职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2723, '甘肃财贸职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2724, '定西职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2725, '青海大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2726, '青海师范大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2727, '青海民族大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2728, '青海大学昆仑学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2729, '青海卫生职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2730, '青海警官职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2731, '青海农牧科技职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2732, '青海交通职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2733, '青海建筑职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2734, '西宁城市职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2735, '青海高等职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2736, '青海柴达木职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2737, '宁夏大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2738, '宁夏医科大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2739, '宁夏师范学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2740, '北方民族大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2741, '宁夏理工学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2742, '宁夏大学新华学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2743, '银川能源学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2744, '银川科技学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2745, '宁夏民族职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2746, '宁夏工业职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2747, '宁夏职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2748, '宁夏工商职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2749, '宁夏财经职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2750, '宁夏警官职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2751, '宁夏建设职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2752, '宁夏葡萄酒与防沙治沙职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2753, '宁夏幼儿师范高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2754, '宁夏艺术职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2755, '宁夏体育职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2756, '石嘴山工贸职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2757, '宁夏卫生健康职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2758, '新疆大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2759, '塔里木大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2760, '新疆农业大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2761, '石河子大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2762, '新疆医科大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2763, '新疆师范大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2764, '喀什大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2765, '伊犁师范大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2766, '新疆财经大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2767, '新疆艺术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2768, '新疆工程学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2769, '昌吉学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2770, '新疆警察学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2771, '新疆理工学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2772, '新疆农业大学科学技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2773, '新疆第二医学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2774, '新疆科技学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2775, '新疆政法学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2776, '新疆天山职业技术大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2777, '和田师范专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2778, '新疆农业职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2779, '乌鲁木齐职业大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2780, '新疆维吾尔医学专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2781, '克拉玛依职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2782, '新疆机电职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2783, '新疆轻工职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2784, '新疆能源职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2785, '昌吉职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2786, '伊犁职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2787, '阿克苏职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2788, '巴音郭楞职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2789, '新疆建设职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2790, '新疆现代职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2791, '新疆交通职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2792, '新疆石河子职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2793, '新疆职业大学', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2794, '新疆体育职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2795, '新疆应用职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2796, '新疆师范高等专科学校', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2797, '新疆铁道职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2798, '新疆生产建设兵团兴新职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2799, '哈密职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2800, '新疆科技职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2801, '吐鲁番职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2802, '博尔塔拉职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2803, '和田职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2804, '石河子工程职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2805, '喀什职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2806, '克孜勒苏职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2807, '新疆科信职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2808, '阿勒泰职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2809, '塔城职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2810, '塔里木职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2811, '新疆工业职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2812, '铁门关职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2813, '新疆司法警官职业学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2814, '阿克苏工业职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2815, '喀什理工职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2816, '图木舒克职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2817, '可克达拉职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2818, '新星职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');
INSERT INTO spark_hire.school (id, school_name, post_num, create_time, update_time)
VALUES (2819, '昆玉职业技术学院', 0, '2025-07-06 14:11:22', '2025-07-06 14:11:22');

-- 专业数据
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (1, '计算机科学与技术', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (2, '软件工程', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (3, '汉语言文学', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (4, '英语', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (5, '临床医学', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (6, '机械设计制造及其自动化', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (7, '土木工程', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (8, '法学', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (9, '电气工程及其自动化', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (10, '会计学', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (11, '电子信息工程', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (12, '通信工程', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (13, '自动化', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (14, '学前教育', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (15, '电子商务', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (16, '数学与应用数学', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (17, '工商管理', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (18, '市场营销', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (19, '视觉传达设计', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (20, '金融学', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (21, '国际经济与贸易', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (22, '财务管理', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (23, '计算机应用技术', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (24, '生物科学', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (25, '材料科学与工程', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (26, '物理学', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (27, '信息管理与信息系统', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (28, '物流管理', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (29, '数据科学与大数据技术', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (30, '物联网工程', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (31, '药学', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (32, '软件技术', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (33, '护理学', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (34, '小学教育', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (35, '中医学', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (36, '应用化学', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (37, '历史学', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (38, '经济学', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (39, '环境设计', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (40, '应用心理学', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (41, '机械工程', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (42, '建筑学', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (43, '工程造价', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (44, '环境工程', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (45, '化学工程与工艺', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (46, '旅游管理', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (47, '能源与动力工程', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (48, '生物技术', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (49, '车辆工程', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (50, '人力资源管理', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (51, '商务英语', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (52, '网络工程', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (53, '化学', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (54, '数字媒体技术', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (55, '工业设计', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (56, '地理科学', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (57, '计算机网络技术', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (58, '机械电子工程', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (59, '食品科学与工程', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (60, '数字媒体艺术', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (61, '新闻学', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (62, '给排水科学与工程', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (63, '行政管理', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (64, '口腔医学', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (65, '工程管理', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (66, '汉语国际教育', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (67, '机电一体化技术', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (68, '材料成型及控制工程', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (69, '社会工作', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (70, '光电信息科学与工程', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (71, '动画', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (72, '应用物理学', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (73, '广告学', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (74, '动物医学', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (75, '会计', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (76, '生物医学工程', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (77, '电子科学与技术', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (78, '信息与计算科学', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (79, '生物工程', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (80, '广播电视编导', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (81, '电子信息科学与技术', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (82, '环境艺术设计', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (83, '高分子材料与工程', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (84, '思想政治教育', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (85, '公共事业管理', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (86, '土地资源管理', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (87, '制药工程', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (88, '交通运输', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (89, '物联网应用技术', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (90, '医学检验技术', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (91, '医学影像技术', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (92, '中药学', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (93, '风景园林', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (94, '网络与新媒体', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (95, '社会学', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (96, '产品设计', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (97, '测控技术与仪器', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (98, '建筑工程技术', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (99, '动物科学', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (100, '护理', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (101, '针灸推拿学', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (102, '测绘工程', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (103, '日语', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (104, '音乐学', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (105, '安全工程', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (106, '教育技术学', 0, '2024-02-23 14:49:56', '2024-02-23 14:49:56');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (107, '园艺', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (108, '交通工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (109, '生态学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (110, '园林', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (111, '播音与主持艺术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (112, '智能科学与技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (113, '工业工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (114, '心理学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (115, '体育教育', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (116, '预防医学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (117, '人文地理与城乡规划', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (118, '城乡规划', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (119, '汽车检测与维修技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (120, '人工智能', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (121, '信息安全', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (122, '应用统计学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (123, '美术学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (124, '哲学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (125, '地理信息科学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (126, '康复治疗学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (127, '采矿工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (128, '服装与服饰设计', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (129, '云计算技术与应用', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (130, '建筑环境与能源应用工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (131, '酒店管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (132, '动漫制作技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (133, '广播电视学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (134, '统计学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (135, '戏剧影视文学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (136, '工程力学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (137, '航海技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (138, '中西医临床医学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (139, '农业资源与环境', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (140, '音乐表演', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (141, '农学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (142, '新能源科学与工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (143, '过程装备与控制工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (144, '电子信息', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (145, '劳动与社会保障', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (146, '翻译', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (147, '环境科学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (148, '机器人工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (149, '金融工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (150, '地质学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (151, '微电子科学与工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (152, '文化产业管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (153, '金属材料工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (154, '植物保护', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (155, '数字媒体应用技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (156, '机械制造与自动化', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (157, '林学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (158, '水产养殖学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (159, '保险学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (160, '水利水电工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (161, '大数据管理与应用', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (162, '绘画', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (163, '大数据与会计', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (164, '税收学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (165, '德语', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (166, '医学影像学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (167, '俄语', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (168, '食品质量与安全', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (169, '飞行器设计与工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (170, '数控技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (171, '传播学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (172, '汽车服务工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (173, '冶金工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (174, '无机非金属材料工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (175, '模具设计与制造', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (176, '教育学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (177, '海洋科学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (178, '材料与化工', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (179, '资源勘查工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (180, '会展经济与管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (181, '工业机器人技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (182, '纺织工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (183, '飞行技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (184, '秘书学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (185, '电气工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (186, '农林经济管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (187, '法律', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (188, '材料化学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (189, '飞行器制造工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (190, '大气科学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (191, '投资学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (192, '船舶与海洋工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (193, '地质工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (194, '侦查学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (195, '网络空间安全', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (196, '财政学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (197, '包装工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (198, '飞行器动力工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (199, '大数据技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (200, '法语', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (201, '大数据技术与应用', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (202, '审计学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (203, '电子信息工程技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (204, '国际商务', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (205, '治安学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (206, '特殊教育', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (207, '遥感科学与技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (208, '智能制造工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (209, '健康服务与管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (210, '康复治疗技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (211, '生物学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (212, '道路桥梁与渡河工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (213, '应用电子技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (214, '管理科学与工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (215, '环境科学与工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (216, '石油工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (217, '法医学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (218, '建筑室内设计', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (219, '信息工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (220, '畜牧兽医', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (221, '基础医学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (222, '室内艺术设计', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (223, '艺术设计', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (224, '服装设计与工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (225, '政治学与行政学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (226, '新能源汽车技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (227, '无人机应用技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (228, '药物制剂', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (229, '生物制药', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (230, '机械', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (231, '经济统计学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (232, '数字媒体艺术设计', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (233, '知识产权', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (234, '港口航道与海岸工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (235, '运动康复', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (236, '核工程与核技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (237, '铁道机车', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (238, '新闻与传播', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (239, '信息安全技术应用', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (240, '电气自动化', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (241, '经济与金融', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (242, '麻醉学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (243, '工商企业管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (244, '建筑与土木工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (245, '新能源材料与器件', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (246, '书法学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (247, '朝鲜语', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (248, '金融', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (249, '道路桥梁工程技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (250, '建筑电气与智能化', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (251, '物业管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (252, '轨道交通信号与控制', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (253, '资产评估', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (254, '轮机工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (255, '移动应用开发', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (256, '工程测量技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (257, '控制科学与工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (258, '公共管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (259, '电气自动化技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (260, '勘查技术与工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (261, '影视动画', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (262, '生物化学与分子生物学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (263, '生物信息学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (264, '农业水利工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (265, '工艺美术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (266, '集成电路设计与集成系统', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (267, '市政工程技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (268, '物流工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (269, '宝石及材料工艺学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (270, '焊接技术与工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (271, '应用英语', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (272, '运动训练', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (273, '文物与博物馆学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (274, '金融数学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (275, '中药资源与开发', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (276, '计算机信息管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (277, '化学工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (278, '网络安全与执法', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (279, '中国少数民族语言文学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (280, '环境生态工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (281, '连锁经营管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (282, '能源化学工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (283, '地质资源与地质工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (284, '通信技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (285, '会展策划与管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (286, '城市地下空间工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (287, '轻化工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (288, '艺术管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (289, '消防工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (290, '雕塑', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (291, '听力与言语康复学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (292, '舞蹈表演', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (293, '工程机械运用技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (294, '建筑设计', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (295, '影视摄影与制作', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (296, '虚拟现实应用技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (297, '监狱学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (298, '编辑出版学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (299, '海洋技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (300, '国际政治', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (301, '汽车制造与装配技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (302, '幼儿发展与健康管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (303, '语文教育', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (304, '外国语言文学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (305, '考古学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (306, '会计电算化', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (307, '航空航天工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (308, '食品卫生与营养学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (309, '卫生检验与检疫', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (310, '仪器科学与技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (311, '艺术与科技', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (312, '地球物理学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (313, '建筑工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (314, '少数民族预科班', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (315, '科学教育', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (316, '材料物理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (317, '移动互联应用技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (318, '轮机工程技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (319, '动画设计', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (320, '城市轨道交通机电技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (321, '金融管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (322, '世界史', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (323, '电子与通信工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (324, '音乐教育', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (325, '英语口译', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (326, '计算机科学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (327, '汽车服务与营销', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (328, '戏剧影视表演', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (329, '中医内科学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (330, '设计学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (331, '机械设计', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (332, '设施农业科学与工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (333, '广告艺术设计', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (334, '材料工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (335, '信息与通信工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (336, '控制工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (337, '油气储运工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (338, '新闻传播学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (339, '土木水利', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (340, '刑事侦查', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (341, '草业科学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (342, '运动人体科学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (343, '摄影', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (344, '影视编导', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (345, '临床药学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (346, '酿酒工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (347, '铁道信号自动控制', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (348, '化学工程与技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (349, '烹饪与营养教育', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (350, '交通运输工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (351, '种子科学与工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (352, '刑事科学技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (353, '资源与环境', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (354, '智能建造', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (355, '医学营养', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (356, '商务日语', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (357, '农村区域发展', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (358, '光学工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (359, '休闲体育', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (360, '制冷与空调技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (361, '矿物加工工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (362, '健康管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (363, '药品生产技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (364, '助产学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (365, '医学信息工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (366, '信息资源管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (367, '工业工程与管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (368, '社会体育指导与管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (369, '园艺技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (370, '金融科技', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (371, '司法信息安全', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (372, '口腔医学技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (373, '家政学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (374, '分析化学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (375, '公安管理学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (376, '电梯工程技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (377, '结构工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (378, '材料成型与控制技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (379, '阿拉伯语', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (380, '旅游管理与服务教育', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (381, '园林技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (382, '美术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (383, '眼视光技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (384, '高分子材料科学与工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (385, '空中乘务', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (386, '现代教育技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (387, '基础心理学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (388, '心理健康教育', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (389, '区域经济学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (390, '广播影视节目制作', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (391, '中国史', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (392, '英语教育', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (393, '物理化学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (394, '木材科学与工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (395, '飞机机电设备维修', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (396, '储能科学与工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (397, '体育', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (398, '数学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (399, '中医康复技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (400, '葡萄与葡萄酒工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (401, '动力工程及工程热物理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (402, '动物营养与饲料科学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (403, '有机化学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (404, '船舶电子电气工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (405, '中西医结合', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (406, '高速铁道工程技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (407, '应用数学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (408, '供热通风与空调工程技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (409, '体育经济与管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (410, '能源动力', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (411, '新闻采编与制作', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (412, '自然地理与资源环境', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (413, '农业机械化及其自动化', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (414, '马克思主义理论', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (415, '地图学与地理信息系统', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (416, '现代通信技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (417, '材料学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (418, '微电子技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (419, '农艺与种业', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (420, '艺术教育', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (421, '通信工程设计与监理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (422, '汽车运用与维修技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (423, '水文与水资源工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (424, '质量管理工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (425, '投资与理财', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (426, '烟草', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (427, '档案学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (428, '内科学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (429, '茶学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (430, '城市轨道交通工程技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (431, '风景园林设计', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (432, '水利水电建筑工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (433, '生物与医药', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (434, '中药制药', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (435, '铁道车辆', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (436, '民族学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (437, '机械设计与制造', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (438, '动车组检修技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (439, '智能电网信息工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (440, '中医骨伤科学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (441, '热能与动力工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (442, '国际金融', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (443, '农村发展', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (444, '网络新闻与传播', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (445, '建筑环境与设备工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (446, '船舶工程技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (447, '数字经济', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (448, '学科教学（英语）', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (449, '美术教育', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (450, '人文教育', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (451, '基础数学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (452, '发展与教育心理学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (453, '老年服务与管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (454, '儿科学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (455, '理论与应用力学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (456, '流行病与卫生统计学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (457, '教育管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (458, '现代纺织技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (459, '生物医药', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (460, '复合材料与工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (461, '导航工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (462, '信号与信息处理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (463, '海洋资源与环境', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (464, '林业', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (465, '情报学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (466, '电子与计算机工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (467, '消防工程技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (468, '酒店管理与数字化运营', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (469, '应用韩语', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (470, '空间信息与数字技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (471, '电信工程及管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (472, '广告设计与制作', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (473, '中西面点工艺', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (474, '涉外警务', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (475, '工业设计工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (476, '陶瓷艺术设计', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (477, '公共艺术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (478, '信息安全与管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (479, '电子应用技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (480, 'SQA国际本科', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (481, '管理科学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (482, '高速铁路客运乘务', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (483, '游戏设计', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (484, '戏剧影视导演', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (485, '法语语言文学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (486, '印地语', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (487, '漫画', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (488, '动画制作技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (489, '日语笔译', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (490, '表演', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (491, '建筑装饰工程技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (492, '西班牙语', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (493, '茶叶生产与加工技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (494, '康复医学与理疗学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (495, '交通运输管理与规划', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (496, '安全技术与管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (497, '老年保健与管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (498, '食品科学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (499, '地球化学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (500, '物流工程技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (501, '供用电技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (502, '眼视光医学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (503, '企业管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (504, '产业经济学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (505, '功能材料', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (506, '光源与照明', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (507, '环保设备工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (508, '贸易经济', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (509, '互联网金融', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (510, '建筑电气工程技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (511, '临床兽医学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (512, '植物科学与技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (513, '神经生物学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (514, '仪器仪表工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (515, '微电子学与固体电子学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (516, '文秘', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (517, '包装策划与设计', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (518, '应用化工', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (519, '休闲服务与管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (520, '中国古典文献学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (521, '外交学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (522, '计算机软件开发', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (523, '戏剧影视美术设计', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (524, '森林保护', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (525, '应急技术与管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (526, '畜牧学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (527, '智能控制技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (528, '农业建筑环境与能源工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (529, '数理基础科学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (530, '信用管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (531, '建筑设备工程技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (532, '水文与工程地质', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (533, '资源环境科学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (534, '控制理论与控制工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (535, '汽修检测与维修技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (536, '资源利用与植物保护', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (537, '智能医学工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (538, '英语笔译', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (539, '图书馆学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (540, '城市轨道交通供配电技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (541, '热能工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (542, '作物学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (543, '给排水工程技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (544, '建设工程监理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (545, '果树学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (546, '房地产开发与管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (547, '视觉传播设计与制作', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (548, '科学技术哲学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (549, '中草药栽培与鉴定', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (550, '医学美容技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (551, '意大利语', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (552, '纺织材料与纺织品设计', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (553, '医学遗传学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (554, '商务管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (555, '计算机网络', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (556, '英语+西班牙语', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (557, '艺术学理论', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (558, '高压输配电线路施工运行与维护', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (559, '食品检验检测技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (560, '应用气象学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (561, '计算机软件技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (562, '森林工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (563, '法律文秘', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (564, '农业管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (565, '医疗器械维护与管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (566, '野生动物与自然保护区管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (567, '医学实验技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (568, '汽车检测与维修', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (569, '家具设计与工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (570, '交通管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (571, '警务指挥与战术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (572, '初等教育', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (573, '城市轨道交通运营管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (574, '农业电气化', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (575, '动漫设计', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (576, '服装艺术设计', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (577, '水利工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (578, '防灾减灾科学与工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (579, '国际组织与全球治理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (580, '艺术管理演唱', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (581, '探测制导与控制技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (582, '艺术设计学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (583, '司法警务', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (584, '婴幼儿托育服务与管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (585, '应用电子技术教育', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (586, '葡萄牙语', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (587, '学科教学（物理）', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (588, '学科教学（历史）', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (589, '社会医学与卫生事业管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (590, '市政工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (591, '飞机电子设备维修', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (592, '消防工程（应急救援方向）', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (593, '城市管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (594, '石油化工技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (595, '电子商务及法律', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (596, '蒙医学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (597, '信息技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (598, '铁道交通运营管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (599, '经济', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (600, '舞蹈编导', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (601, '视觉开发', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (602, '嵌入式技术与应用', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (603, '涉外护理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (604, '针灸推拿', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (605, '有机合成', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (606, '粮食工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (607, '量子计算', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (608, '化工生物技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (609, '现代模具制造', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (610, '数学统计', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (611, '旅游英语', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (612, '电子与电气工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (613, '建筑动画技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (614, '航空弹药技术与指挥', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (615, '航空电气工程及其自动化', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (616, '汽车电子技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (617, '发电厂及电力系统', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (618, '建筑工程检测技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (619, '统计', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (620, '环境与设备工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (621, '医学生物技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (622, '专业会计', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (623, '汉语', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (624, '计算机技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (625, '有色冶金技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (626, '计算机信息技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (627, '小儿内科', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (628, '电子商务+电子工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (629, '物理电子学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (630, '城市轨道车辆应用技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (631, '天文学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (632, '关务与外贸服务', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (633, '声像工程技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (634, '电气与信息工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (635, '助产', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (636, '草学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (637, '舞蹈学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (638, '音乐与舞蹈学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (639, '公共卫生', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (640, '芯片开发', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (641, '精神医学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (642, '职业卫生工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (643, '课程与教学论', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (644, '世界经济', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (645, '环境监测技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (646, '岩土工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (647, '计算机辅助设计与制造', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (648, '污染修复与生态工程技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (649, '燃料电池', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (650, '文典学院人文科学试验班', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (651, '药物分析', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (652, '光电子信息与技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (653, '烹饪工艺与营养', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (654, '系统理论', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (655, '信息系统管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (656, '飞行器制造技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (657, '生物医学信息学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (658, '保险', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (659, '凝聚态物理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (660, '铁道机车车辆制造与维护', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (661, '金融法', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (662, '汽车智能技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (663, '高分子材料加工技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (664, '税务', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (665, '高尔夫球运动与管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (666, '城市与区域规划', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (667, '应用日语', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (668, '国际关系和公共管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (669, '文物鉴定与修复', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (670, '金融学+应用数学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (671, '理化测试与质检技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (672, '歌剧美声演唱', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (673, '精密医疗器械技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (674, '海洋机器人', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (675, '生物与数学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (676, '人文地理学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (677, '中医妇科学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (678, '计算机网络安全', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (679, '基因与基因组', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (680, '法学+英语', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (681, '社会学+世界古代史', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (682, '空间科学与技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (683, '冶金材料', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (684, '宪法学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (685, '日语+软件工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (686, '职业技术教育', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (687, '光学电子科学与技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (688, '海关管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (689, '民航安全技术管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (690, '生物技术与食品工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (691, '现代农业技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (692, '计算机科学与智能系统', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (693, '植物检疫与农业生态健康', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (694, '历史教育', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (695, '妇幼保健医学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (696, '测量学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (697, '药品质量与安全', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (698, '商业经济学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (699, '导航、制导与控制', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (700, '城市设计', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (701, '智能机器人技术及应用', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (702, '英语教育与语言研究', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (703, '新一代电子信息技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (704, '民俗学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (705, '石油工程技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (706, '粒子物理与原子核物理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (707, '心理学与心理健康', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (708, '舞蹈艺术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time)
VALUES (709, '面议学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (710, '药物化学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (711, '光子学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (712, '军事学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (713, '审计', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (714, '物理教育', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (715, '社工工作', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (716, '海洋资源开发技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (717, '体能训练', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (718, '光伏材料加工与应用技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (719, '微生物学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (720, '刑事执行', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (721, '大地测量学与测量工程', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (722, '交互设计', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (723, '机场运行服务与管理', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (724, '应用社会学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (725, '电线电缆制造技术', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (726, '壁画', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (727, '设计工学', 0, '2024-02-23 14:49:57', '2024-02-23 14:49:57');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (728, '水路运输与海事管理', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (729, '武器发射工程', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (730, '蜂学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (731, '航空发动机制造工程', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (732, '价值链管理', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (733, '包装工程技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (734, '自动化生产设备应用', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (735, '理论物理', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (736, '俄语口译', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (737, '泰语', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (738, '储能材料技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (739, '制冷及低温工程', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (740, '国际贸易实务', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (741, '草坪科学与工程', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (742, '戏剧影视文学+广播电视编导', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (743, '矿物资源工程', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (744, '林业工程', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (745, '商科', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (746, '皮肤病与性病学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (747, '海洋生物学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (748, '语言学及应用语言学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (749, '超声医学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (750, '飞机维修', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (751, '城市与区域发展', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (752, '历史文献学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (753, '移动通信技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (754, '工程热物理', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (755, '可持续发展', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (756, '农业水土工程', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (757, '航天工程', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (758, '食品营养与健康', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (759, '国际经济与商法', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (760, '农村与区域发展', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (761, '航空电子设备维修', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (762, '公安视听技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (763, '印度尼西亚语', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (764, '工业分析与检验', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (765, '金属材料与热处理技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (766, '乌克兰语', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (767, '中国画', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (768, '营养与食品卫生学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (769, '国际政治经济', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (770, '神经病学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (771, '音乐科技与艺术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (772, '无机化学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (773, '创业与创新，市场', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (774, '马克思主义基本原理', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (775, '粮油储藏与检测', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (776, '人力资源管理与劳动关系', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (777, '古建筑工程技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (778, '生产技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (779, '食品营养与检测', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (780, '教育', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (781, '机电设备维修与管理', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (782, '计算机通信', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (783, '分子科学与工程', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (784, '非洲史', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (785, '应用分析', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (786, '口腔正畸学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (787, '资源勘察工程', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (788, '古生物学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (789, '有色金属智能冶金技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (790, '农业工程', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (791, '音乐剧', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (792, '企业艺术设计', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (793, '肿瘤学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (794, '房地产经营与估价', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (795, '长空创新班', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (796, '生理学、运动科学与营养学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (797, '自然资源学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (798, '化学工艺', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (799, '港口与航运管理', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (800, '水利水电工程技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (801, '辐射防护与核安全', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (802, '动物学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (803, '出版', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (804, '光电信息工程', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (805, '水声工程', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (806, '数据科学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (807, '区块链技术应用', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (808, '希腊语', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (809, '制药化学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (810, '电影学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (811, '精细化工', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (812, '国际法学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (813, '飞机发动机', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (814, '海洋化学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (815, '社区管理与服务', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (816, '汉语言', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (817, '安全科学与工程', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (818, '保密技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (819, '航空宇航推进理论与工程', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (820, '农业经济管理', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (821, '渔业发展', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (822, '社会科学试验班', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (823, '医学英语', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (824, '政治学理论', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (825, '光信息科学与技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (826, '农业昆虫与害虫防治', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (827, '融媒体技术与运营', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (828, '电气工程与智能控制', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (829, '邮政工程', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (830, '预科', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (831, '纳米科学与技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (832, '电子商务新媒体运营', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (833, '工学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (834, '矿物学、岩石学和矿床学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (835, '会计与金融分析', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (836, '矿山机电', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (837, '光学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (838, '矿井建设', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (839, '手语翻译', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (840, '社会科学交叉学科学习', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (841, '社区矫正', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (842, '文学研究科', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (843, '语言学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (844, '运筹学与控制论', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (845, '能源与动力', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (846, '空间工程', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (847, '国民经济管理', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (848, '材料物理与化学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (849, '城市轨道交通车辆制造与维护', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (850, '工网创新', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (851, '宝玉石鉴定与加工', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (852, '石油化工生产技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (853, '油画', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (854, '人类学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (855, '商务经济学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (856, '法学院', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (857, '动画交互媒体', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (858, '国际关系', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (859, '建筑智能化工程技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (860, '安全防范技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (861, '公安政治工作', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (862, '体育康复', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (863, '地球探测与信息技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (864, '森林学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (865, '比较文学与世界文学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (866, '戏剧学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (867, '家具设计与制造', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (868, '版面编辑与校对', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (869, '数字出版', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (870, '翻译学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (871, '时装设计', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (872, '食品营养', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (873, '酿酒技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (874, '中药制药技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (875, '林产化工', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (876, '电气控制及其自动化', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (877, '公路工程管理', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (878, '司法信息技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (879, '智能终端技术与应用', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (880, '计算机应用工程', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (881, '海事管理', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (882, '雷达工程', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (883, '步兵指挥边防', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (884, '网络空间安全执法技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (885, '飞行器维修技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (886, '道路与铁道工程', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (887, '精密仪器及机械', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (888, '汉语言文字学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (889, '首饰设计与工艺', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (890, '国际关系与世界历史', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (891, '室内设计', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (892, '中国哲学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (893, '表演艺术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (894, '公共卫生学院', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (895, '中医医史文献', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (896, '建筑装饰材料技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (897, '风力发电工程技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (898, '高铁乘务', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (899, '高等教育学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (900, '科技体育经济学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (901, '数字化设计与制造技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (902, '核化工与核燃料工程', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (903, '服装设计与工艺', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (904, '海洋渔业科学与技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (905, '大数据与财务管理', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (906, '建筑装饰与施工技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (907, '绿色食品生产与检验', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (908, '计量经济学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (909, '资源勘查工程+通信工程', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (910, '国际贸易', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (911, '商业分析', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (912, '会计与金融', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (913, '营养和食品管理', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (914, '装配式建筑工程技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (915, '实验艺术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (916, '法医学+法学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (917, '环境监测与控制技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (918, '水土保持与荒漠化防治', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (919, '建设工程管理', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (920, '戏剧教育', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (921, '印刷技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (922, '创新学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (923, '服装表演与设计', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (924, '核科学与核技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (925, '戏剧与影视学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (926, '材料工程技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (927, '商务数据分析与应用', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (928, '詹天佑学院', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (929, '应急管理', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (930, '民航运输', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (931, '跨境电子商务', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (932, '火灾勘察', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (933, '文物与博物馆', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (934, '移动商务', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (935, '园林工程技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (936, '工程学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (937, '钢琴调律', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (938, '地理空间信息工程', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (939, '信息对抗技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (940, '航空服务', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (941, '人工智能技术应用', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (942, '药品经营与管理', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (943, '物资采购与管理', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (944, '广播电视艺术学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (945, '药事管理', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (946, '电力系统自动化技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (947, '冰雪运动与管理', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (948, '飞行器控制与信息工程', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (949, '法学+金融', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (950, '法学+金融学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (951, '舞台灯光设计', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (952, '文物修复与保护', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (953, '统计与会计核算', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (954, '刑事侦查技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (955, '铁道供电技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (956, '新媒体艺术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (957, '工业工程技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (958, '药品生物技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (959, '金融服务与管理', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (960, '应用泰语', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (961, '电磁场与无线技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (962, '工业过程自动化技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (963, '政治学与行政学+新闻学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (964, '信息系统', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (965, '气象学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (966, '新媒体技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (967, '金融管理与实务', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (968, '学科教学（美术）', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (969, '学科教学（语文）', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (970, '学科教学（地理）', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (971, '学科教学（生物）', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (972, '首饰设计', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (973, '油料储运工程', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (974, '现代物流管理', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (975, '报关与国际货运', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (976, '轨道交通电气与控制', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (977, '数学媒体应用技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (978, '广播电视', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (979, '航空运营管理', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (980, '民航空中安全保卫', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (981, '眼视光学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (982, '反恐警务', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (983, '能源与环境系统工程', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (984, '交通设备与控制工程', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (985, '水务工程', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (986, '机械工艺技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (987, '舞台艺术设计与制作', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (988, '财务会计教育', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (989, '制药科学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (990, '公安学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (991, '司法警察学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (992, '国际邮轮乘务管理', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (993, '电子竞技运动与管理', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (994, '乌尔都语', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (995, '假肢矫形工程', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (996, '电脑艺术设计', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (997, '早期教育', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (998, '供应链管理', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (999, '智慧景区开发与管理', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (1000, '中医康复学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (1001, '小学语文教育', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (1002, '军队指挥学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (1003, '应用俄语', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (1004, '应用经济学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (1005, '古典文献学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (1006, '摄影测量与遥感技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (1007, '人工智能技术服务', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (1008, '大数据与智能工程', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (1009, '国学', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (1010, '水质科学与技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (1011, '体育运营与管理', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (1012, '艺术品鉴定与艺术市场', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (1013, '研学旅行管理与服务', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (1014, '汽车维修工程教育', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (1015, '标准化工程', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (1016, '航空飞行与指挥', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (1017, '工业与民用建筑', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (1018, '地质类', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (1019, '化妆品技术与管理', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (1020, '哈萨克语', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');
INSERT INTO spark_hire.major (id, major_name, post_num, create_time, update_time) VALUES (1021, '钢铁智能冶金技术', 0, '2024-02-23 14:49:58', '2024-02-23 14:49:58');

-- 行业数据
INSERT INTO spark_hire.industry_type (id, industry_type_name, post_num, create_time, update_time, is_delete) VALUES (1, '互联网/AI', 0, '2025-07-06 14:13:52', '2025-07-06 14:13:52', 0);
INSERT INTO spark_hire.industry_type (id, industry_type_name, post_num, create_time, update_time, is_delete) VALUES (2, '广告/传媒/文化/体育', 0, '2025-07-06 14:13:52', '2025-07-06 14:13:52', 0);
INSERT INTO spark_hire.industry_type (id, industry_type_name, post_num, create_time, update_time, is_delete) VALUES (3, '金融', 0, '2025-07-06 14:13:52', '2025-07-06 14:13:52', 0);
INSERT INTO spark_hire.industry_type (id, industry_type_name, post_num, create_time, update_time, is_delete) VALUES (4, '教育培训', 0, '2025-07-06 14:13:52', '2025-07-06 14:13:52', 0);
INSERT INTO spark_hire.industry_type (id, industry_type_name, post_num, create_time, update_time, is_delete) VALUES (5, '制药/医疗', 0, '2025-07-06 14:13:52', '2025-07-06 14:13:52', 0);
INSERT INTO spark_hire.industry_type (id, industry_type_name, post_num, create_time, update_time, is_delete) VALUES (6, '交通运输/物流', 0, '2025-07-06 14:13:52', '2025-07-06 14:13:52', 0);
INSERT INTO spark_hire.industry_type (id, industry_type_name, post_num, create_time, update_time, is_delete) VALUES (7, '专业服务', 0, '2025-07-06 14:13:52', '2025-07-06 14:13:52', 0);
INSERT INTO spark_hire.industry_type (id, industry_type_name, post_num, create_time, update_time, is_delete) VALUES (8, '房地产/建筑', 0, '2025-07-06 14:13:52', '2025-07-06 14:13:52', 0);
INSERT INTO spark_hire.industry_type (id, industry_type_name, post_num, create_time, update_time, is_delete) VALUES (9, '汽车', 0, '2025-07-06 14:13:52', '2025-07-06 14:13:52', 0);
INSERT INTO spark_hire.industry_type (id, industry_type_name, post_num, create_time, update_time, is_delete) VALUES (10, '制造业', 0, '2025-07-06 14:13:52', '2025-07-06 14:13:52', 0);
INSERT INTO spark_hire.industry_type (id, industry_type_name, post_num, create_time, update_time, is_delete) VALUES (11, '消费品/批发/零售', 0, '2025-07-06 14:13:52', '2025-07-06 14:13:52', 0);
INSERT INTO spark_hire.industry_type (id, industry_type_name, post_num, create_time, update_time, is_delete) VALUES (12, '服务业', 0, '2025-07-06 14:13:52', '2025-07-06 14:13:52', 0);
INSERT INTO spark_hire.industry_type (id, industry_type_name, post_num, create_time, update_time, is_delete) VALUES (13, '能源/化工/环保', 0, '2025-07-06 14:13:52', '2025-07-06 14:13:52', 0);
INSERT INTO spark_hire.industry_type (id, industry_type_name, post_num, create_time, update_time, is_delete) VALUES (14, '政府/非赢利机构/其他', 0, '2025-07-06 14:13:52', '2025-07-06 14:13:52', 0);
INSERT INTO spark_hire.industry_type (id, industry_type_name, post_num, create_time, update_time, is_delete) VALUES (15, '电子/通信/半导体', 0, '2025-07-06 14:13:52', '2025-07-06 14:13:52', 0);



INSERT INTO spark_hire.industry (id, industry_name, industry_type, post_num, create_time, update_time, is_delete) VALUES (1, '电子商务', 1, 0, '2025-07-06 14:14:24', '2025-07-06 14:14:24', 0);
INSERT INTO spark_hire.industry (id, industry_name, industry_type, post_num, create_time, update_time, is_delete) VALUES (2, '游戏', 1, 0, '2025-07-06 14:14:24', '2025-07-06 14:14:24', 0);
INSERT INTO spark_hire.industry (id, industry_name, industry_type, post_num, create_time, update_time, is_delete) VALUES (3, '社交网络与媒体', 1, 0, '2025-07-06 14:14:24', '2025-07-06 14:14:24', 0);
INSERT INTO spark_hire.industry (id, industry_name, industry_type, post_num, create_time, update_time, is_delete) VALUES (4, '广告营销', 1, 0, '2025-07-06 14:14:24', '2025-07-06 14:14:24', 0);
INSERT INTO spark_hire.industry (id, industry_name, industry_type, post_num, create_time, update_time, is_delete) VALUES (5, '大数据', 1, 0, '2025-07-06 14:14:24', '2025-07-06 14:14:24', 0);
INSERT INTO spark_hire.industry (id, industry_name, industry_type, post_num, create_time, update_time, is_delete) VALUES (6, '医疗健康', 1, 0, '2025-07-06 14:14:24', '2025-07-06 14:14:24', 0);
INSERT INTO spark_hire.industry (id, industry_name, industry_type, post_num, create_time, update_time, is_delete) VALUES (7, '生活服务（O2O）', 1, 0, '2025-07-06 14:14:24', '2025-07-06 14:14:24', 0);
INSERT INTO spark_hire.industry (id, industry_name, industry_type, post_num, create_time, update_time, is_delete) VALUES (8, '在线教育', 1, 0, '2025-07-06 14:14:24', '2025-07-06 14:14:24', 0);
INSERT INTO spark_hire.industry (id, industry_name, industry_type, post_num, create_time, update_time, is_delete) VALUES (9, '企业服务', 1, 0, '2025-07-06 14:14:24', '2025-07-06 14:14:24', 0);
INSERT INTO spark_hire.industry (id, industry_name, industry_type, post_num, create_time, update_time, is_delete) VALUES (10, '信息安全', 1, 0, '2025-07-06 14:14:24', '2025-07-06 14:14:24', 0);
INSERT INTO spark_hire.industry (id, industry_name, industry_type, post_num, create_time, update_time, is_delete) VALUES (11, '新零售', 1, 0, '2025-07-06 14:14:24', '2025-07-06 14:14:24', 0);
INSERT INTO spark_hire.industry (id, industry_name, industry_type, post_num, create_time, update_time, is_delete) VALUES (12, '互联网', 1, 0, '2025-07-06 14:14:24', '2025-07-06 14:14:24', 0);
INSERT INTO spark_hire.industry (id, industry_name, industry_type, post_num, create_time, update_time, is_delete) VALUES (13, '计算机软件', 1, 0, '2025-07-06 14:14:24', '2025-07-06 14:14:24', 0);
INSERT INTO spark_hire.industry (id, industry_name, industry_type, post_num, create_time, update_time, is_delete) VALUES (14, '计算机服务', 1, 0, '2025-07-06 14:14:24', '2025-07-06 14:14:24', 0);
INSERT INTO spark_hire.industry (id, industry_name, industry_type, post_num, create_time, update_time, is_delete) VALUES (15, '电子/半导体/集成电路', 1, 0, '2025-07-06 14:14:24', '2025-07-06 14:14:24', 0);
INSERT INTO spark_hire.industry (id, industry_name, industry_type, post_num, create_time, update_time, is_delete) VALUES (16, '人工智能', 1, 0, '2025-07-06 14:14:24', '2025-07-06 14:14:24', 0);
INSERT INTO spark_hire.industry (id, industry_name, industry_type, post_num, create_time, update_time, is_delete) VALUES (17, '云计算', 1, 0, '2025-07-06 14:14:24', '2025-07-06 14:14:24', 0);
INSERT INTO spark_hire.industry (id, industry_name, industry_type, post_num, create_time, update_time, is_delete) VALUES (18, '物联网', 1, 0, '2025-07-06 14:14:24', '2025-07-06 14:14:24', 0);
INSERT INTO spark_hire.industry (id, industry_name, industry_type, post_num, create_time, update_time, is_delete) VALUES (19, '广告/公关/会展', 2, 0, '2025-07-06 14:14:24', '2025-07-06 14:14:24', 0);
INSERT INTO spark_hire.industry (id, industry_name, industry_type, post_num, create_time, update_time, is_delete) VALUES (20, '新闻/出版', 2, 0, '2025-07-06 14:14:24', '2025-07-06 14:14:24', 0);
INSERT INTO spark_hire.industry (id, industry_name, industry_type, post_num, create_time, update_time, is_delete) VALUES (21, '广播/影视', 2, 0, '2025-07-06 14:14:24', '2025-07-06 14:14:24', 0);
INSERT INTO spark_hire.industry (id, industry_name, industry_type, post_num, create_time, update_time, is_delete) VALUES (22, '文化艺术/娱乐', 2, 0, '2025-07-06 14:14:24', '2025-07-06 14:14:24', 0);
INSERT INTO spark_hire.industry (id, industry_name, industry_type, post_num, create_time, update_time, is_delete) VALUES (23, '体育', 2, 0, '2025-07-06 14:14:24', '2025-07-06 14:14:24', 0);
INSERT INTO spark_hire.industry (id, industry_name, industry_type, post_num, create_time, update_time, is_delete) VALUES (24, '银行', 3, 0, '2025-07-06 14:14:24', '2025-07-06 14:14:24', 0);
INSERT INTO spark_hire.industry (id, industry_name, industry_type, post_num, create_time, update_time, is_delete) VALUES (25, '保险', 3, 0, '2025-07-06 14:14:24', '2025-07-06 14:14:24', 0);


INSERT INTO spark_hire.career_type (id, career_type_name, post_num, create_time, update_time, is_delete) VALUES (1, '互联网/AI', 0, '2024-02-24 21:09:42', '2024-02-24 21:09:42', 0);
INSERT INTO spark_hire.career_type (id, career_type_name, post_num, create_time, update_time, is_delete) VALUES (2, '产品', 0, '2024-02-24 21:09:42', '2024-02-24 21:09:42', 0);
INSERT INTO spark_hire.career_type (id, career_type_name, post_num, create_time, update_time, is_delete) VALUES (3, '运营/客服', 0, '2024-02-24 21:09:42', '2024-02-24 21:09:42', 0);
INSERT INTO spark_hire.career_type (id, career_type_name, post_num, create_time, update_time, is_delete) VALUES (4, '设计', 0, '2024-02-24 21:09:42', '2024-02-24 21:09:42', 0);
INSERT INTO spark_hire.career_type (id, career_type_name, post_num, create_time, update_time, is_delete) VALUES (5, '影视/传媒', 0, '2024-02-24 21:09:42', '2024-02-24 21:09:42', 0);
INSERT INTO spark_hire.career_type (id, career_type_name, post_num, create_time, update_time, is_delete) VALUES (6, '人力/行政/法务', 0, '2024-02-24 21:09:42', '2024-02-24 21:09:42', 0);
INSERT INTO spark_hire.career_type (id, career_type_name, post_num, create_time, update_time, is_delete) VALUES (7, '财务/审计/税务', 0, '2024-02-24 21:09:42', '2024-02-24 21:09:42', 0);
INSERT INTO spark_hire.career_type (id, career_type_name, post_num, create_time, update_time, is_delete) VALUES (8, '咨询/翻译/法律', 0, '2024-02-24 21:09:42', '2024-02-24 21:09:42', 0);
INSERT INTO spark_hire.career_type (id, career_type_name, post_num, create_time, update_time, is_delete) VALUES (9, '教育培训', 0, '2024-02-24 21:09:42', '2024-02-24 21:09:42', 0);
INSERT INTO spark_hire.career_type (id, career_type_name, post_num, create_time, update_time, is_delete) VALUES (10, '销售 ', 0, '2024-02-24 21:09:42', '2024-02-24 21:09:42', 0);
INSERT INTO spark_hire.career_type (id, career_type_name, post_num, create_time, update_time, is_delete) VALUES (11, '供应链/物流', 0, '2024-02-24 21:09:42', '2024-02-24 21:09:42', 0);
INSERT INTO spark_hire.career_type (id, career_type_name, post_num, create_time, update_time, is_delete) VALUES (12, '房地产/建筑', 0, '2024-02-24 21:09:42', '2024-02-24 21:09:42', 0);
INSERT INTO spark_hire.career_type (id, career_type_name, post_num, create_time, update_time, is_delete) VALUES (13, '医疗健康', 0, '2024-02-24 21:09:42', '2024-02-24 21:09:42', 0);
INSERT INTO spark_hire.career_type (id, career_type_name, post_num, create_time, update_time, is_delete) VALUES (14, '酒店/旅游', 0, '2024-02-24 21:09:42', '2024-02-24 21:09:42', 0);
INSERT INTO spark_hire.career_type (id, career_type_name, post_num, create_time, update_time, is_delete) VALUES (15, '汽车', 0, '2024-02-24 21:09:42', '2024-02-24 21:09:42', 0);
INSERT INTO spark_hire.career_type (id, career_type_name, post_num, create_time, update_time, is_delete) VALUES (16, '生产制造', 0, '2024-02-24 21:09:42', '2024-02-24 21:09:42', 0);
INSERT INTO spark_hire.career_type (id, career_type_name, post_num, create_time, update_time, is_delete) VALUES (17, '电子/电气/通信', 0, '2024-02-24 21:09:42', '2024-02-24 21:09:42', 0);
INSERT INTO spark_hire.career_type (id, career_type_name, post_num, create_time, update_time, is_delete) VALUES (18, '采购/贸易', 0, '2024-02-24 21:09:42', '2024-02-24 21:09:42', 0);
INSERT INTO spark_hire.career_type (id, career_type_name, post_num, create_time, update_time, is_delete) VALUES (19, '市场/公关/广告', 0, '2024-02-24 21:09:42', '2024-02-24 21:09:42', 0);
INSERT INTO spark_hire.career_type (id, career_type_name, post_num, create_time, update_time, is_delete) VALUES (20, '生活服务/零售', 0, '2024-02-24 21:09:42', '2024-02-24 21:09:42', 0);
INSERT INTO spark_hire.career_type (id, career_type_name, post_num, create_time, update_time, is_delete) VALUES (21, '餐饮', 0, '2024-02-24 21:09:42', '2024-02-24 21:09:42', 0);
INSERT INTO spark_hire.career_type (id, career_type_name, post_num, create_time, update_time, is_delete) VALUES (22, '能源/环保/农业', 0, '2024-02-24 21:09:42', '2024-02-24 21:09:42', 0);
INSERT INTO spark_hire.career_type (id, career_type_name, post_num, create_time, update_time, is_delete) VALUES (23, '金融', 0, '2024-02-24 21:09:42', '2024-02-24 21:09:42', 0);

-- 城市
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (1, '北京市', 1, 0, '2024-02-26 12:22:10', '2024-02-26 12:22:10', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (2, '石家庄市', 3, 0, '2024-02-26 12:22:54', '2024-02-26 12:35:33', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (3, '唐山市', 3, 0, '2024-02-26 12:22:54', '2024-02-26 12:35:33', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (4, '秦皇岛市', 3, 0, '2024-02-26 12:22:54', '2024-02-26 12:35:33', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (5, '邯郸市', 3, 0, '2024-02-26 12:22:54', '2024-02-26 12:35:33', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (6, '邢台市', 3, 0, '2024-02-26 12:22:54', '2024-02-26 12:35:33', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (7, '保定市', 3, 0, '2024-02-26 12:22:54', '2024-02-26 12:35:33', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (8, '张家口市', 3, 0, '2024-02-26 12:22:54', '2024-02-26 12:35:33', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (9, '承德市', 3, 0, '2024-02-26 12:22:54', '2024-02-26 12:35:33', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (10, '沧州市', 3, 0, '2024-02-26 12:22:54', '2024-02-26 12:35:33', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (11, '廊坊市', 3, 0, '2024-02-26 12:22:54', '2024-02-26 12:35:33', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (12, '衡水市', 3, 0, '2024-02-26 12:22:54', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (13, '太原市', 4, 0, '2024-02-26 12:24:36', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (14, '大同市', 4, 0, '2024-02-26 12:24:36', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (15, '阳泉市', 4, 0, '2024-02-26 12:24:36', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (16, '长治市', 4, 0, '2024-02-26 12:24:36', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (17, '晋城市', 4, 0, '2024-02-26 12:24:36', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (18, '朔州市', 4, 0, '2024-02-26 12:24:36', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (19, '晋中市', 4, 0, '2024-02-26 12:24:36', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (20, '运城市', 4, 0, '2024-02-26 12:24:36', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (21, '忻州市', 4, 0, '2024-02-26 12:24:36', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (22, '临汾市', 4, 0, '2024-02-26 12:24:36', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (23, '吕梁市', 4, 0, '2024-02-26 12:24:36', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (24, '呼和浩特市', 5, 0, '2024-02-26 12:25:05', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (25, '包头市', 5, 0, '2024-02-26 12:25:05', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (26, '乌海市', 5, 0, '2024-02-26 12:25:05', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (27, '赤峰市', 5, 0, '2024-02-26 12:25:05', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (28, '通辽市', 5, 0, '2024-02-26 12:25:05', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (29, '鄂尔多斯市', 5, 0, '2024-02-26 12:25:05', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (30, '呼伦贝尔市', 5, 0, '2024-02-26 12:25:05', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (31, '巴彦淖尔市', 5, 0, '2024-02-26 12:25:05', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (32, '乌兰察布市', 5, 0, '2024-02-26 12:25:05', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (33, '兴安盟', 5, 0, '2024-02-26 12:25:05', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (34, '锡林郭勒盟', 5, 0, '2024-02-26 12:25:05', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (35, '阿拉善盟', 5, 0, '2024-02-26 12:25:05', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (36, '沈阳市', 6, 0, '2024-02-26 12:25:28', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (37, '大连市', 6, 0, '2024-02-26 12:25:28', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (38, '鞍山市', 6, 0, '2024-02-26 12:25:28', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (39, '抚顺市', 6, 0, '2024-02-26 12:25:28', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (40, '本溪市', 6, 0, '2024-02-26 12:25:28', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (41, '丹东市', 6, 0, '2024-02-26 12:25:28', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (42, '锦州市', 6, 0, '2024-02-26 12:25:28', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (43, '营口市', 6, 0, '2024-02-26 12:25:28', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (44, '阜新市', 6, 0, '2024-02-26 12:25:28', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (45, '辽阳市', 6, 0, '2024-02-26 12:25:28', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (46, '盘锦市', 6, 0, '2024-02-26 12:25:28', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (47, '铁岭市', 6, 0, '2024-02-26 12:25:28', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (48, '朝阳市', 6, 0, '2024-02-26 12:25:28', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (49, '葫芦岛市', 6, 0, '2024-02-26 12:25:28', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (50, '长春市', 7, 0, '2024-02-26 12:25:52', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (51, '吉林市', 7, 0, '2024-02-26 12:25:52', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (52, '四平市', 7, 0, '2024-02-26 12:25:52', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (53, '辽源市', 7, 0, '2024-02-26 12:25:52', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (54, '通化市', 7, 0, '2024-02-26 12:25:52', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (55, '白山市', 7, 0, '2024-02-26 12:25:52', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (56, '松原市', 7, 0, '2024-02-26 12:25:52', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (57, '白城市', 7, 0, '2024-02-26 12:25:52', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (58, '延边朝鲜族自治州', 7, 0, '2024-02-26 12:25:52', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (59, '哈尔滨市', 8, 0, '2024-02-26 12:26:25', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (60, '齐齐哈尔市', 8, 0, '2024-02-26 12:26:25', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (61, '鸡西市', 8, 0, '2024-02-26 12:26:25', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (62, '鹤岗市', 8, 0, '2024-02-26 12:26:25', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (63, '双鸭山市', 8, 0, '2024-02-26 12:26:25', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (64, '大庆市', 8, 0, '2024-02-26 12:26:25', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (65, '伊春市', 8, 0, '2024-02-26 12:26:25', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (66, '佳木斯市', 8, 0, '2024-02-26 12:26:25', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (67, '七台河市', 8, 0, '2024-02-26 12:26:25', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (68, '牡丹江市', 8, 0, '2024-02-26 12:26:25', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (69, '黑河市', 8, 0, '2024-02-26 12:26:25', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (70, '绥化市', 8, 0, '2024-02-26 12:26:25', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (71, '大兴安岭地区', 8, 0, '2024-02-26 12:26:25', '2024-02-26 12:37:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (72, '上海市', 9, 0, '2024-02-26 12:27:58', '2024-02-26 12:36:03', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (73, '南京市', 10, 0, '2024-02-26 12:28:25', '2024-02-26 12:35:25', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (74, '无锡市', 10, 0, '2024-02-26 12:28:25', '2024-02-26 12:35:25', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (75, '徐州市', 10, 0, '2024-02-26 12:28:25', '2024-02-26 12:35:25', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (76, '常州市', 10, 0, '2024-02-26 12:28:25', '2024-02-26 12:35:25', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (77, '苏州市', 10, 0, '2024-02-26 12:28:25', '2024-02-26 12:35:25', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (78, '南通市', 10, 0, '2024-02-26 12:28:25', '2024-02-26 12:35:25', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (79, '连云港市', 10, 0, '2024-02-26 12:28:25', '2024-02-26 12:35:25', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (80, '淮安市', 10, 0, '2024-02-26 12:28:25', '2024-02-26 12:35:25', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (81, '盐城市', 10, 0, '2024-02-26 12:28:25', '2024-02-26 12:35:25', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (82, '扬州市', 10, 0, '2024-02-26 12:28:25', '2024-02-26 12:35:25', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (83, '镇江市', 10, 0, '2024-02-26 12:28:25', '2024-02-26 12:35:25', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (84, '泰州市', 10, 0, '2024-02-26 12:28:25', '2024-02-26 12:35:25', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (85, '宿迁市', 10, 0, '2024-02-26 12:28:25', '2024-02-26 12:35:25', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (86, '杭州市', 11, 0, '2024-02-26 12:28:48', '2024-02-26 12:35:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (87, '宁波市', 11, 0, '2024-02-26 12:28:48', '2024-02-26 12:35:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (88, '温州市', 11, 0, '2024-02-26 12:28:48', '2024-02-26 12:35:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (89, '嘉兴市', 11, 0, '2024-02-26 12:28:48', '2024-02-26 12:35:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (90, '湖州市', 11, 0, '2024-02-26 12:28:48', '2024-02-26 12:35:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (91, '绍兴市', 11, 0, '2024-02-26 12:28:48', '2024-02-26 12:35:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (92, '金华市', 11, 0, '2024-02-26 12:28:48', '2024-02-26 12:35:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (93, '衢州市', 11, 0, '2024-02-26 12:28:48', '2024-02-26 12:35:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (94, '舟山市', 11, 0, '2024-02-26 12:28:48', '2024-02-26 12:35:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (95, '台州市', 11, 0, '2024-02-26 12:28:48', '2024-02-26 12:35:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (96, '丽水市', 11, 0, '2024-02-26 12:28:48', '2024-02-26 12:35:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (97, '合肥市', 12, 0, '2024-02-26 12:29:18', '2024-02-26 12:35:12', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (98, '芜湖市', 12, 0, '2024-02-26 12:29:18', '2024-02-26 12:35:12', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (99, '蚌埠市', 12, 0, '2024-02-26 12:29:18', '2024-02-26 12:35:12', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (100, '淮南市', 12, 0, '2024-02-26 12:29:18', '2024-02-26 12:35:12', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (101, '马鞍山市', 12, 0, '2024-02-26 12:29:18', '2024-02-26 12:35:12', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (102, '淮北市', 12, 0, '2024-02-26 12:29:18', '2024-02-26 12:35:12', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (103, '铜陵市', 12, 0, '2024-02-26 12:29:18', '2024-02-26 12:35:12', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (104, '安庆市', 12, 0, '2024-02-26 12:29:18', '2024-02-26 12:35:12', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (105, '黄山市', 12, 0, '2024-02-26 12:29:18', '2024-02-26 12:35:12', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (106, '滁州市', 12, 0, '2024-02-26 12:29:18', '2024-02-26 12:35:12', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (107, '阜阳市', 12, 0, '2024-02-26 12:29:18', '2024-02-26 12:35:12', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (108, '宿州市', 12, 0, '2024-02-26 12:29:18', '2024-02-26 12:35:12', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (109, '巢湖市', 12, 0, '2024-02-26 12:29:18', '2024-02-26 12:35:12', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (110, '六安市', 12, 0, '2024-02-26 12:29:18', '2024-02-26 12:35:12', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (111, '亳州市', 12, 0, '2024-02-26 12:29:18', '2024-02-26 12:35:12', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (112, '池州市', 12, 0, '2024-02-26 12:29:18', '2024-02-26 12:35:12', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (113, '宣城市', 12, 0, '2024-02-26 12:29:18', '2024-02-26 12:35:12', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (114, '福州市', 13, 0, '2024-02-26 12:29:39', '2024-02-26 12:35:04', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (115, '厦门市', 13, 0, '2024-02-26 12:29:39', '2024-02-26 12:35:04', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (116, '莆田市', 13, 0, '2024-02-26 12:29:39', '2024-02-26 12:35:04', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (117, '三明市', 13, 0, '2024-02-26 12:29:39', '2024-02-26 12:35:04', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (118, '泉州市', 13, 0, '2024-02-26 12:29:39', '2024-02-26 12:35:04', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (119, '漳州市', 13, 0, '2024-02-26 12:29:39', '2024-02-26 12:35:04', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (120, '南平市', 13, 0, '2024-02-26 12:29:39', '2024-02-26 12:35:04', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (121, '龙岩市', 13, 0, '2024-02-26 12:29:39', '2024-02-26 12:35:04', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (122, '宁德市', 13, 0, '2024-02-26 12:29:39', '2024-02-26 12:35:04', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (123, '南昌市', 14, 0, '2024-02-26 12:30:03', '2024-02-26 12:34:41', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (124, '景德镇市', 14, 0, '2024-02-26 12:30:03', '2024-02-26 12:34:41', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (125, '萍乡市', 14, 0, '2024-02-26 12:30:03', '2024-02-26 12:34:41', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (126, '九江市', 14, 0, '2024-02-26 12:30:03', '2024-02-26 12:34:41', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (127, '新余市', 14, 0, '2024-02-26 12:30:03', '2024-02-26 12:34:41', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (128, '鹰潭市', 14, 0, '2024-02-26 12:30:03', '2024-02-26 12:34:41', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (129, '赣州市', 14, 0, '2024-02-26 12:30:03', '2024-02-26 12:34:41', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (130, '吉安市', 14, 0, '2024-02-26 12:30:03', '2024-02-26 12:34:41', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (131, '宜春市', 14, 0, '2024-02-26 12:30:03', '2024-02-26 12:34:41', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (132, '抚州市', 14, 0, '2024-02-26 12:30:03', '2024-02-26 12:34:41', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (133, '上饶市', 14, 0, '2024-02-26 12:30:03', '2024-02-26 12:34:41', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (134, '济南市', 15, 0, '2024-02-26 12:30:19', '2024-02-26 12:34:27', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (135, '青岛市', 15, 0, '2024-02-26 12:30:19', '2024-02-26 12:34:27', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (136, '淄博市', 15, 0, '2024-02-26 12:30:19', '2024-02-26 12:34:27', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (137, '枣庄市', 15, 0, '2024-02-26 12:30:19', '2024-02-26 12:34:27', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (138, '东营市', 15, 0, '2024-02-26 12:30:19', '2024-02-26 12:34:27', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (139, '烟台市', 15, 0, '2024-02-26 12:30:19', '2024-02-26 12:34:27', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (140, '潍坊市', 15, 0, '2024-02-26 12:30:19', '2024-02-26 12:34:27', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (141, '济宁市', 15, 0, '2024-02-26 12:30:19', '2024-02-26 12:34:27', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (142, '泰安市', 15, 0, '2024-02-26 12:30:19', '2024-02-26 12:34:27', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (143, '威海市', 15, 0, '2024-02-26 12:30:19', '2024-02-26 12:34:27', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (144, '日照市', 15, 0, '2024-02-26 12:30:19', '2024-02-26 12:34:27', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (145, '莱芜市', 15, 0, '2024-02-26 12:30:19', '2024-02-26 12:34:27', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (146, '临沂市', 15, 0, '2024-02-26 12:30:19', '2024-02-26 12:34:27', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (147, '德州市', 15, 0, '2024-02-26 12:30:19', '2024-02-26 12:34:27', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (148, '聊城市', 15, 0, '2024-02-26 12:30:19', '2024-02-26 12:34:27', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (149, '滨州市', 15, 0, '2024-02-26 12:30:19', '2024-02-26 12:34:27', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (150, '荷泽市', 15, 0, '2024-02-26 12:30:37', '2024-02-26 12:34:27', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (151, '郑州市', 16, 0, '2024-02-26 12:31:02', '2024-02-26 12:34:20', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (152, '开封市', 16, 0, '2024-02-26 12:31:02', '2024-02-26 12:34:20', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (153, '洛阳市', 16, 0, '2024-02-26 12:31:02', '2024-02-26 12:34:20', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (154, '平顶山市', 16, 0, '2024-02-26 12:31:02', '2024-02-26 12:34:20', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (155, '安阳市', 16, 0, '2024-02-26 12:31:02', '2024-02-26 12:34:20', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (156, '鹤壁市', 16, 0, '2024-02-26 12:31:02', '2024-02-26 12:34:20', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (157, '新乡市', 16, 0, '2024-02-26 12:31:02', '2024-02-26 12:34:20', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (158, '焦作市', 16, 0, '2024-02-26 12:31:02', '2024-02-26 12:34:20', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (159, '濮阳市', 16, 0, '2024-02-26 12:31:02', '2024-02-26 12:34:20', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (160, '许昌市', 16, 0, '2024-02-26 12:31:02', '2024-02-26 12:34:20', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (161, '漯河市', 16, 0, '2024-02-26 12:31:02', '2024-02-26 12:34:20', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (162, '三门峡市', 16, 0, '2024-02-26 12:31:02', '2024-02-26 12:34:20', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (163, '南阳市', 16, 0, '2024-02-26 12:31:02', '2024-02-26 12:34:20', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (164, '商丘市', 16, 0, '2024-02-26 12:31:02', '2024-02-26 12:34:20', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (165, '信阳市', 16, 0, '2024-02-26 12:31:02', '2024-02-26 12:34:20', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (166, '周口市', 16, 0, '2024-02-26 12:31:02', '2024-02-26 12:34:20', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (167, '驻马店市', 16, 0, '2024-02-26 12:31:02', '2024-02-26 12:34:20', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (168, '武汉市', 17, 0, '2024-02-26 12:32:47', '2024-02-26 12:34:00', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (169, '黄石市', 17, 0, '2024-02-26 12:32:47', '2024-02-26 12:34:00', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (170, '十堰市', 17, 0, '2024-02-26 12:32:47', '2024-02-26 12:34:00', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (171, '宜昌市', 17, 0, '2024-02-26 12:32:47', '2024-02-26 12:34:00', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (172, '襄樊市', 17, 0, '2024-02-26 12:32:47', '2024-02-26 12:34:00', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (173, '鄂州市', 17, 0, '2024-02-26 12:32:47', '2024-02-26 12:34:00', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (174, '荆门市', 17, 0, '2024-02-26 12:32:47', '2024-02-26 12:34:00', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (175, '孝感市', 17, 0, '2024-02-26 12:32:47', '2024-02-26 12:34:00', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (176, '荆州市', 17, 0, '2024-02-26 12:32:47', '2024-02-26 12:34:00', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (177, '黄冈市', 17, 0, '2024-02-26 12:32:47', '2024-02-26 12:34:00', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (178, '咸宁市', 17, 0, '2024-02-26 12:32:47', '2024-02-26 12:34:00', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (179, '随州市', 17, 0, '2024-02-26 12:32:47', '2024-02-26 12:34:00', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (180, '恩施土家族苗族自治州', 17, 0, '2024-02-26 12:32:47', '2024-02-26 12:34:00', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (181, '省直辖行政单位', 17, 0, '2024-02-26 12:32:47', '2024-02-26 12:34:00', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (182, '长沙市', 18, 0, '2024-02-26 12:33:24', '2024-02-26 12:33:48', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (183, '株洲市', 18, 0, '2024-02-26 12:33:24', '2024-02-26 12:33:48', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (184, '湘潭市', 18, 0, '2024-02-26 12:33:24', '2024-02-26 12:33:48', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (185, '衡阳市', 18, 0, '2024-02-26 12:33:24', '2024-02-26 12:33:48', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (186, '邵阳市', 18, 0, '2024-02-26 12:33:24', '2024-02-26 12:33:48', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (187, '岳阳市', 18, 0, '2024-02-26 12:33:24', '2024-02-26 12:33:48', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (188, '常德市', 18, 0, '2024-02-26 12:33:24', '2024-02-26 12:33:48', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (189, '张家界市', 18, 0, '2024-02-26 12:33:24', '2024-02-26 12:33:48', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (190, '益阳市', 18, 0, '2024-02-26 12:33:24', '2024-02-26 12:33:48', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (191, '郴州市', 18, 0, '2024-02-26 12:33:24', '2024-02-26 12:33:48', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (192, '永州市', 18, 0, '2024-02-26 12:33:24', '2024-02-26 12:33:48', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (193, '怀化市', 18, 0, '2024-02-26 12:33:24', '2024-02-26 12:33:48', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (194, '娄底市', 18, 0, '2024-02-26 12:33:24', '2024-02-26 12:33:48', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (195, '湘西土家族苗族自治州', 18, 0, '2024-02-26 12:33:24', '2024-02-26 12:33:48', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (196, '广州市', 19, 0, '2024-02-26 12:38:05', '2024-02-26 12:38:05', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (197, '韶关市', 19, 0, '2024-02-26 12:38:05', '2024-02-26 12:38:05', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (198, '深圳市', 19, 0, '2024-02-26 12:38:05', '2024-02-26 12:38:05', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (199, '珠海市', 19, 0, '2024-02-26 12:38:05', '2024-02-26 12:38:05', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (200, '汕头市', 19, 0, '2024-02-26 12:38:05', '2024-02-26 12:38:05', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (201, '佛山市', 19, 0, '2024-02-26 12:38:05', '2024-02-26 12:38:05', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (202, '江门市', 19, 0, '2024-02-26 12:38:05', '2024-02-26 12:38:05', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (203, '湛江市', 19, 0, '2024-02-26 12:38:05', '2024-02-26 12:38:05', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (204, '茂名市', 19, 0, '2024-02-26 12:38:05', '2024-02-26 12:38:05', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (205, '肇庆市', 19, 0, '2024-02-26 12:38:05', '2024-02-26 12:38:05', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (206, '惠州市', 19, 0, '2024-02-26 12:38:05', '2024-02-26 12:38:05', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (207, '梅州市', 19, 0, '2024-02-26 12:38:05', '2024-02-26 12:38:05', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (208, '汕尾市', 19, 0, '2024-02-26 12:38:05', '2024-02-26 12:38:05', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (209, '河源市', 19, 0, '2024-02-26 12:38:05', '2024-02-26 12:38:05', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (210, '阳江市', 19, 0, '2024-02-26 12:38:05', '2024-02-26 12:38:05', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (211, '清远市', 19, 0, '2024-02-26 12:38:05', '2024-02-26 12:38:05', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (212, '东莞市', 19, 0, '2024-02-26 12:38:05', '2024-02-26 12:38:05', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (213, '中山市', 19, 0, '2024-02-26 12:38:05', '2024-02-26 12:38:05', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (214, '潮州市', 19, 0, '2024-02-26 12:38:05', '2024-02-26 12:38:05', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (215, '揭阳市', 19, 0, '2024-02-26 12:38:05', '2024-02-26 12:38:05', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (216, '云浮市', 19, 0, '2024-02-26 12:38:05', '2024-02-26 12:38:05', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (217, '南宁市', 20, 0, '2024-02-26 12:38:44', '2024-02-26 12:38:44', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (218, '柳州市', 20, 0, '2024-02-26 12:38:44', '2024-02-26 12:38:44', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (219, '桂林市', 20, 0, '2024-02-26 12:38:44', '2024-02-26 12:38:44', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (220, '梧州市', 20, 0, '2024-02-26 12:38:44', '2024-02-26 12:38:44', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (221, '北海市', 20, 0, '2024-02-26 12:38:44', '2024-02-26 12:38:44', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (222, '防城港市', 20, 0, '2024-02-26 12:38:44', '2024-02-26 12:38:44', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (223, '钦州市', 20, 0, '2024-02-26 12:38:44', '2024-02-26 12:38:44', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (224, '贵港市', 20, 0, '2024-02-26 12:38:44', '2024-02-26 12:38:44', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (225, '玉林市', 20, 0, '2024-02-26 12:38:44', '2024-02-26 12:38:44', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (226, '百色市', 20, 0, '2024-02-26 12:38:44', '2024-02-26 12:38:44', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (227, '贺州市', 20, 0, '2024-02-26 12:38:44', '2024-02-26 12:38:44', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (228, '河池市', 20, 0, '2024-02-26 12:38:44', '2024-02-26 12:38:44', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (229, '来宾市', 20, 0, '2024-02-26 12:38:44', '2024-02-26 12:38:44', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (230, '崇左市', 20, 0, '2024-02-26 12:38:44', '2024-02-26 12:38:44', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (231, '海口市', 21, 0, '2024-02-26 12:39:18', '2024-02-26 12:39:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (232, '三亚市', 21, 0, '2024-02-26 12:39:18', '2024-02-26 12:39:18', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (233, '重庆市', 22, 0, '2024-02-26 12:39:40', '2024-02-26 12:39:40', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (234, '成都市', 23, 0, '2024-02-26 12:40:36', '2024-02-26 12:40:36', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (235, '自贡市', 23, 0, '2024-02-26 12:40:36', '2024-02-26 12:40:36', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (236, '攀枝花市', 23, 0, '2024-02-26 12:40:36', '2024-02-26 12:40:36', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (237, '泸州市', 23, 0, '2024-02-26 12:40:36', '2024-02-26 12:40:36', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (238, '德阳市', 23, 0, '2024-02-26 12:40:36', '2024-02-26 12:40:36', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (239, '绵阳市', 23, 0, '2024-02-26 12:40:36', '2024-02-26 12:40:36', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (240, '广元市', 23, 0, '2024-02-26 12:40:36', '2024-02-26 12:40:36', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (241, '遂宁市', 23, 0, '2024-02-26 12:40:36', '2024-02-26 12:40:36', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (242, '内江市', 23, 0, '2024-02-26 12:40:36', '2024-02-26 12:40:36', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (243, '乐山市', 23, 0, '2024-02-26 12:40:36', '2024-02-26 12:40:36', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (244, '南充市', 23, 0, '2024-02-26 12:40:36', '2024-02-26 12:40:36', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (245, '眉山市', 23, 0, '2024-02-26 12:40:36', '2024-02-26 12:40:36', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (246, '宜宾市', 23, 0, '2024-02-26 12:40:36', '2024-02-26 12:40:36', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (247, '广安市', 23, 0, '2024-02-26 12:40:36', '2024-02-26 12:40:36', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (248, '达州市', 23, 0, '2024-02-26 12:40:36', '2024-02-26 12:40:36', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (249, '雅安市', 23, 0, '2024-02-26 12:40:36', '2024-02-26 12:40:36', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (250, '巴中市', 23, 0, '2024-02-26 12:40:36', '2024-02-26 12:40:36', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (251, '资阳市', 23, 0, '2024-02-26 12:40:36', '2024-02-26 12:40:36', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (252, '阿坝藏族羌族自治州', 23, 0, '2024-02-26 12:40:36', '2024-02-26 12:40:36', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (253, '甘孜藏族自治州', 23, 0, '2024-02-26 12:40:36', '2024-02-26 12:40:36', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (254, '凉山彝族自治州', 23, 0, '2024-02-26 12:40:36', '2024-02-26 12:40:36', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (255, '贵阳市', 24, 0, '2024-02-26 12:40:58', '2024-02-26 12:40:58', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (256, '六盘水市', 24, 0, '2024-02-26 12:40:58', '2024-02-26 12:40:58', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (257, '遵义市', 24, 0, '2024-02-26 12:40:58', '2024-02-26 12:40:58', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (258, '安顺市', 24, 0, '2024-02-26 12:40:58', '2024-02-26 12:40:58', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (259, '铜仁地区', 24, 0, '2024-02-26 12:40:58', '2024-02-26 12:40:58', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (260, '黔西南布依族苗族自治州', 24, 0, '2024-02-26 12:40:58', '2024-02-26 12:40:58', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (261, '毕节地区', 24, 0, '2024-02-26 12:40:58', '2024-02-26 12:40:58', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (262, '黔东南苗族侗族自治州', 24, 0, '2024-02-26 12:40:58', '2024-02-26 12:40:58', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (263, '黔南布依族苗族自治州', 24, 0, '2024-02-26 12:40:58', '2024-02-26 12:40:58', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (264, '昆明市', 25, 0, '2024-02-26 12:41:23', '2024-02-26 12:41:23', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (265, '曲靖市', 25, 0, '2024-02-26 12:41:23', '2024-02-26 12:41:23', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (266, '玉溪市', 25, 0, '2024-02-26 12:41:23', '2024-02-26 12:41:23', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (267, '保山市', 25, 0, '2024-02-26 12:41:23', '2024-02-26 12:41:23', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (268, '昭通市', 25, 0, '2024-02-26 12:41:23', '2024-02-26 12:41:23', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (269, '丽江市', 25, 0, '2024-02-26 12:41:23', '2024-02-26 12:41:23', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (270, '思茅市', 25, 0, '2024-02-26 12:41:23', '2024-02-26 12:41:23', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (271, '临沧市', 25, 0, '2024-02-26 12:41:23', '2024-02-26 12:41:23', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (272, '楚雄彝族自治州', 25, 0, '2024-02-26 12:41:24', '2024-02-26 12:41:24', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (273, '红河哈尼族彝族自治州', 25, 0, '2024-02-26 12:41:24', '2024-02-26 12:41:24', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (274, '文山壮族苗族自治州', 25, 0, '2024-02-26 12:41:24', '2024-02-26 12:41:24', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (275, '西双版纳傣族自治州', 25, 0, '2024-02-26 12:41:24', '2024-02-26 12:41:24', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (276, '大理白族自治州', 25, 0, '2024-02-26 12:41:24', '2024-02-26 12:41:24', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (277, '德宏傣族景颇族自治州', 25, 0, '2024-02-26 12:41:24', '2024-02-26 12:41:24', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (278, '怒江傈僳族自治州', 25, 0, '2024-02-26 12:41:24', '2024-02-26 12:41:24', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (279, '迪庆藏族自治州', 25, 0, '2024-02-26 12:41:24', '2024-02-26 12:41:24', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (280, '拉萨市', 26, 0, '2024-02-26 12:41:48', '2024-02-26 12:41:48', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (281, '昌都地区', 26, 0, '2024-02-26 12:41:48', '2024-02-26 12:41:48', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (282, '山南地区', 26, 0, '2024-02-26 12:41:48', '2024-02-26 12:41:48', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (283, '日喀则地区', 26, 0, '2024-02-26 12:41:48', '2024-02-26 12:41:48', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (284, '那曲地区', 26, 0, '2024-02-26 12:41:48', '2024-02-26 12:41:48', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (285, '阿里地区', 26, 0, '2024-02-26 12:41:48', '2024-02-26 12:41:48', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (286, '林芝地区', 26, 0, '2024-02-26 12:41:48', '2024-02-26 12:41:48', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (287, '西安市', 27, 0, '2024-02-26 12:42:15', '2024-02-26 12:42:15', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (288, '铜川市', 27, 0, '2024-02-26 12:42:15', '2024-02-26 12:42:15', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (289, '宝鸡市', 27, 0, '2024-02-26 12:42:15', '2024-02-26 12:42:15', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (290, '咸阳市', 27, 0, '2024-02-26 12:42:15', '2024-02-26 12:42:15', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (291, '渭南市', 27, 0, '2024-02-26 12:42:15', '2024-02-26 12:42:15', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (292, '延安市', 27, 0, '2024-02-26 12:42:15', '2024-02-26 12:42:15', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (293, '汉中市', 27, 0, '2024-02-26 12:42:15', '2024-02-26 12:42:15', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (294, '榆林市', 27, 0, '2024-02-26 12:42:15', '2024-02-26 12:42:15', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (295, '安康市', 27, 0, '2024-02-26 12:42:15', '2024-02-26 12:42:15', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (296, '商洛市', 27, 0, '2024-02-26 12:42:15', '2024-02-26 12:42:15', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (297, '兰州市', 28, 0, '2024-02-26 12:42:35', '2024-02-26 12:42:35', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (298, '嘉峪关市', 28, 0, '2024-02-26 12:42:35', '2024-02-26 12:42:35', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (299, '金昌市', 28, 0, '2024-02-26 12:42:35', '2024-02-26 12:42:35', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (300, '白银市', 28, 0, '2024-02-26 12:42:35', '2024-02-26 12:42:35', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (301, '天水市', 28, 0, '2024-02-26 12:42:35', '2024-02-26 12:42:35', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (302, '武威市', 28, 0, '2024-02-26 12:42:35', '2024-02-26 12:42:35', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (303, '张掖市', 28, 0, '2024-02-26 12:42:35', '2024-02-26 12:42:35', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (304, '平凉市', 28, 0, '2024-02-26 12:42:35', '2024-02-26 12:42:35', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (305, '酒泉市', 28, 0, '2024-02-26 12:42:35', '2024-02-26 12:42:35', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (306, '庆阳市', 28, 0, '2024-02-26 12:42:35', '2024-02-26 12:42:35', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (307, '定西市', 28, 0, '2024-02-26 12:42:35', '2024-02-26 12:42:35', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (308, '陇南市', 28, 0, '2024-02-26 12:42:35', '2024-02-26 12:42:35', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (309, '临夏回族自治州', 28, 0, '2024-02-26 12:42:35', '2024-02-26 12:42:35', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (310, '甘南藏族自治州', 28, 0, '2024-02-26 12:42:35', '2024-02-26 12:42:35', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (311, '西宁市', 29, 0, '2024-02-26 12:42:56', '2024-02-26 12:42:56', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (312, '海东地区', 29, 0, '2024-02-26 12:42:56', '2024-02-26 12:42:56', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (313, '海北藏族自治州', 29, 0, '2024-02-26 12:42:56', '2024-02-26 12:42:56', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (314, '黄南藏族自治州', 29, 0, '2024-02-26 12:42:56', '2024-02-26 12:42:56', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (315, '海南藏族自治州', 29, 0, '2024-02-26 12:42:56', '2024-02-26 12:42:56', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (316, '果洛藏族自治州', 29, 0, '2024-02-26 12:42:56', '2024-02-26 12:42:56', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (317, '玉树藏族自治州', 29, 0, '2024-02-26 12:42:56', '2024-02-26 12:42:56', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (318, '海西蒙古族藏族自治州', 29, 0, '2024-02-26 12:42:56', '2024-02-26 12:42:56', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (319, '银川市', 30, 0, '2024-02-26 12:43:21', '2024-02-26 12:43:21', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (320, '石嘴山市', 30, 0, '2024-02-26 12:43:21', '2024-02-26 12:43:21', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (321, '吴忠市', 30, 0, '2024-02-26 12:43:21', '2024-02-26 12:43:21', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (322, '固原市', 30, 0, '2024-02-26 12:43:21', '2024-02-26 12:43:21', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (323, '中卫市', 30, 0, '2024-02-26 12:43:21', '2024-02-26 12:43:21', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (324, '乌鲁木齐市', 31, 0, '2024-02-26 12:43:56', '2024-02-26 12:43:56', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (325, '克拉玛依市', 31, 0, '2024-02-26 12:43:56', '2024-02-26 12:43:56', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (326, '吐鲁番地区', 31, 0, '2024-02-26 12:43:56', '2024-02-26 12:43:56', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (327, '哈密地区', 31, 0, '2024-02-26 12:43:56', '2024-02-26 12:43:56', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (328, '昌吉回族自治州', 31, 0, '2024-02-26 12:43:56', '2024-02-26 12:43:56', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (329, '博尔塔拉蒙古自治州', 31, 0, '2024-02-26 12:43:56', '2024-02-26 12:43:56', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (330, '巴音郭楞蒙古自治州', 31, 0, '2024-02-26 12:43:56', '2024-02-26 12:43:56', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (331, '阿克苏地区', 31, 0, '2024-02-26 12:43:56', '2024-02-26 12:43:56', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (332, '克孜勒苏柯尔克孜自治州', 31, 0, '2024-02-26 12:43:56', '2024-02-26 12:43:56', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (333, '喀什地区', 31, 0, '2024-02-26 12:43:56', '2024-02-26 12:43:56', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (334, '和田地区', 31, 0, '2024-02-26 12:43:56', '2024-02-26 12:43:56', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (335, '伊犁哈萨克自治州', 31, 0, '2024-02-26 12:43:56', '2024-02-26 12:43:56', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (336, '塔城地区', 31, 0, '2024-02-26 12:43:56', '2024-02-26 12:43:56', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (337, '阿勒泰地区', 31, 0, '2024-02-26 12:43:56', '2024-02-26 12:43:56', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (338, '省直辖行政单位', 31, 0, '2024-02-26 12:43:56', '2024-02-26 12:43:56', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (339, '天津市', 2, 0, '2024-02-26 12:44:04', '2024-02-26 12:44:04', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (340, '中西区', 33, 0, '2024-02-26 12:45:21', '2024-02-26 12:45:21', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (341, '东区', 33, 0, '2024-02-26 12:45:21', '2024-02-26 12:45:21', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (342, '九龙城区', 33, 0, '2024-02-26 12:45:21', '2024-02-26 12:45:21', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (343, '观塘区', 33, 0, '2024-02-26 12:45:21', '2024-02-26 12:45:21', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (344, '南区', 33, 0, '2024-02-26 12:45:21', '2024-02-26 12:45:21', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (345, '深水埗区', 33, 0, '2024-02-26 12:45:21', '2024-02-26 12:45:21', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (346, '湾仔区', 33, 0, '2024-02-26 12:45:21', '2024-02-26 12:45:21', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (347, '黄大仙区', 33, 0, '2024-02-26 12:45:21', '2024-02-26 12:45:21', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (348, '油尖旺区', 33, 0, '2024-02-26 12:45:21', '2024-02-26 12:45:21', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (349, '离岛区', 33, 0, '2024-02-26 12:45:21', '2024-02-26 12:45:21', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (350, '葵青区', 33, 0, '2024-02-26 12:45:21', '2024-02-26 12:45:21', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (351, '北区', 33, 0, '2024-02-26 12:45:21', '2024-02-26 12:45:21', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (352, '西贡区', 33, 0, '2024-02-26 12:45:21', '2024-02-26 12:45:21', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (353, '沙田区', 33, 0, '2024-02-26 12:45:21', '2024-02-26 12:45:21', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (354, '屯门区', 33, 0, '2024-02-26 12:45:21', '2024-02-26 12:45:21', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (355, '大埔区', 33, 0, '2024-02-26 12:45:21', '2024-02-26 12:45:21', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (356, '荃湾区', 33, 0, '2024-02-26 12:45:21', '2024-02-26 12:45:21', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (357, '元朗区', 33, 0, '2024-02-26 12:45:21', '2024-02-26 12:45:21', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (358, '花地玛堂区', 34, 0, '2024-02-26 12:46:19', '2024-02-26 12:46:19', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (359, '圣安多尼堂区', 34, 0, '2024-02-26 12:46:19', '2024-02-26 12:46:19', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (360, '大堂区', 34, 0, '2024-02-26 12:46:19', '2024-02-26 12:46:19', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (361, '望德堂区', 34, 0, '2024-02-26 12:46:19', '2024-02-26 12:46:19', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (362, '风顺堂区', 34, 0, '2024-02-26 12:46:19', '2024-02-26 12:46:19', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (363, '氹仔', 34, 0, '2024-02-26 12:46:19', '2024-02-26 12:46:19', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (364, '路环', 34, 0, '2024-02-26 12:46:19', '2024-02-26 12:46:19', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (365, '台北', 32, 0, '2024-02-26 12:47:08', '2024-02-26 12:47:08', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (366, '高雄', 32, 0, '2024-02-26 12:47:08', '2024-02-26 12:47:08', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (367, '台中', 32, 0, '2024-02-26 12:47:08', '2024-02-26 12:47:08', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (368, '花莲', 32, 0, '2024-02-26 12:47:08', '2024-02-26 12:47:08', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (369, '基隆', 32, 0, '2024-02-26 12:47:08', '2024-02-26 12:47:08', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (370, '嘉义', 32, 0, '2024-02-26 12:47:08', '2024-02-26 12:47:08', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (371, '金门', 32, 0, '2024-02-26 12:47:08', '2024-02-26 12:47:08', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (372, '连江', 32, 0, '2024-02-26 12:47:08', '2024-02-26 12:47:08', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (373, '苗栗', 32, 0, '2024-02-26 12:47:08', '2024-02-26 12:47:08', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (374, '南投', 32, 0, '2024-02-26 12:47:08', '2024-02-26 12:47:08', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (375, '澎湖', 32, 0, '2024-02-26 12:47:08', '2024-02-26 12:47:08', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (376, '屏东', 32, 0, '2024-02-26 12:47:08', '2024-02-26 12:47:08', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (377, '台东', 32, 0, '2024-02-26 12:47:08', '2024-02-26 12:47:08', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (378, '台南', 32, 0, '2024-02-26 12:47:08', '2024-02-26 12:47:08', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (379, '桃园', 32, 0, '2024-02-26 12:47:08', '2024-02-26 12:47:08', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (380, '新竹', 32, 0, '2024-02-26 12:47:08', '2024-02-26 12:47:08', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (381, '宜兰', 32, 0, '2024-02-26 12:47:08', '2024-02-26 12:47:08', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (382, '云林', 32, 0, '2024-02-26 12:47:08', '2024-02-26 12:47:08', 0);
INSERT INTO spark_hire.city (id, city_name, province_type, post_num, create_time, update_time, is_delete) VALUES (383, '彰化', 32, 0, '2024-02-26 12:47:08', '2024-02-26 12:47:08', 0);

-- 职业数据
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (1, 'Java', 'Java程序员使用Java语言进行跨平台应用程序的开发与维护，擅长处理大规模数据', 1, 0, '2024-02-24 21:22:06', '2024-04-05 14:57:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (2, 'C++', 'C++程序员主要在系统编程、游戏开发、实时系统等领域工作，对算法和数据结构有深厚理解。', 1, 0, '2024-02-24 21:24:57', '2024-04-05 14:31:16', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (3, '机器学习', '机器学习职业涉及开发和应用算法，使计算机、软件和机器能从数据中学习。他们设计模型，利用数据训练模型，并将模型应用于.', 1, 0, '2024-02-24 21:24:57', '2024-04-05 14:43:10', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (4, 'Python', 'Python开发者专注于使用Python语言进行各类应用开发，如网络爬虫、数据分析，以及AI和机器学习等。', 1, 0, '2024-02-24 21:24:57', '2024-04-05 14:41:20', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (5, '算法工程师', '算法工程师负责设计和优化算法，处理和解决各类复杂问题，尤其在人工智能和机器学习领域有显著作用。', 1, 0, '2024-02-24 21:24:57', '2024-02-24 21:24:57', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (6, '数据开发', '数据开发人员负责构建、优化数据处理流程，以及开发相应的数据处理工具，对海量数据进行分析并产出有价值的信息。', 1, 0, '2024-02-24 21:24:57', '2024-02-24 21:24:57', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (7, '数据分析师', '数据分析师通过运用各种统计分析方法，从大量数据中提取有价值的信息，以指导企业决策。', 1, 0, '2024-02-24 21:24:57', '2024-02-24 21:24:57', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (8, '后端开发', '后端开发人员负责服务器端的程序编写，以及系统设计，保证服务器与用户的交互过程顺畅，处理业务逻辑，保证数据的安全和稳定', 1, 0, '2024-02-24 21:24:57', '2024-02-24 21:24:57', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (9, '测试', '测试工程师的工作重点是设计测试方案，并进行产品的功能、性能、安全性等方面的测试，确保产品达到预期的效果。', 1, 0, '2024-02-24 21:24:57', '2024-02-24 21:24:57', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (10, '运维/技术支持', '运维/技术支持主要维护企业的IT系统、网络和应用，解决使用问题，保证信息安全。他们可能是系统管理员、网络工程师、技术文档工程师、IT技术支持或运维工程师等，需掌握深厚的专业知识和技能。', 1, 0, '2024-02-24 21:24:57', '2024-02-24 21:24:57', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (11, '技术项目管理', '技术项目管理职位在互联网/AI行业中，是负责项目整个生命周期的管理，包括项目计划、任务分配、风险控制、进度跟踪和结果评估等，以确保项目的顺利进行和目标实现。', 1, 0, '2024-02-24 21:26:05', '2024-02-24 21:26:05', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (12, '前端/移动开发', '前端/移动开发是计算机软件开发的重要部分，关注用户界面和用户体验的设计和实现他们可能是技术美术、前端开发工程师等职务。这些职务需要良好的设计和编程技能，以及对用户需求和行为的理解。他们需要持续跟踪和学习新的设计趋势和技术，以创造出更好的用户体验。', 1, 0, '2024-02-24 21:26:05', '2024-02-24 21:26:05', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (13, '网络/系统安全', '网络或系统安全专家致力于保护公司的网络和信息系统免受各种攻击，如黑客攻击、数据泄漏等，他们通过设立防火墙、加密数据等手段确保信息安全。', 1, 0, '2024-02-24 21:27:16', '2024-02-24 21:27:16', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (14, '销售技术支持', '销售技术支持人员负责提供技术知识，支持销售团队解答客户的技术问题，协助销售团队达成销售目标，同时提升客户对产品或服务的满意度。', 1, 0, '2024-02-24 21:27:16', '2024-02-24 21:27:16', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (15, '数据标注/AI训练师', '数据标注/AI训练师是AI和机器学习项目的关键角色之一。他们负责对原始数据进行标注和分类，为算法训练提供“教材”，从而帮助机器学习模型理解和学习现实世界。该职务通常需要具有细心、耐心和良好的数据理解能力。', 1, 0, '2024-02-24 21:27:53', '2024-02-24 21:27:53', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (16, '互联网产品经理', '互联网产品经理通常负责制定产品战略、管理产品开发过程，以及协调相关团队，他们的目标是提供最符合市场需求的互联网产品。', 2, 0, '2024-02-26 17:15:25', '2024-02-26 17:15:25', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (17, '游戏策划/制作', '游戏策划/制作人员负责游戏的整体规划和制作过程，他们的工作包括创新游戏概念、设定故事剧情、管理开发进度等。', 2, 0, '2024-02-26 17:15:25', '2024-02-26 17:15:25', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (18, '硬件产品经理', '硬件产品经理负责硬件产品从构思到市场的全过程，包括产品设计、制造、市场推广等，他们需要了解市场需求和技术趋势。', 2, 0, '2024-02-26 17:17:12', '2024-02-26 17:17:12', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (19, '化妆品产品经理', '化妆品产品经理主要负责化妆品的市场调研、产品策划、产品开发和产品推广等工作，他们需要了解并跟踪化妆品市场的最新动态。', 2, 0, '2024-02-26 17:17:12', '2024-02-26 17:17:12', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (20, '金融产品经理', '金融产品经理主要负责金融产品的设计、开发和推广，他们需要深入理解金融市场趋势和客户需求，以创建具有竞争力的金融产品。', 2, 0, '2024-02-26 17:17:12', '2024-02-26 17:17:12', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (21, '内容运营', '内容运营人员负责制定并执行内容策略，通过创建、发布、管理优化各类内容，以吸引并留住目标用户，促进产品和品牌的发展。', 3, 0, '2024-02-26 17:21:54', '2024-02-26 17:21:54', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (22, '新媒体运营', '新媒体运营主要通过运营微博、微信、短视频等新媒体平台，发布吸引人的内容，以提升品牌知名度和用户粘性。', 3, 0, '2024-02-26 17:21:54', '2024-02-26 17:21:54', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (23, '产品运营', '产品运营主要负责产品的推广和优化，包括但不限于产品上线策划、活动策划、用户行为分析、产品优化改进等工作。', 3, 0, '2024-02-26 17:21:54', '2024-02-26 17:21:54', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (24, 'SEO/SEM', 'SEO/SEM专家利用搜索引擎优化(SEO)和搜索引擎营销(SEM)的技巧，提高网站在搜索引擎中的排名，吸引更多的用户流量。', 3, 0, '2024-02-26 17:21:54', '2024-02-26 17:21:54', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (25, '客服', '客服人员主要负责解答用户的问题，处理用户反馈，提供优质的服务，从而增强用户对公司或产品的信任和满意度。', 3, 0, '2024-02-26 17:21:54', '2024-02-26 17:21:54', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (26, '编辑', '编辑主要负责内容的审核、修改和优化，他们需要有强大的语言组织能力和对内容的敏锐洞察力，以提供高质量的内容。', 3, 0, '2024-02-26 17:21:54', '2024-02-26 17:21:54', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (27, '文案策划', '文案策划者负责创作各种宣传文案，包括广告、活动推广、产品说明等，以吸引目标受众。', 3, 0, '2024-02-26 17:21:54', '2024-02-26 17:21:54', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (28, '国内电商运营', '负责国内电子商务平台/店铺的整体运营与日常管理，包括货品上下架，店铺推广等。', 3, 0, '2024-02-26 17:21:54', '2024-02-26 17:21:54', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (29, '跨境电商运营', '跨境电商运营涉及在全球范围内进行的电子商务运营活动，需要处理跨国电商的特殊问题，如关税、国际物流、外汇等。', 3, 0, '2024-02-26 17:21:54', '2024-02-26 17:21:54', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (30, '业务运营', '业务运营专门负责公司业务的日常运营管理，1包括优化业务流程提升业务效率、保障业务顺利进行等。', 3, 0, '2024-02-26 17:21:54', '2024-02-26 17:21:54', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (31, '品类运营', '发现不同品类的用户、商品、商家痛点，从而解决问题、提升服务、促进细分市场发展的运营人员。', 3, 0, '2024-02-26 17:21:54', '2024-02-26 17:21:54', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (32, '线下运营', '线下运营是一个涵盖多个任务和职责的角色，主要目标是通过在实体环境中执行各种策略和活动来推动业务增长。这通常需要深入了解产品或服务，以及目标市场和消费者。', 3, 0, '2024-02-26 17:21:54', '2024-02-26 17:21:54', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (33, '视觉/交互设计', '视觉/交互设计师负责产品的视觉效果和用户交互体验的设计，他们需要懂得如何通过视觉元素和交互设计来提升产品的用户体验。', 4, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (34, '游戏设计', '游戏设计师负责整个游戏的创新和设计，包括游戏规则、剧情、角色和用户体验，使游戏具有吸引力和趣味性。', 4, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (35, '美术/3D/动画', '美术/3D/动画设计师负责绘制美术图像、制作3D模型和动画效果他们是视觉表达的艺术家，能把创意转化为视觉效果。', 4, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (36, '工业/家居设计', '工业/家居设计师专注于产品和空间设计，他们要考虑美观、实用和生产工艺，打造符合人们使用习惯和审美的产品或空间。', 4, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (37, '用户研究', '用户研究员主要进行用户需求研究和用户行为分析，他们通过调研和分析，了解用户的真实需求，为产品或服务的设计提供依据。', 4, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (38, '服装设计', '服装设计师负责服装的创新和设计，他们要关注时尚趋势、理解消费者需求，设计出时尚、美观、舒适的服装。', 4, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (39, '展示/照明设计', '展示/照明设计师负责空间布局、展品陈列和照明效果设计，他们的设计能营造出吸引人的展览环境，提升观展体验。', 4, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (40, '新闻/编辑', '新闻编辑或者记者，是负责采集、编写和发布新闻的人员。他们要关注社会热点，以客观、准确、及时的方式向公众传达信息。对于新闻编辑，良好的文字功底，敏锐的新闻嗅觉，以及公正的新闻伦理是非常重要的。', 5, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (41, '演员/配音/模特', '这个领域的专业人员通过身体、声音或外貌表现来进行艺术创作。他们可能出演电影电视、舞台剧，为动画或电影配音，或者为时尚、广告做模特。他们需要有出色的演技，对角色有深入的理解，并且对自己的形象有严格的管理。', 5, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (42, '影视媒体', '影视媒体涵盖了电影、电视、网络视频等多种形式的内容创作和发布。影视媒体的工作职责和角色多种多样，包括制片人、导演、编剧、演员、摄影师、剪辑师、音效师、模特等。', 5, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (43, '采编/写作/出版', '这个职位涵盖了内容创作和发布的所有环节，包括新闻采集、文章撰写、书籍编辑等，他们通过文字传播信息和知识。', 5, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (44, '放映员', '放映员主要负责影院的电影放映工作，他们需要熟练操作放映设备，确保电影的顺利播放，为观众提供良好的观影体验。', 5, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (45, '儿童引导师', '儿童引导师是一个专门角色，他们通常在儿童摄影环境中工作，帮助引导和安抚儿童以便摄影师可以捕捉到最好的照片。他们的角色通常包括让儿童在拍摄过程中感到舒适，创造有趣的环境，引导儿童进行自然的表现，并协助摄影师实现拍摄目标。', 5, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (46, '主持人/主播/DJ', '主持人/主播/DJ是媒体和娱乐行业中的重要角色。他们主要负责引导和控制节目或直播的流程，包括电视、电台、活动和网络直播、通过直播的方式进行商品的推介和销售等。他们必须具备良好的语言表达和沟通能力，能迅速适应变化并处理突发事件。这类职业需要熟悉媒体生产和广播设备，并能在压力下工作。他们还需要有出色的情感智商，能理解和激发听众观众的情绪', 5, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (47, '人力资源', '该职位主要负责人力资源部门的日常工作，如招聘、培训、薪资福利、员工关系等。他们需要熟悉人力资源管理的各种工作流程和法律法规，并具有良好的沟通、组织和分析能力。', 6, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (48, '行政', '行政人员主要负责公司的日常行政事务，如文件管理、会议安排、办公设施维护等。他们需要有良好的时间管理能力、组织能力和人际交往能力，并且需要熟悉公司的业务流程和政策。', 6, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (49, '前台', '前台工作人员主要负责接待访客、接听电话、处理邮件等工作，他们是公司形象的重要代表。他们需要具备优秀的沟通技巧、专业的服务态度，以及良好的问题解决能力。', 6, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (50, '法务', '法务人员主要是在公司或政府机构中处理法律事务的专业人员。他们的职责包括提供法律咨询、起草和审查合同、处理法律纠纷等。他们需要对法律有深入的理解，具备解决复杂法律问题的能力，并且需要具备良好的道德操守。', 6, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (51, '会计', '会计专业人士负责记录、分析、汇总企业的财务信息，并准备财务报表。他们需要确保所有的会计记录都准确无误，符合会计原则和法律规定。他们需要有良好的会计知识、注意细节，以及强大的数据处理能力。', 7, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (52, '风控', '风险控制专业人士在金融行业中主要负责识别、评估和控制企业面临的风险，包括信用风险、市场风险、操作风险等。他们需要建立有效的风险管理策略和制度，以保护企业免受潜在风险的损害。他们需要对金融市场和风险管理有深入了解，以及强大的分析和决策能力。', 7, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (53, '互联网金融', '互联网金融专业人士主要在金融科技公司工作，利用互联网技术提供金融服务，如在线贷款、网络支付、P2P借贷等。他们需要了解金融市场规则，熟悉互联网技术，并能在两者之间架起桥梁，为客户提供便捷、高效的金融服务。', 7, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (54, '出纳', '出纳员是一个关键的财务职位，他们的主要职责是管理和记录公司的现金交易。这包括收款、付款、现金流水账的记录等。他们还需要确保所有交易都符合公司的财务政策和法律法规。对细节的注意力、精确的记录能力和良好的道德素质是这个职位的重要特征', 7, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (55, '财务顾问', '他们为企业或个人提供财务策财务顾问是专业的财务管理专家，划、投资咨询、税务规划等服务，帮助客户实现财务目标。', 7, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (56, '税务', '专业处理税务事务，包括税务筹划、税收申报、税务咨询等，帮助企业合理避税，确保税收合规。', 7, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (57, '审计', '审计人员主要负责企业财务报告的审查，评估企业的财务状况和内部控制系统，以防止财务欺诈。', 7, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (58, '统计员', '统计员主要负责收集、处理和分析数据，通过数据提供有助于决策的信息，是企业决策的重要支持。', 7, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (59, '财务分析/财务BP', '财务分析师/BP主要负责进行财务分析和预测，提供财务建议，帮助企业做出更好的商业决策。', 7, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (60, '法律服务', '法律服务专业人士提供法律咨询、代理诉讼等服务，他们用专业知识和经验帮助客户解决法律问题', 8, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (61, '咨询/调研', '咨询/调研专业人士主要提供专业建议和解决方案，以帮助客户解决各种商业、管理或政策问题。他们通过深入调研和数据分析，形成对问题的深刻理解，并据此提出策略或行动建议。他们需要具备良好的分析思维，研究技能和人际交往能力。', 8, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (62, '英语翻译', '英语翻译专业人士负责将英语文本准确地翻译成其他语言，或将其他语言的文本翻译成英语。他们在保证翻译准确性的同时，也需要注意保留原文的语言风格和文化特征。他们需要具备高级的英语水平，良好的翻译技能和跨文化理解能力。', 8, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (63, '日语翻译', '日语翻译专业人士负责将日语文本准确地翻译成其他语言，或将其他语言的文本翻译成日语。他们需要对日语和目标语言有深入的理解，能准确、生动地表达原文的含义，同时也需要对日本的文化和社会有一定了解。', 8, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (64, '韩语/朝鲜语翻译', '韩语/朝鲜语翻译专业人士负责将韩语/朝鲜语文本准确地翻译成其他语言，或将其他语言的文本翻译成韩语/朝鲜语。他们需要掌握高水平的韩语/朝鲜语技能，同时对目标语言也需要有足够的掌握程度，以便准确无误地进行翻译。', 8, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (65, '法语翻译', '法语翻译专业人士负责将法语文本准确地翻译成其他语言，或将其他语言的文本翻译成法语。他们需要精通法语和目标语言，熟悉法国和法语区域的文化，以确保翻译的准确性和生动性。他们的工作可能涵盖各种文本类型，包括法律文档、商业报告、文学作品等。', 8, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (66, '德语翻译', '德语翻译是专门将一种语言(如英语)翻译为德语，或者将德语翻译为其他语言的专业人员。他们的工作可能涉及各种内容，包括书籍、文章、电影、音频、公务文件等。他们需要精通德语和至少一种其他语言，并能准确、"快速地进行翻译。', 8, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (67, '俄语翻译', '俄语翻译是负责将一种语言翻译成俄语，或者将俄语翻译成其他语言的专业人员。他们需要具备出色的俄语水平和至少一种其他语言的精通程度，并且能够确保翻译的准确性和流畅性。', 8, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (68, '西班牙语翻译', '西班牙语翻译专门负责将一种语言(如英语)翻译成西班牙语，或者将西班牙语翻译成其他语言。他们的工作涵盖了各种领域，包括商务、教育、旅游、媒体等。他们需要精通西班牙语和至少一种其他语言，能够精确地传达原文的意思。', 8, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (69, '其他语种翻译', '这个领域涵盖了所有非主流语言的翻译工作，包括但不限于荷兰语、波兰语、土耳其语等。这些翻译需要对他们专门从事的语言有深入的理解，以确保他们能准确无误地翻译各种内容。', 8, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (70, '心理/婚恋咨询师', '心理/婚恋咨询师提供专业的心理辅导与婚恋建议，他们通过倾听和指导，帮助个体和情侣理解自我，解决情感困扰，实现情感生活的和谐', 8, 0, '2024-02-26 19:01:29', '2024-02-26 19:01:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (71, '教师', '教师是教育机构中的核心角色，他们负责向学生传授知识，培养学生的技能，激发学生的兴趣。他们需要熟悉所教学科的知识，具备良好的教学方法，有热爱教育的热情和耐', 9, 0, '2024-02-26 19:36:29', '2024-02-26 19:36:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (72, '教育行政', '教育行政人员负责学校或教育机构的行政管理工作，他们制定并执行教育政策，协调教学资源，维护教学秩序，为教育事业的顺利发展提供支持。', 9, 0, '2024-02-26 19:36:29', '2024-02-26 19:36:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (73, '职业培训', '职业培训老师提供针对特定职业或技能的培训服务，帮助学员提升专业能力或获取新的技能。他们需要在相关领域有深厚的专业知识，熟悉培训方法和技巧。', 9, 0, '2024-02-26 19:36:29', '2024-02-26 19:36:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (74, 'IT培训', 'IT培训老师负责教授计算机科学和信息技术相关的课程，如编程语言、网络技术、数据库管理等。他们需要精通IT领域的知识，有丰富的教学经验，能够将复杂的技术知识讲解得简单易懂。', 9, 0, '2024-02-26 19:36:29', '2024-02-26 19:36:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (75, '教育产品研发', '教育产品研发人员专注于教育产品或课程的设计与开发，他们深入研究教育需求和趋势，创新教育理念和方法，为提高教育质量做出贡献。', 9, 0, '2024-02-26 19:36:29', '2024-02-26 19:36:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (76, '教育产品研发', '教育产品研发人员专注于教育产品或课程的设计与开发，他们深入研究教育需求和趋势，创新教育理念和方法，为提高教育质量做出贡献。', 9, 0, '2024-02-26 19:36:29', '2024-02-26 19:36:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (77, '助教', '助教在教育机构中，负责协助教师进行教学工作，如备课、批改作业、辅导学生等。他们需要了解教学大纲和课程内容，并具有良好的沟通和组织能力。', 9, 0, '2024-02-26 19:36:29', '2024-02-26 19:36:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (78, '幼儿/少儿教师', '幼儿/少儿教师负责幼儿和少儿的教育与照顾，他们设计并进行教学活动，引导孩子探索和学习，促进孩子的全面发展。', 9, 0, '2024-02-26 19:36:29', '2024-02-26 19:36:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (79, '就业老师', '就业老师在职业学校或高校工作，他们提供就业指导和职业规划，帮助学生理解就业市场，提升就业技能，顺利实现从学校到职场的转变。', 9, 0, '2024-02-26 19:36:29', '2024-02-26 19:36:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (80, '家教', '家教通常是专门为学生提供一对一教育辅导的角色，他们需要根据学生的学习需求和情况，设计个性化的教学计划和方法，以帮助学生提升学习效果。', 9, 0, '2024-02-26 19:36:29', '2024-02-26 19:36:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (81, '文化艺术培训', '文化艺术培训是指通过专业的培训课程，教授学生如何理解和创作文化艺术作品，如绘画、雕塑、音乐、戏剧等，以提升学生的艺术素养和创作能力。', 9, 0, '2024-02-26 19:36:29', '2024-02-26 19:36:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (82, '运动培训', '运动培训通常是针对某一种或几种运动的专门训练，比如足球、篮球、游泳等，他们需要根据运动员的情况，设计和实施训练计划，以提升运动员的技能和体能。', 9, 0, '2024-02-26 19:36:29', '2024-02-26 19:36:29', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (83, '销售', '销售人员的工作主要是销售产品或服务，寻找并联系潜在客户，建立良好的客户关系他们需要具备优秀的沟通和谈判技巧，良好的产品知识，以及高度的服务意识。', 10, 0, '2024-02-26 19:40:27', '2024-02-26 19:40:27', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (84, '房地产销售/招商', '房地产销售/招商专业人员是房地产行业的重要角色，他们负责推销房地产项目，如住宅、商业物业等，向潜在购房者或商业合作伙伴进行推介。他们需要了解市场动态，掌握房地产信息，具备优秀的沟通和谈判技巧，以达成销售目标并满足客户需求。同时他们也负责招募和管理商业租赁者，以实现物业的商业价值。', 10, 0, '2024-02-26 19:40:27', '2024-02-26 19:40:27', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (85, '金融销售', '软件销售专业人员负责销售公司的软件产品或服务。他们需要了解公司的软件产品和解决方案，识别并接触潜在客户，展示产品特点和优势，以达成销售目标。他们需要有良好的沟通和谈判技巧，以及对软件和技术市场的了解。', 10, 0, '2024-02-26 19:40:27', '2024-02-26 19:40:27', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (86, '汽车销售', '汽车销售专业人员负责销售各种汽车，包括新车、二手车、商务车等。他们需要熟悉汽车的特点和技术规格，能够解答客户的问题，推荐适合的汽车。他们需要有良好的销售技巧和服务态度，以及对汽车市场的了解。', 10, 0, '2024-02-26 19:40:27', '2024-02-26 19:40:27', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (87, '店员/营业员', '店员/营业员主要在零售店或服务店面提供销售和客户服务。他们需要熟悉店内的产品和服务，能够帮助客户找到他们需要的商品或服务，提供购物建议，处理付款等。他们需要有良好的客户服务技巧，能够快速、准确地处理销售和服务任务。', 10, 0, '2024-02-26 19:40:27', '2024-02-26 19:40:27', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (88, '广告/会展销售', '这个职位的人员主要负责销售广告或会展的空间和机会。他们的工作包括寻找潜在客户，了解客户的需求，提供合适的广告或会展解决方案，以及与客户建立长期的合作关系。他们需要有良好的沟通和谈判技巧，以及对广告和会展市场的深入了解。', 10, 0, '2024-02-26 19:40:27', '2024-02-26 19:40:27', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (89, '销售行政/商务', '销售行政/商务通常涉及到销售活动的后台支持，包括订单处理、合同管理、销售数据分析等，他们的工作为销售团队提供重要的商务支持。', 10, 0, '2024-02-26 19:40:27', '2024-02-26 19:40:27', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (90, '销售管理', '销售管理是指对销售团队进行组织、领导和控制的工作，他们需要制定销售策略，管理销售团队，监控销售活动，以实现销售目标。', 10, 0, '2024-02-26 19:40:27', '2024-02-26 19:40:27', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (91, '服务业销售', '服务业销售人员主要负责向客户推销公司的服务产品，他们需要了解市场需求、熟悉公司产品，并具备良好的沟通和谈判技巧。', 10, 0, '2024-02-26 19:40:27', '2024-02-26 19:40:27', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (92, '课程销售', '课程销售人员负责推广和销售教育课程，他们需要深入理解课程内容和教育市场动态，以有效地吸引和留住客户。', 10, 0, '2024-02-26 19:40:27', '2024-02-26 19:40:27', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (93, '外贸销售', '外贸销售人员主要负责开拓国际市场、推广产品、维护客户关系等，他们需要掌握一定的外语能力和国际贸易知识。', 10, 0, '2024-02-26 19:40:27', '2024-02-26 19:40:27', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (94, '仓储', '仓储工作人员负责管理和维护仓库，包括接收货物、整理货架、记录库存和准备发货。他们需要保持仓库的整洁和有序，确保货物的安全。他们需要具备良好的物理体力和组织能力。', 11, 0, '2024-02-26 19:53:56', '2024-02-26 19:53:56', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (95, '外贸文员', '外贸文员负责处理外贸业务的相关文档工作，如报价、合同、发票等。他们需要了解国际贸易的流程和规则，具备良好的英语沟通和书写能力。', 11, 0, '2024-02-26 19:53:56', '2024-02-26 19:53:56', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (96, '无人机飞手', '无人机飞手主要负责无人机的操作和维护，他们需要熟悉无人机操作规程，具备高度的责任心和严谨的工作态度。', 11, 0, '2024-02-26 19:53:56', '2024-02-26 19:53:56', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (97, '驾驶员', '驾驶员主要负责驾驶车辆，执行货物或人员的运输任务，他们需要有良好的驾驶技能和安全意识，确保运输任务的顺利完成', 11, 0, '2024-02-26 19:53:56', '2024-02-26 19:53:56', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (98, '供应链', '供应链工作涵盖了商品从原材料到最终用户的整个过程，包括采购、生产、仓储、运输等环节。供应链管理的目标是通过优化这些流程，降低成本，提高效率和客户满意度。', 11, 0, '2024-02-26 19:53:56', '2024-02-26 19:53:56', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (99, '物流/运输', '物流/运输工作主要涉及货物的存储和运输，包括库存管理、包装、运输规划、货物跟踪等，他们确保货物能够安全、准时、有效地从一地运到另一地。', 11, 0, '2024-02-26 19:53:56', '2024-02-26 19:53:56', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (100, '配送理货', '配送理货人员负责处理和组织仓库中的商品，他们需要对货物进行分类、标记，并确保其正确无误地发送到正确的地址。', 11, 0, '2024-02-26 19:53:56', '2024-02-26 19:53:56', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (101, '跟车员', '跟车员一般陪同驾驶员执行运输任务，他们可能需要帮助装卸货物，处理运输过程中的问题，以及完成相关的文书工作。', 11, 0, '2024-02-26 19:53:56', '2024-02-26 19:53:56', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (102, '搬运工/装卸工', '搬运工/装卸工主要负责仓库中货物的装卸、搬运工作，他们需要有良好的身体条件，以安全、高效地完成工作，', 11, 0, '2024-02-26 19:53:56', '2024-02-26 19:53:56', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (103, '城市规划设计', '城市规划设计人员负责对城市的发展和布局进行整体设计和规划。他们需要考虑众多因素，如环境保护、交通状况、人口密度等，以实现城市的可持续发展。', 12, 0, '2024-02-26 19:57:01', '2024-02-26 19:57:01', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (104, '房地产销售', '房地产销售职位负责销售房地产项目，包括住宅、商业空间等，他们需要具备良好的沟通技巧和谈判能力，以达成销售目标。', 12, 0, '2024-02-26 19:57:01', '2024-02-26 19:57:01', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (105, '装饰装修', '装饰装修职位主要负责室内空间的设计和装饰工作，包括为客户提供设计方案、选择合适的材料和配件，以及监督装修工程的施工进度，确保装修效果符合客户的期望。', 12, 0, '2024-02-26 19:57:01', '2024-02-26 19:57:01', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (106, '房地产规划开发', '房地产规划开发职位主要负责房地产项目的策划和开发工作，包括选址、设计、施工和销售等全过程，他们需要具备多元化的专业知识和综合能力', 12, 0, '2024-02-26 19:57:01', '2024-02-26 19:57:01', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (107, '建筑/规划设计', '建筑/规划设计职位涉及建筑设计、城市规划等工作，他们通过创新和科学的设计，打造出满足使用功能且具有艺术价值的建筑和城市空间。', 12, 0, '2024-02-26 19:57:01', '2024-02-26 19:57:01', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (108, '园林/景观设计', '园林/景观设计职位主要负责公共空间、园林、景观等的设计工作，他们需要融合自然和人工元素，打造出优美、和谐、可持续的环境空间。', 12, 0, '2024-02-26 19:57:01', '2024-02-26 19:57:01', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (109, '工程管理', '工程管理人员主要负责建筑工程的日常管理和协调工作，包括项目计划、进度控制、成本控制、质量管理等，以确保工程的顺利进行。', 12, 0, '2024-02-26 19:57:01', '2024-02-26 19:57:01', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (110, '房产评估师', '房产评估师是专门进行房产价值评估的专业人员，他们通过分析房产的各种因素(如位置、房龄、市场行情等)，为买卖双方提供房产的公正价值。', 12, 0, '2024-02-26 19:57:01', '2024-02-26 19:57:01', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (111, '物业管理', '物业管理人员主要负责对小区、大厦等物业进行管理，包括环境维护、设施管理、服务提供等，以提升居住或使用环境的品质。', 12, 0, '2024-02-26 19:57:01', '2024-02-26 19:57:01', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (112, '建筑/装修工人', '建筑/装修工人负责进行各种建筑或装修工程，如砌墙、粉刷、装配等。他们的工作对于建筑的质量和美观至关重要。', 12, 0, '2024-02-26 19:57:01', '2024-02-26 19:57:01', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (113, '护士', '护士在医疗机构中负责提供病人护理服务，包括基础护理、药物管理、病情观察、病人教育等。他们需要具备专业的护理知识和技能，良好的沟通和应对压力的能力。', 13, 0, '2024-02-26 20:02:12', '2024-02-26 20:02:12', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (114, '医疗器械', '医疗器械专业人员负责研发、生产和销售各种医疗器械，如手术器具、诊断设备、假体等。他们需要具备专业的医疗和工程知识，熟悉相关产品的设计和生产流程，以及对医疗市场的理解。', 13, 0, '2024-02-26 20:02:12', '2024-02-26 20:02:12', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (115, '医疗销售', '医疗销售人员负责销售医疗产品和服务，如药物、医疗器械、医疗检查服务等。他们需要熟悉产品特性和市场需求，具备良好的销售技巧和客户服务意识。', 13, 0, '2024-02-26 20:02:12', '2024-02-26 20:02:12', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (116, '医药编辑', '医药编辑主要负责对医学或医药相关的文章、书籍、研究报告等进行编辑和修订。他们需要具备医学和编辑的专业知识，能够理解并准确表达专业内容。', 13, 0, '2024-02-26 20:02:12', '2024-02-26 20:02:12', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (117, '医生/医技', '医生/医技人员主要负责提供医疗服务，包括诊断疾病，治疗疾病，为患者提供专业的医疗咨询等。他们是医疗健康系统中的核心角色。', 13, 0, '2024-02-26 20:02:12', '2024-02-26 20:02:12', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (118, '生物医药', '生物医药工作者研究和开发用于治疗和预防疾病的生物药品。这可能涉及基因工程、生物技术等先进技术，以创新和优化医疗产品。', 13, 0, '2024-02-26 20:02:12', '2024-02-26 20:02:12', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (119, '生物医药', '生物医药工作者研究和开发用于治疗和预防疾病的生物药品。这可能涉及基因工程、生物技术等先进技术，以创新和优化医疗产品。', 13, 0, '2024-02-26 20:02:12', '2024-02-26 20:02:12', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (120, '药品生产', '药品生产人员负责制造医疗药品，包括原料采购、制剂开发、质量控制等步骤。他们的工作保证了药品的安全性和有效性。', 13, 0, '2024-02-26 20:02:12', '2024-02-26 20:02:12', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (121, '临床试验', '临床试验工作者负责进行医疗产品或治疗方法的临床研究，以验证其安全性和有效性这是将医疗研究成果应用到实际临床的重要环节。', 13, 0, '2024-02-26 20:02:12', '2024-02-26 20:02:12', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (122, '导医', '导医是医疗机构中的重要角色，主要负责指导患者就医流程，协助患者完成挂号、支付、指引诊室等工作，以提升患者就医体验和医疗服务效率。', 13, 0, '2024-02-26 20:02:12', '2024-02-26 20:02:12', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (123, '药店', '药店人员负责销售药品、医疗器械等医疗产品，同时提供药物使用指导和简单的健康咨询服务，他们需要有一定的医药知识和良好的服务态度。', 13, 0, '2024-02-26 20:02:12', '2024-02-26 20:02:12', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (124, '护工', '护工主要负责照顾病人和老年人的日常生活，包括帮助患者进食、洗浴、活动等，他们需要有爱心和耐心，以及基本的护理技能。', 13, 0, '2024-02-26 20:02:12', '2024-02-26 20:02:12', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (125, '旅游服务', '旅游服务人员负责为旅游者提供服务，如导游、行程规划、门票预订等。他们需要具备良好的沟通能力，对旅游目的地有深入了解，以及服务意识。', 14, 0, '2024-02-26 20:02:12', '2024-02-26 20:02:12', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (126, '服务员', '服务员在餐馆、酒店等地方工作，他们负责接待客人，提供点餐送餐、清理等服务。他们需要具备良好的服务态度和沟通技巧。', 14, 0, '2024-02-26 20:02:12', '2024-02-26 20:02:12', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (127, '餐饮店长', '餐饮店长负责管理餐馆的日常运营，包括菜单制定、人员安排、财务管理等。他们需要具备管理和领导能力，了解餐饮业的运营模式和食品安全规定。此外，他们还需要有优秀的服务意识，以提高顾客满意度。', 14, 0, '2024-02-26 20:02:12', '2024-02-26 20:02:12', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (128, '酒店前台/迎宾', '酒店前台/迎宾是酒店的门面，他们负责接待客人、办理入住退房手续，提供酒店信息咨询等服务，他们需要具备良好的服务态度和专业素养。', 14, 0, '2024-02-26 20:02:12', '2024-02-26 20:02:12', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (129, '旅游产品开发/策划', '旅游产品开发/策划人员负责设计和开发旅游产品，包括旅游路线、旅游项目等，他们需要深入了解旅游市场，以创新和精准的产品满足旅客的需求。', 14, 0, '2024-02-26 20:02:12', '2024-02-26 20:02:12', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (130, '客房服务员', '客房服务员在酒店行业中主要负责房间的清洁和整理工作，以及提供其他相关的客房服务，如布置房间、更换床单等，确保客人享有舒适整洁的住宿环境。', 14, 0, '2024-02-26 20:02:12', '2024-02-26 20:02:12', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (131, '酒店经理', '酒店经理负责酒店的日常运营管理，包括人员管理、客房管理、餐饮服务等。他们需要确保提供优质的客户服务，提高客人满意度，以达成酒店的经营目标。', 14, 0, '2024-02-26 20:02:12', '2024-02-26 20:02:12', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (132, '汽车研发/制造', '汽车研发/制造工作涉及新车型的设计、开发和制造过程。他们需要不断研究和应用新的技术，优化汽车性能，满足消费者和市场的需求。', 15, 0, '2024-02-26 20:18:19', '2024-02-26 20:18:19', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (133, '汽车服务', '汽车服务包括汽车维修、保养、美容等服务，他们需要对汽车结构和功能有深入理解能够解决各种车辆问题，提供优质的汽车后市场服务。', 15, 0, '2024-02-26 20:18:19', '2024-02-26 20:18:19', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (134, '机械设计/制造', '机械设计/制造工程师主要负责机械产品的设计和生产过程，包括新产品的设计、制图模拟、制造等，他们需要具备深厚的机械专业知识和实践能力。', 16, 0, '2024-02-26 20:20:04', '2024-02-26 20:20:04', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (135, '化工', '化工行业中的工作主要涉及化学物质的生产和加工。这包括从原料选择、化学反应、产品制备，到最后的质量检测和环保处理等一系列过程，需要专业的化学知识和技能', 16, 0, '2024-02-26 20:20:04', '2024-02-26 20:20:04', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (136, '服装纺织设计', '服装纺织设计师负责设计衣服或纺织品的样式、图案和颜色，以满足消费者的审美需求', 16, 0, '2024-02-26 20:20:04', '2024-02-26 20:20:04', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (137, '质量管理', '质量管理专员负责确保产品或服务满足预定的质量标准。他们的工作可能包括设计和实施质量检查程序，识别和解决质量问题，以及制定质量改进策略。他们需要熟悉质量管理原则和工具，具备良好的分析和解决问题的能力。', 16, 0, '2024-02-26 20:20:04', '2024-02-26 20:20:04', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (138, '生产安全', '生产安全岗位的主要职责是保证生产过程的安全。他们需要定期检查生产设备的状态制定并执行安全规程，预防和处理生产过程中的安全事故。', 16, 0, '2024-02-26 20:20:04', '2024-02-26 20:20:04', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (139, '生产营运', '生产营运人员负责管理和优化生产过程，以提高效率和生产力。他们可能需要安排生产计划，管理物料和人力资源，以及监控生产设备的性能。他们需要熟悉生产操作，有良好的组织和领导能力。', 16, 0, '2024-02-26 20:20:04', '2024-02-26 20:20:04', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (140, '食品/饮料研发', '食品/饮料研发人员负责开发新的食品和饮料产品。他们需要对食品科学有深入的了解通过不断试验和改良，创新出满足消费者需求的产品。', 16, 0, '2024-02-26 20:20:04', '2024-02-26 20:20:04', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (141, '服装制作生产', '服装制作生产工作包括设计稿的打样、量身定制、裁剪布料、缝纫制衣等一系列步骤他们需要有良好的手工技巧，对服装制作的各个环节都有深入了解。', 16, 0, '2024-02-26 20:20:04', '2024-02-26 20:20:04', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (142, '普工', '普工，也被称为普通工人或操作工，是工厂或生产线上的基础员工。他们的任务通常涵盖各种简单的劳动性工作，如包装、搬运、清理或基本的机器操作等。尽管工作内容可能不需要高级的技术或专业知识，但他们在生产过程中起着至关重要的作用，是实现工厂日常运营和生产目标的关键。', 16, 0, '2024-02-26 20:20:04', '2024-02-26 20:20:04', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (143, '挖掘机/铲车/叉车', '挖掘机/铲车/叉车操作员是负责操作重型机械设备以执行各种建设和生产任务的专业人员。他们可能在建筑工地、矿山、仓库、码头或其他工业环境中工作。他们需要拥有专业的驾驶和操作技能，以安全有效地使用这些设备，进行土石方工程、货物搬运等工作。', 16, 0, '2024-02-26 20:20:04', '2024-02-26 20:20:04', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (144, '技工', '技工是工厂、车间等生产线上的主力军，他们操作各类机械设备，制造出我们日常生活中使用的各种产品，同时他们也负责设备的日常维护和故障排查。', 16, 0, '2024-02-26 20:20:04', '2024-02-26 20:20:04', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (145, '电气/自动化', '电气/自动化工程师负责设计、开发和维护自动化设备和系统。这可能包括机器人、生产线、工业过程等。他们需要具备电气工程和自动化技术的知识，以及分析和解决复杂技术问题的能力。', 17, 0, '2024-02-26 20:25:56', '2024-02-26 20:25:56', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (146, '电子/硬件开发', '电子/硬件开发人员负责电子产品和系统的设计与开发工作，他们通过硬件设计，实现产品功能，满足市场和用户需求。', 17, 0, '2024-02-26 20:28:54', '2024-02-26 20:28:54', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (147, '通信', '通信工程师主要负责通信系统和设备的设计、安装、调试和维护工作，他们的工作保证了信息的顺畅传递，是现代社会信息化建设的重要支撑。', 17, 0, '2024-02-26 20:28:54', '2024-02-26 20:28:54', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (148, '半导体/芯片', '半导体/芯片工程师涉及到芯片设计、制造、测试等环节，他们的工作推动了半导体技术的发展，是电子设备、智能终端等产品的核心部分。', 17, 0, '2024-02-26 20:28:54', '2024-02-26 20:28:54', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (149, '电子维修技术员', '电子维修技术员主要负责维修和保养电子设备和系统。他们需要熟悉电子设备的工作原理和结构，能够检查、测试、诊断并修复设备的故障，确保设备的正常运行。', 17, 0, '2024-02-26 20:28:54', '2024-02-26 20:28:54', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (150, '采购', '采购人员负责从供应商那里购买公司需要的商品和服务。他们需要评估供应商的价格质量和可靠性，进行谈判，以达到最佳的采购条件。他们需要有良好的分析和谈判技巧，对市场趋势有敏感的洞察力。', 18, 0, '2024-02-26 20:33:04', '2024-02-26 20:33:04', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (151, '进出口贸易', '进出口贸易职位主要负责公司的国际贸易业务，包括寻找国外供应商、谈判交易、处理进出口手续等。他们需要了解国际贸易规则和流程，具备良好的沟通和谈判技巧。', 18, 0, '2024-02-26 20:33:04', '2024-02-26 20:33:04', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (152, '买手', '买手是负责为零售商采购商品的职位。他们需要根据市场趋势和消费者需求选择商品谈判交易条件，以获取最佳的采购结果。', 18, 0, '2024-02-26 20:33:04', '2024-02-26 20:33:04', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (153, '广告', '广告工作涉及创造、设计和发布广告，以提升品牌知名度，吸引潜在客户，推动产品销售。他们需要有创新思维，良好的艺术感和市场敏感度。', 19, 0, '2024-02-26 20:41:14', '2024-02-26 20:41:14', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (154, '市场/营销', '市场/营销专业人士负责制定并执行市场营销策略，以提高产品或服务的市场份额。他们可能会涉及市场研究、广告、公关、促销等各种活动。他们需要具备市场分析、战略规划、项目管理等多方面的能力。', 19, 0, '2024-02-26 20:41:14', '2024-02-26 20:41:14', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (155, '商业数据分析', '商业数据分析职位主要负责收集、处理和分析商业数据，以揭示业务趋势，指导决策他们需要有较强的数据敏感度和分析能力，以及熟练掌握数据分析工具。', 19, 0, '2024-02-26 20:41:14', '2024-02-26 20:41:14', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (156, '政府事务', '政府事务人员需要根据公司的发展战略与管理需求，建立公司与政府相关机构沟通渠道，与相关政府部门战略合作伙伴建立并维持良好的互动关系。此岗位需要具备较强的观察力和应变能力，优秀的人际交往和协调能力，极强的社会活动能力和出色的公关能力。', 19, 0, '2024-02-26 20:41:14', '2024-02-26 20:41:14', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (157, '公关媒介', '公关媒介职业是在品牌与公众之间建立和维护良好关系的关键角色。他们通过各种媒体渠道传递信息，塑造品牌形象，协助处理危机公关，并推动品牌的商业目标。', 19, 0, '2024-02-26 20:41:14', '2024-02-26 20:41:14', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (158, '会务会展', '会务会展专业人员主要负责组织、规划和执行各种会议、展览和大型活动。他们通常需要协调多个部门，如场地管理、供应商联系、活动策划等，以保证活动的顺利进行和成功完成。', 19, 0, '2024-02-26 20:41:14', '2024-02-26 20:41:14', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (159, '广告制作', '广告制作人员是市场营销的创意驱动者，他们负责制定广告策略、设计广告、编写广告文案、制作广告素材，确保广告信息准确、有趣且引人入胜，进而促进产品销售和品牌形象的塑造。', 19, 0, '2024-02-26 20:41:14', '2024-02-26 20:41:14', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (160, '运动健身', '运动健身职业涵盖了一系列与健康和体育相关的工作，包括健身教练、瑜伽教练等。这些专业人士通常需要有良好的身体素质、热爱运动，并且能够指导他人达到身心健康的目标。', 20, 0, '2024-02-26 20:44:13', '2024-02-26 20:44:13', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (161, '验光师', '验光师是眼部健康的专业人员，主要负责评估和改善患者的视力。他们进行视力检查判断是否需要眼镜或隐形眼镜，以及其度数，也可发现患者潜在的眼部疾病，是保障公众视力健康的重要角色。', 20, 0, '2024-02-26 20:44:13', '2024-02-26 20:44:13', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (162, '理疗保健', '理疗保健专业人员通过各种物理治疗技术，如按摩、电疗、热疗等，帮助客户缓解身体疼痛，改善身体机能，提高生活质量。他们需要掌握专业的理疗知识，了解人体结构和生理机能。', 20, 0, '2024-02-26 20:44:13', '2024-02-26 20:44:13', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (163, '美容/美体', '美容/美体专业人员是帮助客户保持外在美丽的专家，他们提供皮肤护理、美容咨询、身体塑形等服务，帮助客户提高自我形象，增强自信。', 20, 0, '2024-02-26 20:44:13', '2024-02-26 20:44:13', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (164, '纹绣师', '纹绣师是在皮肤上进行艺术创作的专业人员，包括眉部纹绣、唇部纹绣、眼线纹绣等他们需要精湛的技艺和艺术创造力，以及对人体结构和皮肤科学的深入理解，以确保安全并提供满意的效果。', 20, 0, '2024-02-26 20:44:13', '2024-02-26 20:44:13', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (165, '美发', '美发师负责为客户设计和塑造发型，包括剪发、烫发、染发等服务。他们需要拥有专业的美发技巧，同时具备良好的审美观，能根据客户的脸型、气质和需求，提供满意的发型设计。', 20, 0, '2024-02-26 20:44:13', '2024-02-26 20:44:13', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (166, '美甲/美睫', '美甲/美睫专业人员使用各种技术和产品，包括凝胶、亚克力和磨砂等，来美化和增强客户的手部和足部。他们还为客户提供假睫毛服务，增强眼部的美感。此类工作需要精细的操作技巧和对美的独特理解。', 20, 0, '2024-02-26 20:44:13', '2024-02-26 20:44:13', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (167, '化妆/造型师', '化妆/造型师利用化妆品和造型工具，为客户创造适合其面部特征和皮肤类型的美观造型。他们可以在多种场合下工作，包括电影、电视、婚礼或者日常生活，他们的目标是提升客户的外观和自信。', 20, 0, '2024-02-26 20:44:13', '2024-02-26 20:44:13', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (168, '安保服务', '安保服务人员负责保护人员和财产的安全，防止罪犯行为和其他潜在危险。他们的工作可能包括巡逻、监控安全摄像头、处理紧急情况，以及编写安全报告。这项工作需要强大的观察力、决策能力和应对压力的能力。', 20, 0, '2024-02-26 20:44:13', '2024-02-26 20:44:13', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (169, '保洁', '保洁人员负责清洁和维护商业或住宅环境的卫生，包括扫地、擦窗、清理浴室等。他们的目标是提供一个干净整洁的环境，让人们在其中感到舒适和愉快。', 20, 0, '2024-02-26 20:44:13', '2024-02-26 20:44:13', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (170, '家政', '家政人员提供家庭管理服务，包括清洁、烹饪、照顾孩子或老人等。他们的工作是确保家庭的日常运行顺利，让家庭成员可以专注于他们的工作或其他责任。这项工作需要有组织能力和责任心。', 20, 0, '2024-02-26 20:44:13', '2024-02-26 20:44:13', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (171, '维修', '维修人员是为了保持设备、机器或建筑的正常运作和维护的专业工作者。他们可能专门从事电器、电子产品、汽车、空调或建筑等领域的维修工作。他们的工作通常需要有丰富的专业知识和实践技能，以便快速找到问题并进行有效的解决', 20, 0, '2024-02-26 20:44:13', '2024-02-26 20:44:13', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (172, '零售', '零售人员在商店或在线平台销售商品，包括食品、服装、家居用品等。他们的工作通常包括了解商品信息，提供客户服务，处理交易等。零售人员需要具备良好的沟通能力和服务意识，以满足客户需求，保证良好的购物体验。', 20, 0, '2024-02-26 20:44:13', '2024-02-26 20:44:13', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (173, '网吧网管', '网吧网管负责维护网吧的计算机系统和网络设备，以保证客户可以顺利进行网络游戏或者互联网浏览。他们的工作可能包括设备维修、系统更新、网络安全管理等，要求他们具备一定的计算机和网络知识。', 20, 0, '2024-02-26 20:44:13', '2024-02-26 20:44:13', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (174, '宠物美容', '宠物美容师为宠物提供美容和清洁服务，包括洗澡、修剪毛发、剪指甲等。他们需要了解不同宠物的美容需求和照顾方法，以提供专业的服务并确保宠物的舒适和健康。', 20, 0, '2024-02-26 20:44:13', '2024-02-26 20:44:13', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (175, '宠物医生', '宠物医生，或称为兽医，负责宠物的健康和医疗护理，包括疾病诊断、治疗、预防接种等。他们需要具备专业的兽医学知识，以保护和改善宠物的健康。', 20, 0, '2024-02-26 20:44:13', '2024-02-26 20:44:13', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (176, '花艺师', '花艺师是艺术和设计的专家，他们利用鲜花和其他自然材料创建美观的花艺作品。这可能包括制作花束、花篮，或者为婚礼、节日和其他特殊场合设计花艺装饰。花艺师需要具备良好的审美眼光、创新思维和熟练的手工技巧。', 20, 0, '2024-02-26 20:44:13', '2024-02-26 20:44:13', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (177, '婚礼策划', '婚礼策划师是帮助新人组织和实施婚礼的专业人员。他们负责从整体主题和预算规划到详细的婚礼日程安排和供应商协调等所有细节，确保婚礼顺利进行，并让新人和嘉宾都能享受这一特殊的日子。', 20, 0, '2024-02-26 20:44:13', '2024-02-26 20:44:13', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (178, '前厅', '前厅工作人员是餐厅的面孔，他们与顾客进行最直接的交流。他们的职责可能包括接待顾客、领位、介绍菜单，以及处理顾客的问题和请求。前厅人员需要具备良好的服务态度和沟通能力，以提供优质的用餐体验。', 21, 0, '2024-02-26 20:57:16', '2024-02-26 20:57:16', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (179, '厨师', '厨师负责准备食材，制作菜品。他们需要熟练掌握各种烹饪技巧，了解食材的特性和搭配，严格遵守食品安全和卫生规定。创新和对美食的热爱是他们的重要素质。', 21, 0, '2024-02-26 20:57:16', '2024-02-26 20:57:16', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (180, '饮品师', '饮品师是专门调制和制作各种饮品的专业人员，包括咖啡、茶、鸡尾酒等。他们需要熟知各种饮品的制作方法和风味特性，以满足不同顾客的口味需求。良好的手艺和对新饮品的探索精神是这个职业的重要素质。', 21, 0, '2024-02-26 20:57:16', '2024-02-26 20:57:16', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (181, '送餐员', '送餐员负责将餐厅的食品安全、准时地送达顾客手中。他们需要熟悉送餐区域的路线并能在各种天气和交通条件下，保持良好的服务态度和专业素质，确保顾客满意。', 21, 0, '2024-02-26 20:57:16', '2024-02-26 20:57:16', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (182, '餐饮管理', '餐饮管理人员负责餐厅的日常运营和管理，包括菜品选择、人员管理、预算控制等。他们必须拥有良好的领导能力、决策能力和人际交往能力，以确保餐厅的高效运营并提供优质的顾客体验。', 21, 0, '2024-02-26 20:57:16', '2024-02-26 20:57:16', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (183, '帮厨', '帮厨是厨房团队的重要组成部分，他们负责协助主厨完成各项烹饪任务，如切菜、准备食材、清洗厨具等。这个职业需要热爱烹饪，能够在厨房的快节奏环境中保持高效工作。', 21, 0, '2024-02-26 20:57:16', '2024-02-26 20:57:16', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (184, '甜点/烘焙', '甜点/烘焙师专注于制作各种甜点和面包产品，他们的工作需要对烘焙原料、制作技术和食品安全有深入的理解。他们的创新和艺术天赋，使得甜点和面包既美味又具有吸引力。', 21, 0, '2024-02-26 20:57:16', '2024-02-26 20:57:16', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (185, '餐饮学徒', '餐饮学徒是正在接受训练，以学习和掌握餐饮业务知识和技能的人员。他们可能会在多个岗位轮流实习，以了解餐饮业的全貌并找到自己最感兴趣的领域。', 21, 0, '2024-02-26 20:57:16', '2024-02-26 20:57:16', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (186, '环保', '环保专业人员致力于保护环境，减少污染，促进可持续发展。他们的工作可能涉及到研究环境问题，开发解决方案，宣传环保知识，监测和评估环保政策的效果等。他们为保护我们的地球做出重要贡献', 22, 0, '2024-02-26 21:02:22', '2024-02-26 21:02:22', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (187, '能源/地质', '能源/地质专业人员专注于地球的物理结构，地质活动以及矿物资源的开发利用。他们的工作涉及到能源生产，如石油、天然气和煤炭的勘探和开采，以及在环保方面的工作，如水资源管理和土壤保护', 22, 0, '2024-02-26 21:02:22', '2024-02-26 21:02:22', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (188, '农业/林业技术员', '农业/林业技术员为农业和林业生产提供技术支持。他们可能参与种植作物、管理林木防治疫病害虫，以及研究和推广农林科技知识，他们的工作对于确保粮食安全和森林资源的可持续利用起着关键作用。', 22, 0, '2024-02-26 21:02:22', '2024-02-26 21:02:22', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (189, '饲养员', '饲养员负责喂养和照顾农场或动物园中的动物。他们需要了解不同动物的饲养技术和需求，如饲料配比、饲养环境等，并进行定期检查，以确保动物的健康。', 22, 0, '2024-02-26 21:02:22', '2024-02-26 21:02:22', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (190, '禽畜/水产养殖技术员', '禽畜/水产养殖技术员专门负责禽畜和水生生物的养殖工作，包括喂养、繁育、防疫等。他们的工作旨在提高养殖效率和产量，保障食品安全，并促进动物福利。', 22, 0, '2024-02-26 21:02:22', '2024-02-26 21:02:22', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (191, '畜牧兽医', '畜牧兽医负责维护和提高动物健康，防止动物疾病的发生和传播。他们的工作涵盖动物疾病的诊断、治疗、疫苗接种，以及对养殖环境的卫生管理等，是动物健康和公众食品安全的守护者。', 22, 0, '2024-02-26 21:02:22', '2024-02-26 21:02:22', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (192, '风控合规清算', '风控合规清算专业人员主要负责在金融机构中实施风险控制和法规合规政策，以及完成交易后的清算工作。他们需要对金融市场的风险进行有效的识别、评估和控制，同时要保证金融交易的顺利进行，遵守相关的法律法规。', 23, 0, '2024-02-26 21:02:22', '2024-02-26 21:11:23', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (193, '投融资', '投融资专业人员负责为个人、企业或政府组织投资和筹集资金。他们的工作涉及研究和分析市场趋势，制定投资策略，为客户提供财务咨询，以及通过发行股票或债券等方式筹集资金。', 23, 0, '2024-02-26 21:02:22', '2024-02-26 21:11:23', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (194, '资产评估', '资产评估专业人员负责为企业或个人的资产进行价值评估。他们会根据市场条件、资产状况和未来收益等因素，提供准确和公正的资产估值报告，这对于资产买卖、抵押贷款和投资决策等都是非常重要的。', 23, 0, '2024-02-26 21:02:22', '2024-02-26 21:11:23', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (195, '证券/基金/期货', '证券/基金/期货专业人员在金融市场中进行证券、基金和期货的交易和管理。他们需要分析经济条件、公司业绩和市场趋势等信息，为投资者提供投资建议和策略', 23, 0, '2024-02-26 21:02:22', '2024-02-26 21:11:23', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (196, '资信评估', '资信评估专业人员负责评估个人或企业的信用状况和偿债能力。他们的评估结果影响到借款人能否获得贷款，以及贷款的利率和额度等，是金融领域的重要工作。', 23, 0, '2024-02-26 21:02:22', '2024-02-26 21:11:23', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (197, '银行', '银行专业人士在金融服务行业中，提供一系列的服务，如储蓄、贷款、投资、保险等。他们可能在个人银行、公司银行、投资银行等多个部门工作。他们需要具备良好的客户服务能力，对金融市场有深入了解，以及风险管理的知识', 23, 0, '2024-02-26 21:02:22', '2024-02-26 21:11:23', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (198, '催收员', '催收员是金融机构的重要角色，他们的主要任务是追回逾期的债务。这项工作需要良好的沟通技巧和谈判技巧，以及对贷款和信用政策的深入理解。他们必须在保持专业和尊重客户的同时，有效地完成催收任务。', 23, 0, '2024-02-26 21:02:22', '2024-02-26 21:11:23', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (199, '保险精算师', '保险精算师是使用数学和统计技术来预测保险业务中的未来事件的专业人员。他们分析风险和不确定性，为保险公司的产品定价、制定保险政策，并评估公司的长期财务安全。他们的工作需要强大的分析技巧和对保险市场的深入理解。', 23, 0, '2024-02-26 21:02:22', '2024-02-26 21:11:23', 0);
INSERT INTO spark_hire.career (id, career_name, description, career_type, post_num, create_time, update_time, is_delete) VALUES (200, '保险理赔', '保险理赔人员处理保险公司的赔偿请求。他们评估保险单的覆盖范围，调查保险事故是决定是否应支付赔偿，以及赔偿的金额。这项工作需要良好的判断力、沟通能力，以及对保险政策和法规的全面理解。', 23, 0, '2024-02-26 21:02:22', '2024-02-26 21:11:23', 0);
