package com.ice.sparkhire.service;

import com.ice.sparkhire.model.dto.company.CompanyAddRequest;
import com.ice.sparkhire.model.dto.company.CompanyEditRequest;
import com.ice.sparkhire.model.entity.Company;
import com.baomidou.mybatisplus.extension.service.IService;
import com.ice.sparkhire.model.vo.CompanyVO;
import jakarta.validation.Valid;

/**
 * @author chenjiahan
 * @description 针对表【company(公司信息)】的数据库操作Service
 * @createDate 2025-12-13 16:27:23
 */
public interface CompanyService extends IService<Company> {

    /**
     * 新增公司
     *
     * @param companyAddRequest 新增参数
     * @return 公司 id
     */
    long addCompany(CompanyAddRequest companyAddRequest);

    /**
     * 获取公司信息
     *
     * @param companyId 公司 id
     * @return 公司信息
     */
    CompanyVO getCompanyVO(Long companyId);

    /**
     * 修改公司信息
     *
     * @param companyEditRequest 修改参数
     * @return 公司信息
     */
    CompanyVO editCompany(@Valid CompanyEditRequest companyEditRequest);

    /**
     * 删除公司
     *
     * @param companyId 公司 id
     * @return 删除成功
     */
    boolean deleteCompany(Long companyId);
}
