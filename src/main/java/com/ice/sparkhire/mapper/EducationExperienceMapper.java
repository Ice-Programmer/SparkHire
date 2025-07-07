package com.ice.sparkhire.mapper;

import com.ice.sparkhire.model.entity.EducationExperience;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ice.sparkhire.model.vo.EducationExperienceVO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * @author chenjiahan
 * @description 针对表【education_experience(教育经历)】的数据库操作Mapper
 * @createDate 2025-07-07 21:15:01
 * @Entity com.ice.sparkhire.model.entity.EducationExperience
 */
public interface EducationExperienceMapper extends BaseMapper<EducationExperience> {

    /**
     * 获取我的教育经历
     *
     * @param userId 用户 id
     * @return 我的教育经历
     */
    List<EducationExperienceVO> selectMyEducationExpInfo(@Param("userId") Long userId);
}




