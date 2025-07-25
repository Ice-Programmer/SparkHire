package com.ice.sparkhire.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ice.sparkhire.annotation.CustomCache;
import com.ice.sparkhire.cache.LocalCache;
import com.ice.sparkhire.constant.cache.CacheConstant;
import com.ice.sparkhire.manager.RedisManager;
import com.ice.sparkhire.model.entity.Major;
import com.ice.sparkhire.model.vo.MajorVO;
import com.ice.sparkhire.service.MajorService;
import com.ice.sparkhire.mapper.MajorMapper;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * @author chenjiahan
 * @description 针对表【major(专业)】的数据库操作Service实现
 * @createDate 2025-07-06 16:13:53
 */
@Service
public class MajorServiceImpl extends ServiceImpl<MajorMapper, Major>
        implements MajorService {

    @Override
    @CustomCache(key = CacheConstant.MAJOR_LIST_KEY, duration = CacheConstant.MONTH_EXPIRE_TIME)
    public List<MajorVO> getMajorList() {
        return baseMapper.selectMajorList();
    }

    @Override
    public void refreshMajorMapCache() {
        List<Major> majorList = baseMapper.selectList(null);
        Map<Long, Major> majorMap = majorList.stream()
                .collect(Collectors.toMap(Major::getId, Function.identity()));
        LocalCache.setMajorMap(majorMap);
    }
}




