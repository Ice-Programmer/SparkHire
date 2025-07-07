package com.ice.sparkhire.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.util.Date;
import lombok.Data;

/**
 * 职业
 * @TableName career
 */
@TableName(value ="career")
@Data
public class Career {
    /**
     * id
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 职业名称
     */
    private String careerName;

    /**
     * 职业介绍
     */
    private String description;

    /**
     * 职业类型
     */
    private Integer careerType;

    /**
     * 相关数量
     */
    private Integer postNum;

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
    private Integer isDelete;
}