package com.ice.sparkhire.controller;

import com.ice.sparkhire.auth.IgnoreAuth;
import com.ice.sparkhire.common.BaseResponse;
import com.ice.sparkhire.common.ResultUtils;
import com.ice.sparkhire.model.vo.SchoolVO;
import com.ice.sparkhire.service.SchoolService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/7/6 15:51
 */
@RestController
@RequestMapping("/information/school")
public class SchoolController {

    @Resource
    private SchoolService schoolService;

    /**
     * 获取学校列表
     *
     * @return 学校列表
     */
    @GetMapping("/list")
    @IgnoreAuth
    public BaseResponse<List<SchoolVO>> getSchoolList() {
        return ResultUtils.success(schoolService.getSchoolList());
    }
}
