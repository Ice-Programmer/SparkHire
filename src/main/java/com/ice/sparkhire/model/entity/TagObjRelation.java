package com.ice.sparkhire.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import java.util.Date;
import lombok.Data;

/**
 * tag_obj_rel
 * @TableName tag_obj_rel
 */
@TableName(value ="tag_obj_rel")
@Data
public class TagObjRelation implements Serializable {
    /**
     * id
     */
    @TableId(type = IdType.ASSIGN_ID)
    private Long id;

    /**
     * tag id
     */
    private Long tagId;

    /**
     * obj_id
     */
    private Long objId;

    /**
     * obj type(1-employee/2-recruitment)
     */
    private Integer objType;

    /**
     * 创建时间
     */
    private Date createTime;

    @TableField(exist = false)
    private static final long serialVersionUID = 1L;
}