package com.ice.sparkhire.controller;

import com.ice.sparkhire.annotation.MustRole;
import com.ice.sparkhire.auth.vo.UserBasicInfo;
import com.ice.sparkhire.common.BaseResponse;
import com.ice.sparkhire.common.DeleteRequest;
import com.ice.sparkhire.common.ResultUtils;
import com.ice.sparkhire.constant.ErrorCode;
import com.ice.sparkhire.exception.BusinessException;
import com.ice.sparkhire.model.dto.career.WishCareerAddRequest;
import com.ice.sparkhire.model.dto.career.WishCareerEditRequest;
import com.ice.sparkhire.model.enums.UserRoleEnum;
import com.ice.sparkhire.model.vo.EmployeeWishCareerVO;
import com.ice.sparkhire.security.SecurityContext;
import com.ice.sparkhire.service.EmployeeWishCareerService;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

import java.util.List;

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
    @MustRole(UserRoleEnum.EMPLOYEE)
    public BaseResponse<Long> addWishCareer(@RequestBody WishCareerAddRequest wishCareerAddRequest) {
        if (wishCareerAddRequest == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }

        return ResultUtils.success(employeeWishCareerService.addWishCareer(wishCareerAddRequest));
    }

    /**
     * 编辑期望职业
     *
     * @param wishCareerEditRequest 编辑期望职业
     * @return 编辑成功
     */
    @PostMapping("/edit")
    @MustRole(UserRoleEnum.EMPLOYEE)
    public BaseResponse<Boolean> updateWishCareer(@RequestBody WishCareerEditRequest wishCareerEditRequest) {
        if (wishCareerEditRequest == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        Long wishCareerId = wishCareerEditRequest.getId();
        if (wishCareerId == null || wishCareerId <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }

        return ResultUtils.success(employeeWishCareerService.editWishCareer(wishCareerEditRequest));
    }

    /**
     * 获取我的期望职业列表
     *
     * @return 我的期望职业列表
     */
    @GetMapping("/list/my")
    @MustRole(UserRoleEnum.EMPLOYEE)
    public BaseResponse<List<EmployeeWishCareerVO>> getMyWishCareerList() {
        // 获取当前登录用户
        UserBasicInfo currentUser = SecurityContext.getCurrentUser();
        return ResultUtils.success(employeeWishCareerService.getWishCareerVOListByUserId(currentUser.getId()));
    }

    /**
     * 删除期望职业
     *
     * @param deleteRequest 删除请求
     * @return 删除成功
     */
    @PostMapping("/delete")
    @MustRole(UserRoleEnum.EMPLOYEE)
    public BaseResponse<Boolean> deleteWishCareer(@RequestBody @Valid DeleteRequest deleteRequest) {
        return ResultUtils.success(employeeWishCareerService.deleteWishCareer(deleteRequest.getId()));
    }
}
