package com.ice.sparkhire.model.enums;

import com.ice.sparkhire.common.BaseEnum;
import lombok.Getter;

/**
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/11/29 21:45
 */
@Getter
public enum UserGenderEnum implements BaseEnum<Integer> {
    MALE("男", 0),
    FEMALE("女", 1),
    SECRET("不愿透露", 3);

    private final String text;

    private final Integer value;

    UserGenderEnum(String text, Integer value) {
        this.text = text;
        this.value = value;
    }
}
