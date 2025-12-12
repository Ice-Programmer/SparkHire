package com.ice.sparkhire.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

/**
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/8/10 14:31
 */
@Data
@NoArgsConstructor
public class EmployeeVO implements Serializable {
    /**
     * id
     */
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
     * 技能标签
     */
    private String skillTags;

    /**
     * 证书列表
     */
    private List<EmployeeQualificationVO> qualificationList;

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
     * 城市 id
     */
    private Long cityId;

    /**
     * 城市名称
     */
    private String cityName;

    /**
     * 纬度
     */
    private BigDecimal latitude;

    /**
     * 经度
     */
    private BigDecimal longitude;

    /**
     * 职员证书 VO
     */
    @Data
    @NoArgsConstructor
    public static class EmployeeQualificationVO {

        /**
         * id
         */
        private Long id;

        /**
         * 证书名称
         */
        private String qualificationName;
    }

    @Serial
    private static final long serialVersionUID = 1091831674947979471L;
}
