package com.ice.sparkhire.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.util.Date;
import lombok.Data;

/**
 * 城市
 * @TableName city
 */
@TableName(value ="city")
@Data
public class City {
    /**
     * id
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 城市名称
     */
    private String cityName;

    /**
     * 省份类型
     */
    private Integer provinceType;

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