package com.ice.sparkhire.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;

import java.math.BigDecimal;
import java.util.Date;

import lombok.Data;

/**
 * 求职者
 *
 * @TableName employee
 */
@TableName(value = "employee")
@Data
public class Employee {
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
     * 年龄
     */
    private Integer age;

    /**
     * 自我评价
     */
    private String profile;

    /**
     * 技能标签
     */
    private String skillTags;

    /**
     * 证书列表
     */
    private String qualifications;

    /**
     * 最高学历
     */
    private Integer education;

    /**
     * 毕业年份
     */
    private Integer graduationYear;

    /**
     * 求职状态
     */
    private Integer jobStatus;

    /**
     * 居住地
     */
    private Long cityId;

    /**
     * 纬度
     */
    private BigDecimal latitude;

    /**
     * 经度
     */
    private BigDecimal longitude;

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