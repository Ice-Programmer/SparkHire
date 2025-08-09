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

    public static final String MULTI_LOGIN_WARNING_SUBJECT = "【SparkHire 安全提醒】您的账号在异地设备登录";

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

    /**
     * 多地登录提醒邮件模板
     *
     * @param loginTime     登录时间
     * @param loginLocation 登录地点
     * @param deviceType    设备类型
     * @return 邮件信息
     */
    public static String multiLoginWarningMessage(String loginTime, String loginLocation, String deviceType) {
        return String.format("""
                        尊敬的【用户】：
                        您好！我们检测到您的账号于 %s 在【%s】通过【%s】设备登录。
                        
                        如非本人操作，您的账号可能存在安全风险，请立即：
                        1. 修改账号密码
                        2. 检查账号安全设置
                        
                        如确认是本人操作，请忽略此邮件。
                        
                        感谢您使用【SparkHire】！
                        【Ice Man】团队""",
                loginTime, loginLocation, deviceType);
    }
}