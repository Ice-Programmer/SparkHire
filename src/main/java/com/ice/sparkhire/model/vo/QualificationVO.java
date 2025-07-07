package com.ice.sparkhire.model.vo;

import com.ice.sparkhire.model.entity.Qualification;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * 资格证书 VO
 */
@Data
@NoArgsConstructor
public class QualificationVO {

    /**
     * 资格证书类型
     */
    private String qualificationType;

    /**
     * 资格证书列表
     */
    private List<QualificationDetail> qualificationDetailList;

    @Data
    @NoArgsConstructor
    public static class QualificationDetail {

        /**
         * id
         */
        private Long id;

        /**
         * 资格证书名称
         */
        private String qualificationName;
    }

    /**
     * 实体类转 VO
     *
     * @param qualification 证书实体类
     * @return VO
     */
    public static QualificationDetail objToVO(Qualification qualification) {
        QualificationDetail qualificationDetail = new QualificationDetail();
        qualificationDetail.setId(qualification.getId());
        qualificationDetail.setQualificationName(qualification.getQualificationName());
        return qualificationDetail;
    }
}