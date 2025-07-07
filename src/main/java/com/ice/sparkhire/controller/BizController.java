package com.ice.sparkhire.controller;

import cn.hutool.core.util.RandomUtil;
import com.ice.sparkhire.auth.IgnoreAuth;
import com.ice.sparkhire.common.BaseResponse;
import com.ice.sparkhire.common.ResultUtils;
import com.ice.sparkhire.constant.ErrorCode;
import com.ice.sparkhire.constant.cache.CacheConstant;
import com.ice.sparkhire.exception.BusinessException;
import com.ice.sparkhire.exception.ThrowUtils;
import com.ice.sparkhire.manager.RedisManager;
import com.ice.sparkhire.model.dto.mail.VerifyCodeRequest;
import com.ice.sparkhire.model.enums.VerifyModeEnum;
import com.ice.sparkhire.mq.constant.MailMessageConstant;
import com.ice.sparkhire.mq.producer.EmailMessageProducer;
import com.ice.sparkhire.mq.task.EmailMessageTask;
import com.ice.sparkhire.validator.ValidatorUtil;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.util.DigestUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.concurrent.TimeUnit;

/**
 * 第三方服务相关接口
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/7/6 13:03
 */
@RestController
@RequestMapping("/biz")
@Slf4j
public class BizController {

    @Resource
    private RedisManager redisManager;

    @Resource
    private EmailMessageProducer emailMessageProducer;

    /**
     * 邮箱发送验证码
     *
     * @param verifyCodeRequest 邮箱请求类
     * @return 验证码
     */
    @PostMapping("/verify/code/")
    @IgnoreAuth
    public BaseResponse<String> sendVerifyCode(@RequestBody VerifyCodeRequest verifyCodeRequest) {
        if (verifyCodeRequest == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "发送邮箱为空");
        }
        // 1. 获取邮箱
        String email = verifyCodeRequest.getEmail();
        ThrowUtils.throwIf(!ValidatorUtil.isValidEmail(email), ErrorCode.PARAMS_ERROR, "邮箱格式错误");

        // 2. 判断是否已经发送过验证码
        String emailHash = DigestUtils.md5DigestAsHex(email.getBytes());
        String sendCacheKey = CacheConstant.EMAIL_VERIFY_SEND_PREFIX + emailHash;
        if (redisManager.exists(sendCacheKey)) {
            throw new BusinessException(ErrorCode.OPERATION_ERROR, "验证码已发送，请不要重复操作");
        }
        redisManager.set(sendCacheKey, CacheConstant.TRUE_VALUE, 1, TimeUnit.MINUTES);

        // 3. 验证码保存 redis 中
        // 生成验证码
        String verifyCodeCacheKey = CacheConstant.EMAIL_VERIFY_CODE_PREFIX + emailHash;
        String verifyCode = RandomUtil.randomNumbers(6);
        log.info("成功生成验证码：「{}」，有效期 5 分钟", verifyCode);
        redisManager.set(verifyCodeCacheKey, verifyCode, 5, TimeUnit.MINUTES);

        // 4. 发送邮箱（采用消息队列）
        EmailMessageTask emailMessageTask = new EmailMessageTask();
        emailMessageTask.setTargetEmail(email);
        emailMessageTask.setSubject(MailMessageConstant.VERIFY_CODE_SUBJECT);
        emailMessageTask.setContent(MailMessageConstant.verifyCodeMessage(verifyCode, VerifyModeEnum.LOGIN));
        emailMessageProducer.sendEmailMessage(emailMessageTask);

        return ResultUtils.success(verifyCode);
    }
}
