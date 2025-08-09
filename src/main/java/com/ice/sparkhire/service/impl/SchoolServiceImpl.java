package com.ice.sparkhire.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ice.sparkhire.annotation.CustomCache;
import com.ice.sparkhire.cache.LocalCache;
import com.ice.sparkhire.cache.constant.CacheConstant;
import com.ice.sparkhire.model.entity.School;
import com.ice.sparkhire.model.vo.SchoolVO;
import com.ice.sparkhire.service.SchoolService;
import com.ice.sparkhire.mapper.SchoolMapper;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * @author chenjiahan
 * @description 针对表【school(学校)】的数据库操作Service实现
 * @createDate 2025-07-06 15:50:16
 */
@Service
public class SchoolServiceImpl extends ServiceImpl<SchoolMapper, School>
        implements SchoolService {

    @Override
    @CustomCache(key = CacheConstant.SCHOOL_LIST_KEY, duration = CacheConstant.MONTH_EXPIRE_TIME)
    public List<SchoolVO> getSchoolList() {
        return baseMapper.selectSchoolList();
    }

    @Override
    public void refreshSchoolMapCache() {
        List<School> schoolList = baseMapper.selectList(null);
        Map<Long, School> schoolMap = schoolList.stream()
                .collect(Collectors.toMap(School::getId, Function.identity()));
        LocalCache.setSchoolMap(schoolMap);
    }
}




