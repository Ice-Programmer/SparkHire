package com.ice.sparkhire.model.enums;

import com.ice.sparkhire.common.BaseEnum;
import lombok.Getter;

/**
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/12/14 17:00
 */
@Getter
public enum TagObjTypeEnum implements BaseEnum<Integer> {
    EMPLOYEE_TYPE("employee", 1),
    RECRUITMENT_TYPE("recruitment", 2);

    private final String text;

    private final Integer value;

    TagObjTypeEnum(String text, Integer value) {
        this.text = text;
        this.value = value;
    }
}
