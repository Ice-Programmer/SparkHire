package com.ice.sparkhire.model.vo;

import lombok.Data;
import org.hibernate.validator.constraints.Length;

import java.io.Serial;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/12/13 19:02
 */
@Data
public class CompanyVO implements Serializable {

    /**
     * id
     */
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
    private List<String> companyImageList;

    /**
     * 公司产业
     */
    private Long industryId;

    /**
     * 产业名称
     */
    private String industryName;

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
     * 工作城市名称
     */
    private String cityName;

    /**
     * 详细地址
     */
    private String address;

    /**
     * 创建时间
     */
    private Date createTime;

    @Serial
    private static final long serialVersionUID = -4870393669547702885L;
}
