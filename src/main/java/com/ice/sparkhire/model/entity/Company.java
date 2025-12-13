package com.ice.sparkhire.model.entity;

import com.baomidou.mybatisplus.annotation.*;

import java.io.Serial;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import lombok.Data;

/**
 * 公司信息
 * @TableName company
 */
@TableName(value ="company")
@Data
public class Company implements Serializable {
    /**
     * id
     */
    @TableId(type = IdType.ASSIGN_ID)
    private Long id;

    /**
     * 公司名称
     */
    private String companyName;

    /**
     * 公司介绍
     */
    private String description;

    /**
     * 相关数量
     */
    private Integer postNum;

    /**
     * 公司 Logo
     */
    private String logo;

    /**
     * 公司背景图片
     */
    private String backgroundImage;

    /**
     * 公司图片
     */
    private String companyImages;

    /**
     * 公司产业
     */
    private Long industryId;

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