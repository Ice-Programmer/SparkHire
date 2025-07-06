package com.ice.sparkhire.mq.task;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;

/**
 * 邮件发送任务
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/6/23 13:06
 */
@Data
@NoArgsConstructor
public class EmailMessageTask implements Serializable {

    @Serial
    private static final long serialVersionUID = 1052904506252453310L;

    /**
     * 发送邮箱地址
     */
    private String targetEmail;

    /**
     * 发送主题
     */
    private String subject;

    /**
     * 发送内容
     */
    private String content;
}