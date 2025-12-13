package com.ice.sparkhire.model.dto.company;

import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;
import org.hibernate.validator.constraints.Length;

import java.io.Serial;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

/**
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/12/13 18:45
 */
@Data
public class CompanyEditRequest implements Serializable {

    /**
     * id
     */
    @NotNull
    private Long id;

    /**
     * 公司名称
     */
    @Length(max = 100, message = "公司名称不得超过 100 字！")
    private String companyName;

    /**
     * 公司介绍
     */
    @Length(max = 1000, message = "公司简介不得超过 1000 字！")
    private String description;


    /**
     * 公司 Logo
     */
    @Length(max = 200)
    private String logo;

    /**
     * 公司背景图片
     */
    @Length(max = 200)
    private String backgroundImage;

    /**
     * 公司图片
     */
    @Size(max = 20, message = "公司相关图片不能超过 20 个")
    private List<String> companyImages;

    /**
     * 公司产业
     */
    @NotNull
    private Long industryId;

    /**
     * 纬度
     */
    @DecimalMin(value = "-90.0", message = "纬度不能小于 -90")
    @DecimalMax(value = "90.0", message = "纬度不能大于 90")
    private BigDecimal latitude;

    /**
     * 经度
     */
    @DecimalMin(value = "-180.0", message = "经度不能小于 -180")
    @DecimalMax(value = "180.0", message = "经度不能大于 180")
    private BigDecimal longitude;

    /**
     * 详细地址
     */
    @Length(max = 300, message = "公司地址不得超过 300 字！")
    private String workAddress;

    /**
     * 工作城市 id
     */
    @NotNull
    private Long cityId;

    @Serial
    private static final long serialVersionUID = 579153415633954635L;
}
