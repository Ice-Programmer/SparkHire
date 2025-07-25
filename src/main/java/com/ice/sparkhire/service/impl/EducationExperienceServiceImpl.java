package com.ice.sparkhire.service.impl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ice.sparkhire.auth.UserBasicInfo;
import com.ice.sparkhire.cache.LocalCache;
import com.ice.sparkhire.constant.CommonConstant;
import com.ice.sparkhire.constant.ErrorCode;
import com.ice.sparkhire.exception.BusinessException;
import com.ice.sparkhire.exception.ThrowUtils;
import com.ice.sparkhire.model.dto.education.EducationExpAddRequest;
import com.ice.sparkhire.model.dto.education.EducationExpEditRequest;
import com.ice.sparkhire.model.entity.EducationExperience;
import com.ice.sparkhire.model.entity.Major;
import com.ice.sparkhire.model.entity.School;
import com.ice.sparkhire.model.vo.EducationExperienceVO;
import com.ice.sparkhire.security.SecurityContext;
import com.ice.sparkhire.service.EducationExperienceService;
import com.ice.sparkhire.mapper.EducationExperienceMapper;
import com.ice.sparkhire.validator.ValidatorUtil;
import org.springframework.beans.BeanUtils;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * @author chenjiahan
 * @description 针对表【education_experience(教育经历)】的数据库操作Service实现
 * @createDate 2025-07-07 21:15:01
 */
@Service
public class EducationExperienceServiceImpl extends ServiceImpl<EducationExperienceMapper, EducationExperience>
        implements EducationExperienceService {

    @Override
    public Long addEducationExp(EducationExpAddRequest educationExpAddRequest) {
        // 当前登录用户
        UserBasicInfo currentUser = SecurityContext.getCurrentUser();

        // 校验年份
        ValidatorUtil.checkYearRange(educationExpAddRequest.getBeginYear(), educationExpAddRequest.getEndYear());

        EducationExperience educationExperience = new EducationExperience();
        BeanUtils.copyProperties(educationExpAddRequest, educationExperience);
        educationExperience.setUserId(currentUser.getId());
        try {
            baseMapper.insert(educationExperience);
        } catch (DuplicateKeyException e) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "教育经历不能重复！");
        }

        return educationExperience.getId();
    }

    @Override
    public boolean editEducationExp(EducationExpEditRequest educationExpEditRequest) {
        // 当前登录用户
        UserBasicInfo currentUser = SecurityContext.getCurrentUser();

        // 校验年份
        ValidatorUtil.checkYearRange(educationExpEditRequest.getBeginYear(), educationExpEditRequest.getEndYear());

        // 查询数据
        EducationExperience educationExperience = baseMapper.selectOne(Wrappers.<EducationExperience>lambdaQuery()
                .eq(EducationExperience::getId, educationExpEditRequest.getId())
                .eq(EducationExperience::getUserId, currentUser.getId()));
        ThrowUtils.throwIf(educationExperience == null, ErrorCode.NOT_FOUND_ERROR, "教学经历不存在！");
        BeanUtils.copyProperties(educationExpEditRequest, educationExperience);

        try {
            baseMapper.updateById(educationExperience);
        } catch (DuplicateKeyException e) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "教育经历不能重复！");
        }

        return true;
    }

    @Override
    public boolean deleteEducationExp(Long educationExpId) {
        UserBasicInfo currentUser = SecurityContext.getCurrentUser();

        EducationExperience educationExperience = baseMapper.selectOne(Wrappers.<EducationExperience>lambdaQuery()
                .eq(EducationExperience::getId, educationExpId)
                .select(EducationExperience::getId, EducationExperience::getUserId));

        if (educationExperience == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "教育经历不存在");
        }

        if (!educationExperience.getUserId().equals(currentUser.getId())) {
            throw new BusinessException(ErrorCode.NO_AUTH_ERROR, "仅能删除自己的教育经历");
        }

        baseMapper.deleteById(educationExpId);
        return true;
    }

    @Override
    public List<EducationExperienceVO> getEducationExpVOListByUserId(Long userId) {
        // 当前登录用户
        List<EducationExperience> experienceList = baseMapper.selectList(Wrappers.<EducationExperience>lambdaQuery()
                .eq(EducationExperience::getUserId, userId));

        Map<Long, School> schoolMap = LocalCache.getSchoolMap();
        Map<Long, Major> majorMap = LocalCache.getMajorMap();

        return experienceList.stream().map(experience -> {
            EducationExperienceVO educationExperienceVO = new EducationExperienceVO();
            BeanUtils.copyProperties(experience, educationExperienceVO);
            // 专业信息
            String majorName = Optional.of(majorMap.get(experience.getMajorId()))
                    .map(Major::getMajorName)
                    .orElse(CommonConstant.UNKNOWN);
            educationExperienceVO.setMajorName(majorName);
            // 学校信息
            String schoolName = Optional.of(schoolMap.get(experience.getSchoolId()))
                    .map(School::getSchoolName)
                    .orElse(CommonConstant.UNKNOWN);
            educationExperienceVO.setSchoolName(schoolName);
            return educationExperienceVO;
        }).toList();
    }
}
