package com.ice.sparkhire.controller;

import com.ice.sparkhire.auth.IgnoreAuth;
import com.ice.sparkhire.common.BaseResponse;
import com.ice.sparkhire.common.ResultUtils;
import com.ice.sparkhire.model.vo.MajorVO;
import com.ice.sparkhire.model.vo.SchoolVO;
import com.ice.sparkhire.service.MajorService;
import com.ice.sparkhire.service.SchoolService;
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

}
