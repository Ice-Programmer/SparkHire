package com.ice.sparkhire.model.vo;


import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

/**
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/7/7 22:24
 */
@Data
public class EducationExperienceVO implements Serializable {

    /**
     * id
     */
    private Long id;

    /**
     * 学校id
     */
    private Long schoolId;

    /**
     * 学习名称
     */
    private String schoolName;

    /**
     * 学历类型
     */
    private Integer educationType;

    /**
     * 开始年份
     */
    private Integer beginYear;

    /**
     * 结束年份
     */
    private Integer endYear;

    /**
     * 专业id
     */
    private Long majorId;

    /**
     * 专业名称
     */
    private String majorName;

    /**
     * 在校经历
     */
    private String activity;


    @Serial
    private static final long serialVersionUID = 3054787421884356084L;
}
