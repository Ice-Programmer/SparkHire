package com.ice.sparkhire.model.entity;

import com.baomidou.mybatisplus.annotation.*;

import java.io.Serial;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import lombok.Data;

/**
 * 招聘信息
 * @TableName recruitment
 */
@TableName(value ="recruitment")
@Data
public class Recruitment implements Serializable {
    /**
     * id
     */
    @TableId(type = IdType.ASSIGN_ID)
    private Long id;

    /**
     * 岗位招聘标题
     */
    private String jobName;

    /**
     * 岗位发布者id
     */
    private Long userId;

    /**
     * 公司id
     */
    private Long companyId;

    /**
     * 职业id
     */
    private Long positionId;

    /**
     * 行业id
     */
    private Long industryId;

    /**
     * 职位详情
     */
    private String description;

    /**
     * 最低学历要求
     */
    private Integer educationType;

    /**
     * 职业类型（实习、兼职、春招、社招）
     */
    private Integer type;

    /**
     * 薪水上限
     */
    private Integer salaryUpper;

    /**
     * 薪水下限
     */
    private Integer salaryLower;

    /**
     * 招聘状态 （0 - 招聘中 1 - 结束招聘）
     */
    private Integer status;

    /**
     * 浏览次数
     */
    private Integer viewCount;

    /**
     * 投递次数
     */
    private Integer applyCount;

    /**
     * 纬度
     */
    private BigDecimal latitude;

    /**
     * 经度
     */
    private BigDecimal longitude;

    /**
     * 工作城市 id
     */
    private Long cityId;

    /**
     * 详细地址
     */
    private String workAddress;

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

    @TableField(exist = false)
    @Serial
    private static final long serialVersionUID = 1L;
}