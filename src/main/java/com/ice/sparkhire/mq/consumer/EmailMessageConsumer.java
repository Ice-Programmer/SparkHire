package com.ice.sparkhire.mq.consumer;

import com.ice.sparkhire.manager.MailManager;
import com.ice.sparkhire.mq.constant.ConsumerGroupConstant;
import com.ice.sparkhire.mq.constant.MessageTopicConstant;
import com.ice.sparkhire.mq.task.EmailMessageTask;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

/**
 * 邮件消息消费者
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/1/20 10:00
 */
@Component
@Slf4j
public class EmailMessageConsumer {

    @Resource
    private MailManager mailManager;

    @KafkaListener(topics = MessageTopicConstant.EMAIL_SEND_TASK, groupId = ConsumerGroupConstant.EMAIL_CONSUMER_GROUP)
    public void onMessage(EmailMessageTask emailMessageTask) {
        try {
            log.info("接收到邮件发送任务，目标邮箱：{}, 主题：{}",
                    emailMessageTask.getTargetEmail(), emailMessageTask.getSubject());

            // 发送邮件
            boolean success = mailManager.sendMail(
                    emailMessageTask.getTargetEmail(),
                    emailMessageTask.getSubject(),
                    emailMessageTask.getContent()
            );

            if (success) {
                log.info("邮件发送成功，目标邮箱：{}", emailMessageTask.getTargetEmail());
            } else {
                log.error("邮件发送失败，目标邮箱：{}", emailMessageTask.getTargetEmail());
            }
        } catch (Exception e) {
            log.error("处理邮件发送任务失败，目标邮箱：{}", emailMessageTask.getTargetEmail(), e);
            // todo 对消费失败的任务进行落库或者重新消费
        }
    }
}