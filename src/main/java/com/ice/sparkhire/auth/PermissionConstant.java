package com.ice.sparkhire.auth;

/**
 * 权限常量
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/8/30 13:25
 */
public class PermissionConstant {

    // ========== 账户相关权限 ==========
    /**
     * 注册（求职者/HR）
     */
    public static final String ACCOUNT_REGISTER = "account:register";
    /**
     * 登录
     */
    public static final String ACCOUNT_LOGIN = "account:login";
    /**
     * 登出
     */
    public static final String ACCOUNT_LOGOUT = "account:logout";
    /**
     * 忘记密码重置
     */
    public static final String ACCOUNT_PWD_RESET = "account:pwdreset";

    // ========== 用户相关权限 ==========
    /**
     * 查看用户列表（管理员）
     */
    public static final String USER_VIEW = "user:view";
    /**
     * 查看用户详情
     */
    public static final String USER_DETAIL = "user:detail";
    /**
     * 编辑用户资料
     */
    public static final String USER_UPDATE = "user:update";
    /**
     * 冻结/解封账号
     */
    public static final String USER_DISABLE = "user:disable";
    /**
     * 逻辑删除用户
     */
    public static final String USER_DELETE = "user:delete";

    // ========== 企业相关权限 ==========
    /**
     * HR 企业认证上传执照
     */
    public static final String ENTERPRISE_APPLY = "enterprise:apply";
    /**
     * 企业认证通过/驳回
     */
    public static final String ENTERPRISE_APPROVE = "enterprise:approve";
    /**
     * 企业列表（管理员）
     */
    public static final String ENTERPRISE_VIEW = "enterprise:view";

    // ========== 职位相关权限 ==========
    /**
     * 发布新职位
     */
    public static final String JOB_CREATE = "job:create";
    /**
     * 编辑职位
     */
    public static final String JOB_UPDATE = "job:update";
    /**
     * 下架/删除职位
     */
    public static final String JOB_DELETE = "job:delete";
    /**
     * 查看职位详情
     */
    public static final String JOB_VIEW = "job:view";
    /**
     * 搜索/筛选职位
     */
    public static final String JOB_LIST = "job:list";
    /**
     * 获取推荐职位列表
     */
    public static final String JOB_RECOMMEND = "job:recommend";
    /**
     * 收藏职位
     */
    public static final String JOB_FAVORITE = "job:favorite";
    /**
     * 取消收藏职位
     */
    public static final String JOB_UNFAVORITE = "job:unfavorite";

    // ========== 简历相关权限 ==========
    /**
     * 新建简历
     */
    public static final String RESUME_CREATE = "resume:create";
    /**
     * 编辑简历
     */
    public static final String RESUME_UPDATE = "resume:update";
    /**
     * 查看简历详情
     */
    public static final String RESUME_VIEW = "resume:view";
    /**
     * 简历实时预览
     */
    public static final String RESUME_PREVIEW = "resume:preview";
    /**
     * 导出 PDF 简历
     */
    public static final String RESUME_EXPORT = "resume:export";
    /**
     * 查看简历版本列表
     */
    public static final String RESUME_VERSION_LIST = "resume:version:list";
    /**
     * 保存简历新版本
     */
    public static final String RESUME_VERSION_CREATE = "resume:version:create";
    /**
     * 恢复历史简历版本
     */
    public static final String RESUME_VERSION_RESTORE = "resume:version:restore";
    /**
     * 设置默认投递简历
     */
    public static final String RESUME_DEFAULT_SET = "resume:default:set";

    // ========== AI优化相关权限 ==========
    /**
     * 触发简历优化任务
     */
    public static final String AI_OPTIMIZE_INIT = "ai:optimize:init";
    /**
     * 查询优化任务状态
     */
    public static final String AI_OPTIMIZE_STATUS = "ai:optimize:status";
    /**
     * 获取优化匹配度及建议列表
     */
    public static final String AI_OPTIMIZE_RESULTS = "ai:optimize:results";
    /**
     * 接受改写建议
     */
    public static final String AI_OPTIMIZE_ACCEPT = "ai:optimize:accept";
    /**
     * 拒绝改写建议
     */
    public static final String AI_OPTIMIZE_REJECT = "ai:optimize:reject";

    // ========== 推荐相关权限 ==========
    /**
     * 查看首页推荐列表
     */
    public static final String REC_HOMEPAGE_VIEW = "rec:homepage:view";
    /**
     * 提交推荐反馈（不感兴趣/查看更多）
     */
    public static final String REC_FEEDBACK = "rec:feedback";
    /**
     * 查看推荐理由
     */
    public static final String REC_EXPLAIN = "rec:explain";

    // ========== 投递相关权限 ==========
    /**
     * 一键投递职位
     */
    public static final String APPLICATION_CREATE = "application:create";
    /**
     * 查询投递记录
     */
    public static final String APPLICATION_LIST = "application:list";
    /**
     * 查看投递详情
     */
    public static final String APPLICATION_DETAIL = "application:detail";
    /**
     * 撤回投递
     */
    public static final String APPLICATION_CANCEL = "application:cancel";
    /**
     * HR 拒绝并填写原因
     */
    public static final String APPLICATION_REJECT = "application:reject";
    /**
     * HR 发起面试邀请
     */
    public static final String APPLICATION_INVITE = "application:invite";

    // ========== 聊天相关权限 ==========
    /**
     * 查看会话列表
     */
    public static final String CHAT_CONVERSATION_LIST = "chat:conversation:list";
    /**
     * 发起新会话
     */
    public static final String CHAT_CONVERSATION_CREATE = "chat:conversation:create";
    /**
     * 获取消息历史
     */
    public static final String CHAT_MESSAGE_LIST = "chat:message:list";
    /**
     * 发送聊天消息
     */
    public static final String CHAT_MESSAGE_SEND = "chat:message:send";
    /**
     * 标记消息已读
     */
    public static final String CHAT_MESSAGE_READ = "chat:message:read";

    // ========== 知识图谱相关权限 ==========
    /**
     * 查看技能图谱页面
     */
    public static final String KG_SKILLS_VIEW = "kg:skills:view";
    /**
     * 查看技能详情及相关职位
     */
    public static final String KG_SKILL_DETAIL = "kg:skill:detail";
    /**
     * 查看职业路径推荐
     */
    public static final String KG_PATH_VIEW = "kg:path:view";

    // ========== 统计相关权限 ==========
    /**
     * 查看个人数据分析页
     */
    public static final String STATS_PERSONAL_VIEW = "stats:personal:view";
    /**
     * 查看全局数据报表页
     */
    public static final String STATS_GLOBAL_VIEW = "stats:global:view";
    /**
     * 获取个人统计数据
     */
    public static final String STATS_PERSONAL_API = "stats:personal:api";
    /**
     * 获取全局统计数据
     */
    public static final String STATS_GLOBAL_API = "stats:global:api";

    // ========== 社区相关权限 ==========
    /**
     * 查看社区首页
     */
    public static final String COMMUNITY_POSTS_VIEW = "community:posts:view";
    /**
     * 发布新帖
     */
    public static final String COMMUNITY_POST_CREATE = "community:post:create";
    /**
     * 查看帖子详情
     */
    public static final String COMMUNITY_POST_VIEW = "community:post:view";
    /**
     * 编辑帖子
     */
    public static final String COMMUNITY_POST_EDIT = "community:post:edit";
    /**
     * 删除帖子
     */
    public static final String COMMUNITY_POST_DELETE = "community:post:delete";
    /**
     * 添加评论
     */
    public static final String COMMUNITY_COMMENT_ADD = "community:comment:add";
    /**
     * 回复评论
     */
    public static final String COMMUNITY_COMMENT_REPLY = "community:comment:reply";
    /**
     * 点赞帖子
     */
    public static final String COMMUNITY_LIKE = "community:like";
    /**
     * 点踩帖子
     */
    public static final String COMMUNITY_DISLIKE = "community:dislike";
    /**
     * 收藏帖子
     */
    public static final String COMMUNITY_POST_COLLECT = "community:post:collect";

    // ========== 通知相关权限 ==========
    /**
     * 列出通知（未读/已读）
     */
    public static final String NOTIF_LIST = "notif:list";
    /**
     * 标记通知已读
     */
    public static final String NOTIF_READ = "notif:read";
    /**
     * 查看通知设置
     */
    public static final String NOTIF_SETTINGS_VIEW = "notif:settings:view";
    /**
     * 更新通知设置
     */
    public static final String NOTIF_SETTINGS_UPDATE = "notif:settings:update";

    // ========== 管理员相关权限 ==========
    /**
     * 查看管理后台大盘
     */
    public static final String ADMIN_DASHBOARD_VIEW = "admin:dashboard:view";
    /**
     * 职位审核（通过/驳回）
     */
    public static final String ADMIN_JOB_REVIEW = "admin:job:review";
    /**
     * 帖子审核（通过/驳回）
     */
    public static final String ADMIN_POST_REVIEW = "admin:post:review";
    /**
     * 查看举报处理列表
     */
    public static final String ADMIN_REPORTS_VIEW = "admin:reports:view";
    /**
     * 处理用户举报
     */
    public static final String ADMIN_REPORT_HANDLE = "admin:report:handle";
    /**
     * 后台冻结用户
     */
    public static final String ADMIN_USER_BAN = "admin:user:ban";
    /**
     * 后台解封用户
     */
    public static final String ADMIN_USER_UNBAN = "admin:user:unban";
}
