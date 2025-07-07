package com.ice.sparkhire.model.vo;

import com.ice.sparkhire.model.entity.Career;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;
import java.util.List;

/**
 * 职业展示类
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/7/7 20:23
 */
@Data
@NoArgsConstructor
public class CareerVO implements Serializable {

    /**
     * 职业类型名称
     */
    private String careerTypeName;

    /**
     * 职业详细列表
     */
    private List<CareerDetail> careerDetailList;

    @Data
    @NoArgsConstructor
    public static class CareerDetail {

        /**
         * id
         **/
        private Long id;

        /**
         * 职业名称
         **/
        private String careerName;

        /**
         * 职业描述
         **/
        private String description;
    }

    /**
     * 实体类转视图类
     *
     * @param career 职业
     * @return 职业视图类
     */
    public static CareerDetail objToVO(Career career) {
        CareerDetail careerDetail = new CareerDetail();
        careerDetail.setId(career.getId());
        careerDetail.setCareerName(career.getCareerName());
        careerDetail.setDescription(career.getDescription());
        return careerDetail;
    }


    @Serial
    private static final long serialVersionUID = -4269212232077098389L;
}
