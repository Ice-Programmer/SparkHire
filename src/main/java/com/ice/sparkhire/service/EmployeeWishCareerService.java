package com.ice.sparkhire.service;

import com.ice.sparkhire.model.dto.career.WishCareerAddRequest;
import com.ice.sparkhire.model.dto.career.WishCareerEditRequest;
import com.ice.sparkhire.model.entity.EmployeeWishCareer;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * @author chenjiahan
 * @description 针对表【employee_wish_career(应聘者期望岗位)】的数据库操作Service
 * @createDate 2025-07-20 09:08:55
 */
public interface EmployeeWishCareerService extends IService<EmployeeWishCareer> {

    /**
     * 添加期望职业
     *
     * @param wishCareerAddRequest 期望职业添加请求参数
     * @return 期望职业 id
     */
    Long addWishCareer(WishCareerAddRequest wishCareerAddRequest);

    /**
     * 编辑期望职业
     *
     * @param wishCareerEditRequest 编辑期望职业
     * @return 编辑成功
     */
    Boolean editWishCareer(WishCareerEditRequest wishCareerEditRequest);
}
