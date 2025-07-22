package com.ice.sparkhire.service.impl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ice.sparkhire.auth.UserBasicInfo;
import com.ice.sparkhire.cache.LocalCache;
import com.ice.sparkhire.constant.CommonConstant;
import com.ice.sparkhire.constant.ErrorCode;
import com.ice.sparkhire.exception.BusinessException;
import com.ice.sparkhire.exception.ThrowUtils;
import com.ice.sparkhire.model.dto.career.WishCareerAddRequest;
import com.ice.sparkhire.model.dto.career.WishCareerEditRequest;
import com.ice.sparkhire.model.entity.Career;
import com.ice.sparkhire.model.entity.EmployeeWishCareer;
import com.ice.sparkhire.model.entity.Industry;
import com.ice.sparkhire.model.vo.EmployeeWishCareerVO;
import com.ice.sparkhire.security.SecurityContext;
import com.ice.sparkhire.service.CareerService;
import com.ice.sparkhire.service.EmployeeWishCareerService;
import com.ice.sparkhire.mapper.EmployeeWishCareerMapper;
import com.ice.sparkhire.validator.ValidatorUtil;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;

/**
 * @author chenjiahan
 * @description 针对表【employee_wish_career(应聘者期望岗位)】的数据库操作Service实现
 * @createDate 2025-07-20 09:08:55
 */
@Service
@Slf4j
public class EmployeeWishCareerServiceImpl extends ServiceImpl<EmployeeWishCareerMapper, EmployeeWishCareer>
        implements EmployeeWishCareerService {

    @Resource
    private CareerService careerService;

    @Override
    public Long addWishCareer(WishCareerAddRequest wishCareerAddRequest) {
        // 获取当前登录用户
        UserBasicInfo currentUser = SecurityContext.getCurrentUser();

        Long careerId = wishCareerAddRequest.getCareerId();
        Long industryId = wishCareerAddRequest.getIndustryId();
        String salaryExpectation = wishCareerAddRequest.getSalaryExpectation();

        // 校验参数
        checkParams(careerId, industryId, salaryExpectation);

        // 判断当前是否已存在相同期望
        EmployeeWishCareer employeeWishCareer = new EmployeeWishCareer();
        try {
            employeeWishCareer.setUserId(currentUser.getId());
            employeeWishCareer.setCareerId(careerId);
            employeeWishCareer.setIndustryId(industryId);
            employeeWishCareer.setSalaryExpectation(salaryExpectation);
            baseMapper.insert(employeeWishCareer);
        } catch (DuplicateKeyException exception) {
            throw new BusinessException(ErrorCode.OPERATION_ERROR, "已存在相同期望岗位");
        }

        log.info("user 「{}」add new wish career: {}", currentUser, employeeWishCareer);

        return employeeWishCareer.getId();
    }

    @Override
    public Boolean editWishCareer(WishCareerEditRequest wishCareerEditRequest) {
        // 获取当前登录用户
        UserBasicInfo currentUser = SecurityContext.getCurrentUser();

        Long id = wishCareerEditRequest.getId();
        Long careerId = wishCareerEditRequest.getCareerId();
        Long industryId = wishCareerEditRequest.getIndustryId();
        String salaryExpectation = wishCareerEditRequest.getSalaryExpectation();

        // 判断是否存在
        EmployeeWishCareer oldWishCareer = baseMapper.selectOne(Wrappers.<EmployeeWishCareer>lambdaQuery()
                .eq(EmployeeWishCareer::getId, id));

        ThrowUtils.throwIf(ObjectUtils.isEmpty(oldWishCareer), ErrorCode.NOT_FOUND_ERROR, "数据不存在！");
        if (!Objects.equals(oldWishCareer.getUserId(), currentUser.getId())) {
            throw new BusinessException(ErrorCode.OPERATION_ERROR, "仅能操作本人数据！");
        }

        // 校验参数
        checkParams(careerId, industryId, salaryExpectation);

        // 更新数据
        BeanUtils.copyProperties(wishCareerEditRequest, oldWishCareer);
        try {
            baseMapper.updateById(oldWishCareer);
        } catch (Exception exception) {
            log.error(exception.getMessage());
            throw new BusinessException(ErrorCode.OPERATION_ERROR, "更新数据失败! " + exception.getMessage());
        }

        return true;
    }

    @Override
    public List<EmployeeWishCareerVO> getWishCareerVOListByUserId(Long userId) {
        // 获取基础信息
        List<EmployeeWishCareer> wishCareerList = baseMapper.selectList(Wrappers.<EmployeeWishCareer>lambdaQuery()
                .eq(EmployeeWishCareer::getUserId, userId));

        // 获取扩展信息
        Map<Long, Industry> industryMap = LocalCache.getIndustryMap();
        Map<Long, Career> careerMap = LocalCache.getCareerMap();

        return wishCareerList.stream().map((wishCareer) -> {
            EmployeeWishCareerVO wishCareerVO = new EmployeeWishCareerVO();
            BeanUtils.copyProperties(wishCareer, wishCareerVO);
            // NPE!!!
            String careerName = Optional.ofNullable(careerMap.get(wishCareer.getCareerId()))
                    .map(Career::getCareerName)
                    .orElse(CommonConstant.UNKNOWN);
            wishCareerVO.setCareerName(careerName);
            String industryName = Optional.of(industryMap.get(wishCareer.getIndustryId()))
                    .map(Industry::getIndustryName)
                    .orElse(CommonConstant.UNKNOWN);
            wishCareerVO.setIndustryName(industryName);
            return wishCareerVO;
        }).toList();
    }

    /**
     * 校验参数
     *
     * @param careerId          职业 id
     * @param industryId        行业 id
     * @param salaryExpectation 期望薪资
     */
    private void checkParams(long careerId, long industryId, String salaryExpectation) {
        // 1. 校验行业和职业
        careerService.checkCareerAndIndustryExist(careerId, industryId);

        // 2. 校验期望薪资
        if (!ValidatorUtil.isValidSalaryExpectation(salaryExpectation)) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "期望薪资格式错误");
        }
        String[] salaryArray = salaryExpectation.split("-");

        String minSalaryStr = salaryArray.length > 0 ? salaryArray[0].trim() : null;
        String maxSalaryStr = salaryArray.length > 1 ? salaryArray[1].trim() : null;

        Integer minSalary = StringUtils.isNumeric(minSalaryStr) ? Integer.parseInt(minSalaryStr) : null;
        Integer maxSalary = StringUtils.isNumeric(maxSalaryStr) ? Integer.parseInt(maxSalaryStr) : null;

        if (minSalary != null && minSalary < 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "最小期望薪资不能为负！");
        }
        if (maxSalary != null && maxSalary < 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "最大期望薪资不能为负！");
        }
        if (minSalary != null && maxSalary != null && minSalary > maxSalary) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "最小薪资应小于最大薪资！");
        }
    }


}