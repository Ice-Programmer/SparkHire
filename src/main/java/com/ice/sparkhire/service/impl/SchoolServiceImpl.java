package com.ice.sparkhire.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ice.sparkhire.annotation.CustomCache;
import com.ice.sparkhire.constant.cache.CacheConstant;
import com.ice.sparkhire.model.entity.School;
import com.ice.sparkhire.model.vo.SchoolVO;
import com.ice.sparkhire.service.SchoolService;
import com.ice.sparkhire.mapper.SchoolMapper;
import org.springframework.stereotype.Service;

import java.util.List;

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
}




