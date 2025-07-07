package com.ice.sparkhire.controller;

import com.ice.sparkhire.annotation.MustRole;
import com.ice.sparkhire.common.BaseResponse;
import com.ice.sparkhire.common.ResultUtils;
import com.ice.sparkhire.constant.ErrorCode;
import com.ice.sparkhire.exception.BusinessException;
import com.ice.sparkhire.model.dto.employee.EmployeeAddRequest;
import com.ice.sparkhire.model.dto.employee.EmployeeEditRequest;
import com.ice.sparkhire.model.enums.UserRoleEnum;
import com.ice.sparkhire.service.EmployeeService;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 求职者相关接口
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/7/6 20:31
 */
@RestController
@RequestMapping("/user/employee")
public class EmployeeController {

    @Resource
    private EmployeeService employeeService;

    /**
     * 新增求职者信息
     *
     * @param employeeAddRequest 求职者信息
     * @return 求职者 id
     */
    @PostMapping("/add")
    @MustRole(UserRoleEnum.EMPLOYEE)
    public BaseResponse<Long> addEmployee(@RequestBody @Valid EmployeeAddRequest employeeAddRequest) {
        if (employeeAddRequest == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }

        long employeeId = employeeService.addEmployee(employeeAddRequest);

        return ResultUtils.success(employeeId);
    }

    /**
     * 修改求职者信息
     *
     * @param employeeEditRequest 求职者信息
     * @return 求职者 id
     */
    @PostMapping("/edit")
    @MustRole(UserRoleEnum.EMPLOYEE)
    public BaseResponse<Boolean> editEmployee(@RequestBody @Valid EmployeeEditRequest employeeEditRequest) {
        if (employeeEditRequest == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }

        boolean result = employeeService.editEmployee(employeeEditRequest);

        return ResultUtils.success(result);
    }
}
