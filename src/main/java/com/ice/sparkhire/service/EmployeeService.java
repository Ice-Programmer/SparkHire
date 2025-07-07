package com.ice.sparkhire.service;

import com.ice.sparkhire.model.dto.employee.EmployeeAddRequest;
import com.ice.sparkhire.model.dto.employee.EmployeeEditRequest;
import com.ice.sparkhire.model.entity.Employee;
import com.baomidou.mybatisplus.extension.service.IService;
import jakarta.validation.Valid;

/**
 * @author chenjiahan
 * @description 针对表【employee(求职者)】的数据库操作Service
 * @createDate 2025-07-06 20:42:14
 */
public interface EmployeeService extends IService<Employee> {

    /**
     * 新增求职者信息
     *
     * @param employeeAddRequest 求职者信息
     * @return 求职者 id
     */
    long addEmployee(EmployeeAddRequest employeeAddRequest);

    /**
     * 修改求职者信息
     *
     * @param employeeEditRequest 求职者信息
     * @return id
     */
    boolean editEmployee(EmployeeEditRequest employeeEditRequest);
}
