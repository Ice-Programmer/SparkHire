package com.ice.sparkhire.service.impl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ice.sparkhire.constant.ErrorCode;
import com.ice.sparkhire.exception.ThrowUtils;
import com.ice.sparkhire.model.entity.City;
import com.ice.sparkhire.model.enums.ProvinceEnum;
import com.ice.sparkhire.model.vo.CityVO;
import com.ice.sparkhire.service.CityService;
import com.ice.sparkhire.mapper.CityMapper;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @author chenjiahan
 * @description 针对表【city(城市)】的数据库操作Service实现
 * @createDate 2025-07-07 10:05:43
 */
@Service
public class CityServiceImpl extends ServiceImpl<CityMapper, City>
        implements CityService {

    @Override
    public void existCity(Long cityId) {
        boolean exists = baseMapper.exists(Wrappers.<City>lambdaQuery()
                .eq(City::getId, cityId));
        ThrowUtils.throwIf(!exists, ErrorCode.NOT_FOUND_ERROR, "城市 id 不存在");
    }

    @Override
    public List<CityVO> getCityList() {
        // 获取所有省份
        Map<Integer, String> provinceMap = Arrays.stream(ProvinceEnum.values())
                .collect(Collectors.toMap(ProvinceEnum::getValue, ProvinceEnum::getText));

        // provinceId -> cityList
        Map<Integer, List<City>> cityMap = baseMapper.selectList(null).stream()
                .collect(Collectors.groupingBy(City::getProvinceType));

        List<CityVO> cityVOList = new ArrayList<>();
        for (Integer provinceId : cityMap.keySet()) {
            CityVO cityVO = new CityVO();
        }

        return List.of();
    }

}




