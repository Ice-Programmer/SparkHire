package com.ice.sparkhire.service;

import com.ice.sparkhire.model.entity.City;
import com.baomidou.mybatisplus.extension.service.IService;
import com.ice.sparkhire.model.vo.CityVO;

import java.util.List;

/**
 * @author chenjiahan
 * @description 针对表【city(城市)】的数据库操作Service
 * @createDate 2025-07-07 10:05:43
 */
public interface CityService extends IService<City> {

    /**
     * 城市 id 是否存在
     *
     * @param cityId 城市 id
     */
    void existCity(Long cityId);

    /**
     * 城市列表
     *
     * @return 城市列表
     */
    List<CityVO> getCityList();
}
