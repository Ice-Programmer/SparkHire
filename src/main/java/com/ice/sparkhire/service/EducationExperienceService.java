package com.ice.sparkhire.service;

import com.ice.sparkhire.model.dto.education.EducationExpAddRequest;
import com.ice.sparkhire.model.dto.education.EducationExpEditRequest;
import com.ice.sparkhire.model.entity.EducationExperience;
import com.baomidou.mybatisplus.extension.service.IService;
import com.ice.sparkhire.model.vo.EducationExperienceVO;

import java.util.List;

/**
 * @author chenjiahan
 * @description 针对表【education_experience(教育经历)】的数据库操作Service
 * @createDate 2025-07-07 21:15:01
 */
public interface EducationExperienceService extends IService<EducationExperience> {

    /**
     * 新增教育经历
     *
     * @param educationExpAddRequest 教育经历请求
     * @return 教育经历 id
     */
    Long addEducationExp(EducationExpAddRequest educationExpAddRequest);

    /**
     * 编辑教育经历
     *
     * @param educationExpEditRequest 教育经历请求
     * @return 编辑成功
     */
    boolean editEducationExp(EducationExpEditRequest educationExpEditRequest);

    /**
     * 删除教育经历
     *
     * @param educationExpId 教育经历 id
     * @return 删除成功
     */
    boolean deleteEducationExp(Long educationExpId);

    /**
     * 获取我的教育经历
     *
     * @return 教育经历
     */
    List<EducationExperienceVO> getMyEducationExpVOList();
}
