package com.ice.sparkhire.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ice.sparkhire.model.entity.CareerType;
import com.ice.sparkhire.service.CareerTypeService;
import com.ice.sparkhire.mapper.CareerTypeMapper;
import org.springframework.stereotype.Service;

/**
* @author chenjiahan
* @description 针对表【career_type(职业类型表)】的数据库操作Service实现
* @createDate 2025-07-07 20:21:25
*/
@Service
public class CareerTypeServiceImpl extends ServiceImpl<CareerTypeMapper, CareerType>
    implements CareerTypeService{

}




