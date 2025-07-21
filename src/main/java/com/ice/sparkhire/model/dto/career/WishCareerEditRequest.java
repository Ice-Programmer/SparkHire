package com.ice.sparkhire.model.dto.career;

import lombok.Data;

/**
 * 期望职业编辑请求
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/7/20 09:11
 */
@Data
public class WishCareerEditRequest {

    /**
     * id
     */
    private Long id;

    /**
     * 职业id
     */
    private Long careerId;

    /**
     * 行业id
     */
    private Long industryId;

    /**
     * 薪水要求（例如：10-15,-面议）
     */
    private String salaryExpectation;
}
