package com.ice.sparkhire.controller;

import com.ice.sparkhire.annotation.MustRole;
import com.ice.sparkhire.common.BaseResponse;
import com.ice.sparkhire.common.ResultUtils;
import com.ice.sparkhire.constant.ErrorCode;
import com.ice.sparkhire.exception.BusinessException;
import com.ice.sparkhire.model.dto.company.CompanyAddRequest;
import com.ice.sparkhire.model.enums.UserRoleEnum;
import com.ice.sparkhire.service.CompanyService;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/12/13 16:26
 */
@RestController
@RequestMapping("/company")
@Slf4j
public class CompanyController {

    @Resource
    private CompanyService companyService;

    /**
     * 新增公司
     *
     * @param companyAddRequest 新增公司请求
     * @return 公司 id
     */
    @PostMapping("/add")
//    @MustRole(value = {UserRoleEnum.EMPLOYER, UserRoleEnum.EMPLOYER}, logical = MustRole.Logical.OR)
    public BaseResponse<Long> addCompany(@RequestBody @Valid CompanyAddRequest companyAddRequest) {
        if (companyAddRequest == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }

        long companyId = companyService.addCompany(companyAddRequest);

        return ResultUtils.success(companyId);
    }
}
