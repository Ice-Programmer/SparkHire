package com.ice.sparkhire.validator;

import com.ice.sparkhire.annotation.EnumCheck;
import com.ice.sparkhire.common.BaseEnum;
import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

import java.util.Arrays;

/**
 * 枚举字段类型校验
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/6/4 22:43
 */
public class EnumCheckValidator implements ConstraintValidator<EnumCheck, Object> {

    private BaseEnum<?>[] enumConstants;
    private boolean allowNull;

    /**
     * 初始化参数
     */
    @Override
    public void initialize(EnumCheck enumCheck) {
        this.enumConstants = enumCheck.enumClass().getEnumConstants();
        this.allowNull = enumCheck.allowNull();
    }

    @Override
    public boolean isValid(Object value, ConstraintValidatorContext constraintValidatorContext) {
        if (value == null) {
            return allowNull;
        }
        return Arrays.stream(enumConstants)
                .map(BaseEnum::getValue)
                .anyMatch(v -> v.equals(value));
    }
}
