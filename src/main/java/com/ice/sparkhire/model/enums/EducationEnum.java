package com.ice.sparkhire.model.enums;

import com.ice.sparkhire.common.BaseEnum;
import lombok.Getter;

/**
 * 学历枚举
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/6/9 14:15
 */
@Getter
public enum EducationEnum implements BaseEnum<Integer> {
    COLLEGE("大专生", 0),
    UNDERGRADUATE("本科生", 1),
    GRADUATE("研究生", 2),
    DOCTORAL("博士生", 3);


    private final String text;

    private final Integer value;

    EducationEnum(String text, Integer value) {
        this.text = text;
        this.value = value;
    }
}
