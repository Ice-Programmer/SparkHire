package com.ice.sparkhire.model.enums;

import com.ice.sparkhire.common.BaseEnum;
import lombok.Getter;

/**
 * 求职状态枚举
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/6/9 14:15
 */
@Getter
public enum JobStatusEnum implements BaseEnum<Integer> {
    AVAILABLE("随时到岗", 0),
    WITH_IN_MONTH("月内到岗", 1),
    OPEN_OPPORTUNITY("考虑机会", 2),
    NOT_INTERESTED("暂不考虑", 3);


    private final String text;

    private final Integer value;

    JobStatusEnum(String text, Integer value) {
        this.text = text;
        this.value = value;
    }
}
