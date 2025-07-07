package com.ice.sparkhire.controller;

import com.ice.sparkhire.auth.IgnoreAuth;
import com.ice.sparkhire.common.BaseResponse;
import com.ice.sparkhire.common.ResultUtils;
import com.ice.sparkhire.model.vo.*;
import com.ice.sparkhire.service.*;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 获取相关信息接口
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/7/6 16:11
 */
@RestController
@RequestMapping("/information")
public class InformationController {

    @Resource
    private SchoolService schoolService;

    @Resource
    private MajorService majorService;

    @Resource
    private QualificationService qualificationService;

    @Resource
    private IndustryService industryService;

    @Resource
    private CareerService careerService;

    /**
     * 获取学校列表
     *
     * @return 学校列表
     */
    @GetMapping("/school/list")
    @IgnoreAuth
    public BaseResponse<List<SchoolVO>> getSchoolList() {
        return ResultUtils.success(schoolService.getSchoolList());
    }

    /**
     * 获取专业列表
     *
     * @return 专业列表
     */
    @GetMapping("/major/list")
    @IgnoreAuth
    public BaseResponse<List<MajorVO>> getMajorList() {
        return ResultUtils.success(majorService.getMajorList());
    }

    /**
     * 获取证书列表
     *
     * @return 证书列表
     */
    @GetMapping("/qualification/list")
    @IgnoreAuth
    public BaseResponse<List<QualificationVO>> getQualificationList() {
        return ResultUtils.success(qualificationService.getQualificationList());
    }

    /**
     * 获取行业列表
     *
     * @return 行业列表
     */
    @GetMapping("/industry/list")
    @IgnoreAuth
    public BaseResponse<List<IndustryVO>> getIndustryList() {
        return ResultUtils.success(industryService.getIndustryList());
    }

    /**
     * 获取职业列表
     *
     * @return 职业列表
     */
    @GetMapping("/career/list")
    @IgnoreAuth
    public BaseResponse<List<CareerVO>> getCareerList() {
        return ResultUtils.success(careerService.getCareerList());
    }
}
