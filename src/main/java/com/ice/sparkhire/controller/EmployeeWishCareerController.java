package com.ice.sparkhire.controller;

import com.ice.sparkhire.common.BaseResponse;
import com.ice.sparkhire.common.ResultUtils;
import com.ice.sparkhire.constant.ErrorCode;
import com.ice.sparkhire.exception.BusinessException;
import com.ice.sparkhire.model.dto.career.WishCareerAddRequest;
import com.ice.sparkhire.service.EmployeeWishCareerService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/7/20 09:10
 */
@RestController
@RequestMapping("/user/employee/career/wish")
public class EmployeeWishCareerController {

    @Resource
    private EmployeeWishCareerService employeeWishCareerService;

    /**
     * 添加期望职业
     *
     * @param wishCareerAddRequest 添加职业请求
     * @return 期望职业 id
     */
    @PostMapping("/add")
    public BaseResponse<Long> addWishCareer(@RequestBody WishCareerAddRequest wishCareerAddRequest) {
        if (wishCareerAddRequest == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }

        return ResultUtils.success(employeeWishCareerService.addWishCareer(wishCareerAddRequest));
    }
}
