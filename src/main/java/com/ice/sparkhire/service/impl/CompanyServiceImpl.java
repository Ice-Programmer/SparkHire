package com.ice.sparkhire.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.ice.sparkhire.auth.vo.UserBasicInfo;
import com.ice.sparkhire.constant.ErrorCode;
import com.ice.sparkhire.exception.BusinessException;
import com.ice.sparkhire.exception.ThrowUtils;
import com.ice.sparkhire.mapper.CityMapper;
import com.ice.sparkhire.mapper.IndustryMapper;
import com.ice.sparkhire.model.dto.company.CompanyAddRequest;
import com.ice.sparkhire.model.dto.company.CompanyEditRequest;
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
import java.util.Objects;

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
        checkCompany(company, false);

        if (!companyAddRequest.getCompanyImages().isEmpty()) {
            company.setCompanyImages(GSON.toJson(companyAddRequest.getCompanyImages()));
        }
        UserBasicInfo currentUser = SecurityContext.getCurrentUser();
        company.setCreateUserId(currentUser.getId());

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

    @Override
    public CompanyVO editCompany(CompanyEditRequest companyEditRequest) {
        Company oldCompany = baseMapper.selectOne(Wrappers.<Company>lambdaQuery()
                .select(Company::getCreateUserId)
                .eq(Company::getId, companyEditRequest.getId()));
        ThrowUtils.throwIf(ObjectUtils.isEmpty(oldCompany), ErrorCode.NOT_FOUND_ERROR, "修改的相关公司不存在");

        UserBasicInfo currentUser = SecurityContext.getCurrentUser();
        if (!Objects.equals(currentUser.getId(), oldCompany.getCreateUserId())) {
            throw new BusinessException(ErrorCode.OPERATION_ERROR, "仅有公司创建者可修改");
        }

        Company company = new Company();
        BeanUtils.copyProperties(companyEditRequest, company);
        checkCompany(company, true);

        if (!companyEditRequest.getCompanyImages().isEmpty()) {
            company.setCompanyImages(GSON.toJson(companyEditRequest.getCompanyImages()));
        }

        int result = baseMapper.updateById(company);
        ThrowUtils.throwIf(result == 0, ErrorCode.OPERATION_ERROR);

        return getCompanyVO(companyEditRequest.getId());
    }

    @Override
    public boolean deleteCompany(Long companyId) {
        Company company = baseMapper.selectOne(Wrappers.<Company>lambdaQuery()
                .eq(Company::getId, companyId));

        if (ObjectUtils.isEmpty(company)) {
            throw new BusinessException(ErrorCode.NOT_FOUND_ERROR, "公司信息不存在！");
        }

        UserBasicInfo currentUser = SecurityContext.getCurrentUser();
        if (!Objects.equals(company.getCreateUserId(), currentUser.getId())) {
            throw new BusinessException(ErrorCode.OPERATION_ERROR, "仅有公司创建者可删除！");
        }

        boolean result = baseMapper.deleteById(companyId) != 0;
        if (!result) {
            throw new BusinessException(ErrorCode.OPERATION_ERROR, "删除失败！");
        }
        return true;
    }

    /**
     * 校验公司参数
     *
     * @param company 公司信息
     */
    private void checkCompany(Company company, boolean isEdit) {
        // check company name
        LambdaQueryWrapper<Company> queryWrapper = Wrappers.<Company>lambdaQuery()
                .eq(Company::getCompanyName, company.getCompanyName());
        if (isEdit) {
            queryWrapper.ne(Company::getId, company.getId());
        }
        boolean companyExist = baseMapper.exists(queryWrapper);
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
