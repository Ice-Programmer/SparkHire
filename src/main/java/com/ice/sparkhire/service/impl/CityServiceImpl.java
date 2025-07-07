package com.ice.sparkhire.service.impl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ice.sparkhire.constant.ErrorCode;
import com.ice.sparkhire.exception.ThrowUtils;
import com.ice.sparkhire.model.dto.employee.EmployeeAddRequest;
import com.ice.sparkhire.model.entity.City;
import com.ice.sparkhire.service.CityService;
import com.ice.sparkhire.mapper.CityMapper;
import org.springframework.stereotype.Service;

/**
* @author chenjiahan
* @description 针对表【city(城市)】的数据库操作Service实现
* @createDate 2025-07-07 10:05:43
*/
@Service
public class CityServiceImpl extends ServiceImpl<CityMapper, City>
    implements CityService{

    @Override
    public void existCity(Long cityId) {
        boolean exists = baseMapper.exists(Wrappers.<City>lambdaQuery()
                .eq(City::getId, cityId));
        ThrowUtils.throwIf(!exists, ErrorCode.NOT_FOUND_ERROR, "城市 id 不存在");
    }

}




