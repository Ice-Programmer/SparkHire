package com.ice.sparkhire.mq.constant;


import com.ice.sparkhire.model.enums.VerifyModeEnum;

/**
 * 邮件内容常量
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/3/9 23:10
 */
public class MailMessageConstant {

    public static final String VERIFY_CODE_SUBJECT = "【SparkHire】验证码通知";

    /**
     * 验证码邮件模版
     *
     * @param verifyCode 验证码
     * @param modeEnum   操作类型
     * @return 邮件信息
     */
    public static String verifyCodeMessage(String verifyCode, VerifyModeEnum modeEnum) {
        return String.format("""
                        尊敬的【用户】：
                        您好！您正在执行【 %s 】操作，本次操作的验证码为：
                        【 %s 】
                        验证码有效期【有效期：5 分钟】，请尽快完成操作。
                        如非本人操作，请忽略此邮件。
                        感谢您使用【SparkHire】！
                        【Ice Man】团队""",
                modeEnum.getValue(), verifyCode);
    }
}