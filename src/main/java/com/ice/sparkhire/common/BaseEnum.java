package com.ice.sparkhire.common;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/6/5 08:34
 */
public interface BaseEnum<V> {

    V getValue();

    String getText();

    /**
     * 获取所有枚举的 value 列表
     */
    static <E extends BaseEnum<T>, T> List<T> getValues(Class<E> enumClass) {
        return Arrays.stream(enumClass.getEnumConstants())
                .map(BaseEnum::getValue)
                .collect(Collectors.toList());
    }

    /**
     * 根据 value 获取对应的枚举
     */
    static <E extends BaseEnum<T>, T> E getEnumByValue(Class<E> enumClass, T value) {
        if (value == null) {
            return null;
        }
        return Arrays.stream(enumClass.getEnumConstants())
                .filter(e -> e.getValue().equals(value))
                .findFirst()
                .orElse(null);
    }

}
