package com.ice.sparkhire.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ice.sparkhire.annotation.CustomCache;
import com.ice.sparkhire.constant.cache.CacheConstant;
import com.ice.sparkhire.mapper.CareerTypeMapper;
import com.ice.sparkhire.model.entity.Career;
import com.ice.sparkhire.model.entity.CareerType;
import com.ice.sparkhire.model.vo.CareerVO;
import com.ice.sparkhire.service.CareerService;
import com.ice.sparkhire.mapper.CareerMapper;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @author chenjiahan
 * @description 针对表【career(职业)】的数据库操作Service实现
 * @createDate 2025-07-07 20:21:25
 */
@Service
public class CareerServiceImpl extends ServiceImpl<CareerMapper, Career>
        implements CareerService {

    @Resource
    private CareerTypeMapper careerTypeMapper;

    @Override
    @CustomCache(key = CacheConstant.CAREER_LIST_KEY, duration = CacheConstant.MONTH_EXPIRE_TIME)
    public List<CareerVO> getCareerList() {
        List<CareerType> careerTypeList = careerTypeMapper.selectList(null);

        // careerTypeId -> careerTypeName
        Map<Long, String> careerTypeMap = careerTypeList.stream()
                .collect(Collectors.toMap(CareerType::getId, CareerType::getCareerTypeName));

        List<Career> careerList = baseMapper.selectList(null);
        // careerType -> career
        Map<Integer, List<Career>> carrerMap = careerList.stream()
                .collect(Collectors.groupingBy(Career::getCareerType));

        List<CareerVO> careerVOList = new ArrayList<>();
        for (Integer careerType : carrerMap.keySet()) {
            CareerVO careerVO = new CareerVO();
            careerVO.setCareerTypeName(careerTypeMap.get(careerType.longValue()));
            List<CareerVO.CareerDetail> careerDetailList = carrerMap.get(careerType)
                    .stream().map(CareerVO::objToVO).toList();
            careerVO.setCareerDetailList(careerDetailList);
            careerVOList.add(careerVO);
        }

        return careerVOList;
    }
}




