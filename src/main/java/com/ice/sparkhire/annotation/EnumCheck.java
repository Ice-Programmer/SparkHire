package com.ice.sparkhire.annotation;

import com.ice.sparkhire.common.BaseEnum;
import com.ice.sparkhire.validator.EnumCheckValidator;
import jakarta.validation.Constraint;
import jakarta.validation.Payload;

import java.lang.annotation.*;

/**
 * 类型检测
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/6/4 22:34
 */
@Documented
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = EnumCheckValidator.class)
public @interface EnumCheck {

    /**
     * 默认提示信息
     */
    String message() default "值不在允许枚举范围内";

    /**
     * 枚举类的 class 类型
     */
    Class<? extends BaseEnum<?>> enumClass();

    /**
     * 是否允许空值
     */
    boolean allowNull() default false;

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};

}
