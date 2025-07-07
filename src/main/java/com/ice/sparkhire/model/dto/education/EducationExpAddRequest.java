package com.ice.sparkhire.model.dto.education;

import com.ice.sparkhire.annotation.EnumCheck;
import com.ice.sparkhire.model.enums.EducationEnum;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import lombok.Data;
import org.hibernate.validator.constraints.Length;

import java.io.Serial;
import java.io.Serializable;

/**
 * 学习经历添加请求
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/7/7 21:18
 */
@Data
public class EducationExpAddRequest implements Serializable {

    /**
     * 学校id
     */
    private Long schoolId;

    /**
     * 学历类型
     */
    @EnumCheck(enumClass = EducationEnum.class, message = "学历类型错误！")
    private Integer educationType;

    /**
     * 开始年份
     */
    @Min(value = 1950, message = "开始年份不得早于 1950 年")
    @Max(value = 2099, message = "开始年份不得晚于 2099 年")
    private Integer beginYear;

    /**
     * 结束年份
     */
    @Min(value = 1950, message = "结束年份不得早于 1950 年")
    @Max(value = 2099, message = "结束年份不得晚于 2099 年")
    private Integer endYear;

    /**
     * 专业id
     */
    private Long majorId;

    /**
     * 在校经历
     */
    @Length(max = 1000, message = "在校经历最多不得超过 1000 字！")
    private String activity;

    @Serial
    private static final long serialVersionUID = -5874059882592325111L;
}
