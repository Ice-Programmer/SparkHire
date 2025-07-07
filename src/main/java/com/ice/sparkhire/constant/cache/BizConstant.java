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
     * 学校列表 key
     **/
    String SCHOOL_LIST_KEY = BIZ_PREFIX + "information:school:list";

    /**
     * 专业列表 key
     **/
    String MAJOR_LIST_KEY = BIZ_PREFIX + "information:major:list";

    /**
     * 证书列表 key
     **/
    String QUALIFICATION_LIST_KEY = BIZ_PREFIX + "information:qualification:list";

    /**
     * 行业列表 key
     **/
    String INDUSTRY_LIST_KEY = BIZ_PREFIX + "information:industry:list";
}
