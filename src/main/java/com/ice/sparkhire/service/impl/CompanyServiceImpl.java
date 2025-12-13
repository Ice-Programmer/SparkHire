package com.ice.sparkhire.service.impl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.ice.sparkhire.constant.ErrorCode;
import com.ice.sparkhire.exception.BusinessException;
import com.ice.sparkhire.exception.ThrowUtils;
import com.ice.sparkhire.mapper.CityMapper;
import com.ice.sparkhire.mapper.IndustryMapper;
import com.ice.sparkhire.model.dto.company.CompanyAddRequest;
import com.ice.sparkhire.model.entity.City;
import com.ice.sparkhire.model.entity.Company;
import com.ice.sparkhire.model.entity.Industry;
import com.ice.sparkhire.model.vo.CompanyVO;
import com.ice.sparkhire.security.SecurityContext;
import com.ice.sparkhire.service.CompanyService;
import com.ice.sparkhire.mapper.CompanyMapper;
import jakarta.annotation.Resource;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import java.util.List;

/**
 * @author chenjiahan
 * @description 针对表【company(公司信息)】的数据库操作Service实现
 * @createDate 2025-12-13 16:27:23
 */
@Service
public class CompanyServiceImpl extends ServiceImpl<CompanyMapper, Company>
        implements CompanyService {

    private final static Gson GSON = new Gson();

    @Resource
    private IndustryMapper industryMapper;

    @Resource
    private CityMapper cityMapper;

    @Override
    public long addCompany(CompanyAddRequest companyAddRequest) {
        Company company = new Company();
        BeanUtils.copyProperties(companyAddRequest, company);

        // 1. check param
        checkCompany(company);

        // 2. save company
        int result = baseMapper.insert(company);
        ThrowUtils.throwIf(result == 0, ErrorCode.OPERATION_ERROR, "公司新增失败，请重试！");

        return company.getId();
    }

    @Override
    public CompanyVO getCompanyVO(Long companyId) {
        Company company = baseMapper.selectById(companyId);
        ThrowUtils.throwIf(ObjectUtils.isEmpty(company), ErrorCode.NOT_FOUND_ERROR);

        City city = cityMapper.selectOne(Wrappers.<City>lambdaQuery()
                .select(City::getCityName)
                .eq(City::getId, company.getCityId()));

        Industry industry = industryMapper.selectOne(Wrappers.<Industry>lambdaQuery()
                .select(Industry::getIndustryName)
                .eq(Industry::getId, company.getIndustryId()));

        CompanyVO companyVO = new CompanyVO();
        BeanUtils.copyProperties(company, companyVO);

        companyVO.setCityName(city.getCityName());
        companyVO.setIndustryName(industry.getIndustryName());
        List<String> companyImageList = GSON.fromJson(company.getCompanyImages(), new TypeToken<List<String>>() {
        }.getType());
        companyVO.setCompanyImageList(companyImageList);

        return companyVO;
    }

    /**
     * 校验公司参数
     *
     * @param company 公司信息
     */
    private void checkCompany(Company company) {
        // check company name
        boolean companyExist = baseMapper.exists(Wrappers.<Company>lambdaQuery()
                .eq(Company::getCompanyName, company.getCompanyName()));
        if (companyExist) {
            throw new BusinessException(ErrorCode.OPERATION_ERROR, "公司名称已存在！");
        }

        // check industry id
        boolean industryExist = industryMapper.exists(Wrappers.<Industry>lambdaQuery()
                .eq(Industry::getId, company.getIndustryId()));

        if (!industryExist) {
            throw new BusinessException(ErrorCode.OPERATION_ERROR, "industry not exist");
        }
        boolean cityExist = cityMapper.exists(Wrappers.<City>lambdaQuery()
                .eq(City::getId, company.getCityId()));
        if (!cityExist) {
            throw new BusinessException(ErrorCode.OPERATION_ERROR, "city not exist");
        }
    }
}
