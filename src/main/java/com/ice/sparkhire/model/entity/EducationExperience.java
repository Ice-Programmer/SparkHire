package com.ice.sparkhire.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import java.util.Date;
import lombok.Data;

/**
 * 教育经历
 * @TableName education_experience
 */
@TableName(value ="education_experience")
@Data
public class EducationExperience {
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
     * 学校id
     */
    private Long schoolId;

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
     * 在校经历
     */
    private String activity;

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