package com.ice.sparkhire.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ice.sparkhire.annotation.CustomCache;
import com.ice.sparkhire.cache.LocalCache;
import com.ice.sparkhire.cache.constant.CacheConstant;
import com.ice.sparkhire.model.entity.Qualification;
import com.ice.sparkhire.model.enums.QualificationEnum;
import com.ice.sparkhire.model.vo.QualificationVO;
import com.ice.sparkhire.service.QualificationService;
import com.ice.sparkhire.mapper.QualificationMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * @author chenjiahan
 * @description 针对表【qualification(资格证书)】的数据库操作Service实现
 * @createDate 2025-07-07 14:19:50
 */
@Service
@Slf4j
public class QualificationServiceImpl extends ServiceImpl<QualificationMapper, Qualification>
        implements QualificationService {

    @Override
    @CustomCache(key = CacheConstant.QUALIFICATION_LIST_KEY, duration = CacheConstant.MONTH_EXPIRE_TIME)
    public List<QualificationVO> getQualificationList() {
        List<Qualification> qualificationList = this.list();

        // 根据 qualificationType 分类
        Map<Integer, List<Qualification>> groupedMap = qualificationList.stream()
                .collect(Collectors.groupingBy(Qualification::getQualificationType));

        List<QualificationVO> qualificationVOList = new ArrayList<>();

        // qualificationType -> qualificationName
        Map<Integer, String> QualificationTypeMap = Arrays.stream(QualificationEnum.values())
                .collect(Collectors.toMap(QualificationEnum::getValue, QualificationEnum::getText));

        // 根据证书类型分类列表
        for (Integer qualificationType : groupedMap.keySet()) {
            QualificationVO qualificationVO = new QualificationVO();
            qualificationVO.setQualificationType(QualificationTypeMap.get(qualificationType));
            List<QualificationVO.QualificationDetail> qualificationDetailList =
                    groupedMap.get(qualificationType).stream().map(QualificationVO::objToVO).toList();
            qualificationVO.setQualificationDetailList(qualificationDetailList);
            qualificationVOList.add(qualificationVO);
        }

        return qualificationVOList;
    }

    @Override
    public void refreshQualificationMapCache() {
        List<Qualification> qualificationList = baseMapper.selectList(null);
        Map<Long, Qualification> qualificationMap = qualificationList.stream()
                .collect(Collectors.toMap(Qualification::getId, Function.identity()));
        LocalCache.setQualificationMap(qualificationMap);
        log.info("refresh industry map...");
    }
}




