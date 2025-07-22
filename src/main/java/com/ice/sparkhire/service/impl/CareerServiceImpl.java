package com.ice.sparkhire.service.impl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ice.sparkhire.annotation.CustomCache;
import com.ice.sparkhire.cache.LocalCache;
import com.ice.sparkhire.constant.ErrorCode;
import com.ice.sparkhire.constant.cache.CacheConstant;
import com.ice.sparkhire.exception.BusinessException;
import com.ice.sparkhire.mapper.CareerTypeMapper;
import com.ice.sparkhire.mapper.IndustryMapper;
import com.ice.sparkhire.model.entity.Career;
import com.ice.sparkhire.model.entity.CareerType;
import com.ice.sparkhire.model.entity.Industry;
import com.ice.sparkhire.model.vo.CareerVO;
import com.ice.sparkhire.service.CareerService;
import com.ice.sparkhire.mapper.CareerMapper;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * @author chenjiahan
 * @description 针对表【career(职业)】的数据库操作Service实现
 * @createDate 2025-07-07 20:21:25
 */
@Service
@Slf4j
public class CareerServiceImpl extends ServiceImpl<CareerMapper, Career>
        implements CareerService {

    @Resource
    private CareerTypeMapper careerTypeMapper;

    @Resource
    private IndustryMapper industryMapper;

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

    @Override
    public void checkCareerAndIndustryExist(long careerId, long industryId) {
        if (careerId <= 0 || industryId <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "职业 id 或 行业 id 错误!");
        }
        // 1. 校验职业是否存在
        boolean careerExisted = baseMapper.exists(Wrappers.<Career>lambdaQuery()
                .eq(Career::getId, careerId));
        boolean exists = industryMapper.exists(Wrappers.<Industry>lambdaQuery()
                .eq(Industry::getId, industryId));

        if (careerExisted && exists) {
            return;
        }

        throw new BusinessException(ErrorCode.NOT_FOUND_ERROR, "职业或行业不存在");
    }

    @Override
    public void refreshCareerMapCache() {
        // todo 分布式事务改造
        List<Career> careerList = baseMapper.selectList(null);
        Map<Long, Career> careerMap = careerList.stream()
                .collect(Collectors.toMap(Career::getId, Function.identity()));
        LocalCache.setCareerMap(careerMap);
        log.info("refresh career map cache");
    }
}
