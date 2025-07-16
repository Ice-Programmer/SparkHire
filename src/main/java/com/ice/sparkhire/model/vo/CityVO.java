package com.ice.sparkhire.model.vo;

import com.ice.sparkhire.model.entity.City;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;
import java.util.List;

/**
 * 城市视图类
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/7/7 23:03
 */
@Data
@NoArgsConstructor
public class CityVO implements Serializable {

    /**
     * 省份名称
     **/
    private String provinceName;

    /**
     * 城市列表
     */
    private List<CityDetail> cityDetailList;

    @Data
    @NoArgsConstructor
    public static class CityDetail {

        /**
         * id
         */
        private Long id;

        /**
         * 城市名称
         */
        private String cityName;
    }

    /**
     * 实体类转视图类
     *
     * @param city 城市
     * @return 城市视图类
     */
    public static CityDetail objToVO(City city) {
        CityDetail cityDetail = new CityDetail();
        cityDetail.setId(city.getId());
        cityDetail.setCityName(city.getCityName());
        return cityDetail;
    }

    @Serial
    private static final long serialVersionUID = -4207661633414883010L;
}
