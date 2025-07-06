package com.ice.sparkhire.manager;

import com.ice.sparkhire.constant.ErrorCode;
import com.ice.sparkhire.exception.BusinessException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import jakarta.annotation.Resource;

/**
 * 邮件服务
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/3/9 21:12
 */
@Service
@Slf4j
public class MailManager {

    @Resource
    private JavaMailSender javaMailSender;

    /**
     * 默认发送邮箱
     */
    @Value("${spring.mail.username}")
    private String defaultFrom;

    /**
     * 发送邮件
     *
     * @param from    发送者邮箱
     * @param to      接收者邮箱
     * @param subject 邮件主题
     * @param content 邮件内容
     * @return 是否发送成功
     */
    public boolean sendMail(String from, String to, String subject, String content) {
        try {
            // 创建邮件消息
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(from); // 发送者邮箱
            message.setTo(to); // 接收者邮箱
            message.setSubject(subject); // 邮件主题
            message.setText(content); // 邮件内容
            // 发送邮件
            javaMailSender.send(message);
            log.info("发送邮件成功，发送者「{}」，接受者：「{}」", from, to);
            return true;
        } catch (Exception e) {
            log.error("发送邮件失败", e);
            throw new BusinessException(ErrorCode.OPERATION_ERROR, "发送邮件失败");
        }
    }

    /**
     * 发送邮件（默认发送者）
     *
     * @param to      接收者邮箱
     * @param subject 邮件主题
     * @param content 邮件内容
     * @return 是否发送成功
     */
    public boolean sendMail(String to, String subject, String content) {
        // 从配置文件中读取默认发送者邮箱
        if (defaultFrom == null || defaultFrom.isEmpty()) {
            throw new BusinessException(ErrorCode.SYSTEM_ERROR, "默认发送者邮箱未配置");
        }
        return sendMail(defaultFrom, to, subject, content);
    }
}
