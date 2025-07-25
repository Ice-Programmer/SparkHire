package com.ice.sparkhire.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ice.sparkhire.annotation.CustomCache;
import com.ice.sparkhire.cache.LocalCache;
import com.ice.sparkhire.constant.cache.CacheConstant;
import com.ice.sparkhire.mapper.IndustryTypeMapper;
import com.ice.sparkhire.model.entity.Industry;
import com.ice.sparkhire.model.entity.IndustryType;
import com.ice.sparkhire.model.vo.IndustryVO;
import com.ice.sparkhire.service.IndustryService;
import com.ice.sparkhire.mapper.IndustryMapper;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * @author chenjiahan
 * @description 针对表【industry(行业)】的数据库操作Service实现
 * @createDate 2025-07-07 19:58:24
 */
@Service
@Slf4j
public class IndustryServiceImpl extends ServiceImpl<IndustryMapper, Industry>
        implements IndustryService {

    @Resource
    private IndustryTypeMapper industryTypeMapper;

    @Override
    @CustomCache(key = CacheConstant.INDUSTRY_LIST_KEY, duration = CacheConstant.MONTH_EXPIRE_TIME)
    public List<IndustryVO> getIndustryList() {
        // 获取所有行业列表
        List<IndustryType> industryTypeList = industryTypeMapper.selectList(null);

        // industryTypeId -> industryTypeName
        Map<Long, String> industryTypeMap = industryTypeList.stream()
                .collect(Collectors.toMap(IndustryType::getId, IndustryType::getIndustryTypeName));

        Map<Integer, List<Industry>> industryMap = baseMapper.selectList(null).stream()
                .collect(Collectors.groupingBy(Industry::getIndustryType));

        List<IndustryVO> industryVOList = new ArrayList<>();

        for (Integer industryType : industryMap.keySet()) {
            IndustryVO industryVO = new IndustryVO();
            industryVO.setIndustryType(industryTypeMap.get(industryType.longValue()));
            List<IndustryVO.IndustryDetail> industryDetailList =
                    industryMap.get(industryType).stream().map(IndustryVO::objToVO).toList();
            industryVO.setIndustryDetails(industryDetailList);
            industryVOList.add(industryVO);
        }

        return industryVOList;
    }

    @Override
    public void refreshIndustryMapCache() {
        List<Industry> industryList = baseMapper.selectList(null);
        Map<Long, Industry> industryMap = industryList.stream()
                .collect(Collectors.toMap(Industry::getId, Function.identity()));
        LocalCache.setIndustryMap(industryMap);
        log.info("refresh industry map...");
    }
}




