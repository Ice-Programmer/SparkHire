package com.ice.sparkhire.model.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.util.Date;

/**
 * 应聘者期望岗位 视图类
 */
@Data
public class EmployeeWishCareerVO {
    /**
     * id
     */
    private Long id;

    /**
     * 用户id
     */
    private Long userId;

    /**
     * 职业id
     */
    private Long careerId;

    /**
     * 职业名称
     */
    private String careerName;

    /**
     * 行业id
     */
    private Long industryId;

    /**
     * 行业名称
     */
    private String industryName;

    /**
     * 薪水要求（例如：10-15,-面议）
     */
    private String salaryExpectation;

    /**
     * 创建时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date createTime;
}