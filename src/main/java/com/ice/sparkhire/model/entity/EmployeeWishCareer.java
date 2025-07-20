package com.ice.sparkhire.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;

import java.util.Date;

import lombok.Data;

/**
 * 应聘者期望岗位
 *
 * @TableName employee_wish_career
 */
@TableName(value = "employee_wish_career")
@Data
public class EmployeeWishCareer {
    /**
     * id
     */
    @TableId(type = IdType.ASSIGN_ID)
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
     * 行业id
     */
    private Long industryId;

    /**
     * 薪水要求（例如：10-15,-面议）
     */
    private String salaryExpectation;

    /**
     * 创建时间
     */
    private Date createTime;

    /**
     * 更新时间
     */
    private Date updateTime;

    /**
     * 是否删除
     */
    @TableLogic
    private Integer isDelete;
}