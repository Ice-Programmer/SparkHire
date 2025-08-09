package com.ice.sparkhire.controller;

import com.ice.sparkhire.annotation.MustRole;
import com.ice.sparkhire.auth.vo.UserBasicInfo;
import com.ice.sparkhire.common.BaseResponse;
import com.ice.sparkhire.common.DeleteRequest;
import com.ice.sparkhire.common.ResultUtils;
import com.ice.sparkhire.constant.ErrorCode;
import com.ice.sparkhire.exception.BusinessException;
import com.ice.sparkhire.model.dto.education.EducationExpAddRequest;
import com.ice.sparkhire.model.dto.education.EducationExpEditRequest;
import com.ice.sparkhire.model.enums.UserRoleEnum;
import com.ice.sparkhire.model.vo.EducationExperienceVO;
import com.ice.sparkhire.security.SecurityContext;
import com.ice.sparkhire.service.EducationExperienceService;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 教育经历相关接口
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/7/7 21:15
 */
@RestController
@RequestMapping("/user/employee/education/experience")
public class EducationExpController {

    @Resource
    private EducationExperienceService educationExperienceService;

    /**
     * 新增教育经历
     *
     * @param educationExpAddRequest 教育经历请求
     * @return 教育经历 id
     */
    @PostMapping("/add")
    @MustRole(UserRoleEnum.EMPLOYEE)
    public BaseResponse<Long> addEducationExp(@RequestBody @Valid EducationExpAddRequest educationExpAddRequest) {
        if (educationExpAddRequest == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }

        return ResultUtils.success(educationExperienceService.addEducationExp(educationExpAddRequest));
    }

    /**
     * 编辑教育经历
     *
     * @param editRequest 教育经历请求
     * @return 编辑成功
     */
    @PostMapping("/edit")
    @MustRole(UserRoleEnum.EMPLOYEE)
    public BaseResponse<Boolean> editEducationExp(@RequestBody @Valid EducationExpEditRequest editRequest) {
        if (editRequest == null || editRequest.getId() == null || editRequest.getId() <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }

        return ResultUtils.success(educationExperienceService.editEducationExp(editRequest));
    }

    /**
     * 删除教育经历
     *
     * @param deleteRequest 删除 id
     * @return 删除成功
     */
    @PostMapping("/delete")
    @MustRole(UserRoleEnum.EMPLOYEE)
    public BaseResponse<Boolean> deleteEducationExp(@RequestBody DeleteRequest deleteRequest) {
        if (deleteRequest == null || deleteRequest.getId() == null || deleteRequest.getId() <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }

        return ResultUtils.success(educationExperienceService.deleteEducationExp(deleteRequest.getId()));
    }

    /**
     * 获取教育经历
     *
     * @return 教育经历
     */
    @GetMapping("/my")
    @MustRole(UserRoleEnum.EMPLOYEE)
    public BaseResponse<List<EducationExperienceVO>> getMyEducationExpVOList() {
        // 当前登录用户
        UserBasicInfo currentUser = SecurityContext.getCurrentUser();
        return ResultUtils.success(educationExperienceService.getEducationExpVOListByUserId(currentUser.getId()));
    }

}
