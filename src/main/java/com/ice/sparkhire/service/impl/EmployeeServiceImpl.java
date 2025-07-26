package com.ice.sparkhire.service.impl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.google.gson.Gson;
import com.ice.sparkhire.auth.UserBasicInfo;
import com.ice.sparkhire.auth.UserRoleConstant;
import com.ice.sparkhire.constant.ErrorCode;
import com.ice.sparkhire.exception.BusinessException;
import com.ice.sparkhire.exception.ThrowUtils;
import com.ice.sparkhire.mapper.EmployeeMapper;
import com.ice.sparkhire.mapper.RoleMapper;
import com.ice.sparkhire.mapper.UserRoleMapper;
import com.ice.sparkhire.model.dto.employee.EmployeeAddRequest;
import com.ice.sparkhire.model.dto.employee.EmployeeEditRequest;
import com.ice.sparkhire.model.entity.Employee;
import com.ice.sparkhire.security.SecurityContext;
import com.ice.sparkhire.service.CityService;
import com.ice.sparkhire.service.EmployeeService;
import jakarta.annotation.Resource;
import org.apache.commons.lang3.ObjectUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.support.TransactionTemplate;

import java.util.Objects;

/**
 * @author chenjiahan
 * @description 针对表【employee(求职者)】的数据库操作Service实现
 * @createDate 2025-07-06 20:42:14
 */
@Service
public class EmployeeServiceImpl extends ServiceImpl<EmployeeMapper, Employee>
        implements EmployeeService {

    @Resource
    private CityService cityService;

    private final static Gson GSON = new Gson();

    @Override
    public long addEmployee(EmployeeAddRequest employeeAddRequest) {
        // 获取当前的登录用户
        UserBasicInfo currentUser = SecurityContext.getCurrentUser();

        // 判断城市 id 是否正确
        cityService.existCity(employeeAddRequest.getCityId());

        // 插入数据库
        Employee employee = new Employee();
        BeanUtils.copyProperties(employeeAddRequest, employee);
        employee.setUserId(currentUser.getId());
        employee.setSkillTags(GSON.toJson(employeeAddRequest.getSkillTags()));

        try {
            baseMapper.insert(employee);
        } catch (DuplicateKeyException e) {
            throw new BusinessException(ErrorCode.OPERATION_ERROR, "请勿重复创建招聘者简历信息");
        }
        return employee.getId();
    }

    @Override
    public boolean editEmployee(EmployeeEditRequest employeeEditRequest) {
        // 获取当前的登录用户
        UserBasicInfo currentUser = SecurityContext.getCurrentUser();

        // 判断当前数据是否存在
        Employee employee = baseMapper.selectOne(Wrappers.<Employee>lambdaQuery()
                .eq(Employee::getId, employeeEditRequest.getId()));
        ThrowUtils.throwIf(ObjectUtils.isEmpty(employee), ErrorCode.NOT_FOUND_ERROR, "信息不存在");
        ThrowUtils.throwIf(!Objects.equals(employee.getUserId(), currentUser.getId()),
                ErrorCode.NO_AUTH_ERROR, "仅能修改自己的信息");

        // 判断城市 id 是否正确
        cityService.existCity(employeeEditRequest.getCityId());

        BeanUtils.copyProperties(employeeEditRequest, employee);
        employee.setSkillTags(GSON.toJson(employeeEditRequest.getSkillTags()));

        baseMapper.updateById(employee);

        return true;
    }
}




