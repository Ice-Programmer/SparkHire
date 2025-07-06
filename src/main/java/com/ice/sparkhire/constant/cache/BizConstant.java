package com.ice.sparkhire.constant.cache;

/**
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/7/4 18:59
 */
public interface BizConstant {

    /**
     * 第三方服务 相关key
     */
    String BIZ_PREFIX = "biz:";

    /**
     * 邮箱验证是否发送 key
     */
    String EMAIL_VERIFY_SEND_PREFIX = BIZ_PREFIX + "auth:email:verify:send:";

    /**
     * 邮箱验证码 key
     */
    String EMAIL_VERIFY_CODE_PREFIX = BIZ_PREFIX + "auth:email:verify:code:";

    /**
     * 学校列表类型
     **/
    String SCHOOL_LIST_KEY = "information:school:list";

    /**
     * 学校列表过期时间（30 天）
     */
    long SCHOOL_LIST_TTL = 30 * 24 * 60 * 60L;
}
