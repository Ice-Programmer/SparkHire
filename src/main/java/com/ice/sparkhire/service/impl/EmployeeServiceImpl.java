package com.ice.sparkhire.service.impl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.ice.sparkhire.auth.vo.UserBasicInfo;
import com.ice.sparkhire.cache.LocalCache;
import com.ice.sparkhire.constant.CommonConstant;
import com.ice.sparkhire.constant.ErrorCode;
import com.ice.sparkhire.exception.BusinessException;
import com.ice.sparkhire.exception.ThrowUtils;
import com.ice.sparkhire.mapper.CityMapper;
import com.ice.sparkhire.mapper.EmployeeMapper;
import com.ice.sparkhire.mapper.EmployeeWishCareerMapper;
import com.ice.sparkhire.mapper.QualificationMapper;
import com.ice.sparkhire.model.dto.employee.EmployeeAddRequest;
import com.ice.sparkhire.model.dto.employee.EmployeeEditRequest;
import com.ice.sparkhire.model.entity.*;
import com.ice.sparkhire.model.vo.EmployeeVO;
import com.ice.sparkhire.model.vo.EmployeeWishCareerVO;
import com.ice.sparkhire.model.vo.QualificationVO;
import com.ice.sparkhire.security.SecurityContext;
import com.ice.sparkhire.service.EmployeeService;
import jakarta.annotation.Resource;
import org.apache.commons.lang3.ObjectUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;

/**
 * @author chenjiahan
 * @description 针对表【employee(求职者)】的数据库操作Service实现
 * @createDate 2025-07-06 20:42:14
 */
@Service
public class EmployeeServiceImpl extends ServiceImpl<EmployeeMapper, Employee>
        implements EmployeeService {

    @Resource
    private CityMapper cityMapper;

    @Resource
    private EmployeeWishCareerMapper employeeWishCareerMapper;

    private final static Gson GSON = new Gson();

    @Override
    public long addEmployee(EmployeeAddRequest employeeAddRequest) {
        // 获取当前的登录用户
        UserBasicInfo currentUser = SecurityContext.getCurrentUser();

        // 校验参数
        checkParam(employeeAddRequest.getCityId(), employeeAddRequest.getQualifications());

        // 插入数据库
        Employee employee = new Employee();
        BeanUtils.copyProperties(employeeAddRequest, employee);
        employee.setUserId(currentUser.getId());
        employee.setSkillTags(GSON.toJson(employeeAddRequest.getSkillTags()));
        employee.setQualifications(GSON.toJson(employeeAddRequest.getQualifications()));

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

        // 判断参数
        checkParam(employeeEditRequest.getCityId(), employeeEditRequest.getQualifications());

        // 判断当前数据是否存在
        Employee employee = baseMapper.selectOne(Wrappers.<Employee>lambdaQuery()
                .eq(Employee::getId, employeeEditRequest.getId()));
        ThrowUtils.throwIf(ObjectUtils.isEmpty(employee), ErrorCode.NOT_FOUND_ERROR, "信息不存在");
        ThrowUtils.throwIf(!Objects.equals(employee.getUserId(), currentUser.getId()),
                ErrorCode.NO_AUTH_ERROR, "仅能修改自己的信息");

        BeanUtils.copyProperties(employeeEditRequest, employee);
        employee.setSkillTags(GSON.toJson(employeeEditRequest.getSkillTags()));
        employee.setQualifications(GSON.toJson(employeeEditRequest.getQualifications()));

        baseMapper.updateById(employee);

        return true;
    }

    @Override
    public EmployeeVO getEmployeeVO(Long userId) {
        EmployeeVO employeeVO = new EmployeeVO();
        Employee employee = baseMapper.selectOne(Wrappers.<Employee>lambdaQuery()
                .eq(Employee::getUserId, userId));

        if (ObjectUtils.isEmpty(employee)) {
            employeeVO.setUserId(userId);
            return employeeVO;
        }
        BeanUtils.copyProperties(employee, employeeVO);

        // 获取证书列表
        String qualificationIdsStr = employee.getQualifications();
        List<Long> qualificationIdList = GSON.fromJson(qualificationIdsStr, new TypeToken<List<Long>>() {
        }.getType());
        Map<Long, Qualification> qualificationMap = LocalCache.getQualificationMap();
        List<EmployeeVO.EmployeeQualificationVO> qualificationVOList = qualificationIdList.stream().map(qualificationId -> {
            EmployeeVO.EmployeeQualificationVO qualificationVO = new EmployeeVO.EmployeeQualificationVO();
            qualificationVO.setId(qualificationId);
            String qualificationName = Optional.of(qualificationMap.get(qualificationId))
                    .map(Qualification::getQualificationName)
                    .orElse(CommonConstant.UNKNOWN);
            qualificationVO.setQualificationName(qualificationName);
            return qualificationVO;
        }).toList();
        employeeVO.setQualificationList(qualificationVOList);

        return employeeVO;
    }

    /**
     * 校验参数
     *
     * @param cityId         城市 id
     * @param qualifications 证书列表
     */
    private void checkParam(Long cityId, List<Long> qualifications) {
        // 1. 校验参数
        boolean exists = cityMapper.exists(Wrappers.<City>lambdaQuery()
                .eq(City::getId, cityId));
        ThrowUtils.throwIf(!exists, ErrorCode.NOT_FOUND_ERROR, "城市 id 不存在");

        // 2. 校验证书列表
        if (!qualifications.isEmpty()) {
            Map<Long, Qualification> qualificationMap = LocalCache.getQualificationMap();
            for (Long qualificationId : qualifications) {
                if (!qualificationMap.containsKey(qualificationId)) {
                    throw new BusinessException(ErrorCode.PARAMS_ERROR, String.format("%s 证书不存在", qualificationId));
                }
            }
        }
    }

}




