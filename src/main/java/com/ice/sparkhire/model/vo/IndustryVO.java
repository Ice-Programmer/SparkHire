package com.ice.sparkhire.model.vo;

import com.ice.sparkhire.model.entity.Industry;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;
import java.util.List;

/**
 * 行业信息 VO
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/7/7 20:01
 */
@Data
@NoArgsConstructor
public class IndustryVO implements Serializable {

    /**
     * 行业类型
     */
    private String industryType;


    /**
     * 行业列表
     */
    private List<IndustryDetail> industryDetails;

    @Data
    @NoArgsConstructor
    public static class IndustryDetail {

        /**
         * id
         */
        private Long id;

        /**
         * 行业名称
         */
        private String name;
    }

    /**
     * 实体类转视图类
     *
     * @param industry 行业
     * @return 行业视图类
     */
    public static IndustryDetail objToVO(Industry industry) {
        IndustryDetail industryDetail = new IndustryDetail();
        industryDetail.setId(industry.getId());
        industryDetail.setName(industry.getIndustryName());
        return industryDetail;
    }

    @Serial
    private static final long serialVersionUID = 1440593594956387101L;
}
