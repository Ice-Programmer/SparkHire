package com.ice.sparkhire.mq.producer;

import com.ice.sparkhire.mq.constant.MessageTopicConstant;
import com.ice.sparkhire.mq.task.EmailMessageTask;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Component;

/**
 * 邮件消息生产者
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/1/20 10:00
 */
@Component
@Slf4j
public class EmailMessageProducer {

    @Resource
    private KafkaTemplate<String, Object> kafkaTemplate;

    /**
     * 发送邮件消息
     *
     * @param emailMessageTask 邮件任务
     */
    public void sendEmailMessage(EmailMessageTask emailMessageTask) {
        try {
            kafkaTemplate.send(MessageTopicConstant.EMAIL_SEND_TASK, emailMessageTask);
            log.info("发送邮件消息成功，目标邮箱：{}, 主题：{}",
                    emailMessageTask.getTargetEmail(), emailMessageTask.getSubject());
        } catch (Exception e) {
            log.error("发送邮件消息失败，目标邮箱：{}, 主题：{}",
                    emailMessageTask.getTargetEmail(), emailMessageTask.getSubject(), e);
        }
    }
}