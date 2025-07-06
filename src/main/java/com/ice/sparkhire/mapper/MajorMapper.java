package com.ice.sparkhire.mapper;

import com.ice.sparkhire.model.entity.Major;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ice.sparkhire.model.vo.MajorVO;

import java.util.List;

/**
 * @author chenjiahan
 * @description 针对表【major(专业)】的数据库操作Mapper
 * @createDate 2025-07-06 16:13:53
 * @Entity com.ice.sparkhire.model.entity.Major
 */
public interface MajorMapper extends BaseMapper<Major> {

    /**
     * 获取专业列表
     *
     * @return 专业列表
     */
    List<MajorVO> selectMajorList();
}




