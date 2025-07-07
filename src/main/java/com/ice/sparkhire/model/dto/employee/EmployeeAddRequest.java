package com.ice.sparkhire.model.dto.employee;

import com.ice.sparkhire.annotation.EnumCheck;
import com.ice.sparkhire.model.entity.Employee;
import com.ice.sparkhire.model.enums.EducationEnum;
import com.ice.sparkhire.model.enums.JobStatusEnum;
import jakarta.validation.constraints.*;
import lombok.Data;
import org.hibernate.validator.constraints.Length;

import java.io.Serial;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

/**
 * 求职者信息新增
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/7/6 20:43
 */
@Data
public class EmployeeAddRequest implements Serializable {

    /**
     * 年龄
     */
    @Min(value = 0, message = "年龄不能小于 0")
    @Max(value = 99, message = "年龄不得大于 99")
    private Integer age;

    /**
     * 自我评价
     */
    @Length(max = 1000, message = "自我介绍长度不能超过 1000 字!")
    private String profile;

    /**
     * 技能标签
     */
    @Size(max = 20, message = "技能标签不能超过 20 个")
    private List<String> skillTags;

    /**
     * 最高学历
     */
    @EnumCheck(enumClass = EducationEnum.class, message = "学历类型错误")
    private Integer education;

    /**
     * 毕业年份
     */
    @Min(value = 1950, message = "毕业年份不得早于 1950 年")
    @Max(value = 2099, message = "毕业年份不得晚于 2099 年")
    private Integer graduationYear;

    /**
     * 求职状态
     */
    @EnumCheck(enumClass = JobStatusEnum.class, message = "求职意愿类型错误")
    private Integer jobStatus;

    /**
     * 居住地
     */
    private Long cityId;

    /**
     * 纬度
     */
    @DecimalMin(value = "-90.0",message = "纬度不能小于 -90")
    @DecimalMax(value = "90.0", message = "纬度不能大于 90")
    private BigDecimal latitude;

    /**
     * 经度
     */
    @DecimalMin(value = "-180.0", message = "经度不能小于 -180")
    @DecimalMax(value = "180.0", message = "经度不能大于 180")
    private BigDecimal longitude;

    @Serial
    private static final long serialVersionUID = -5870886628429613019L;
}
