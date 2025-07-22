package com.ice.sparkhire.service;

import com.ice.sparkhire.model.entity.Career;
import com.baomidou.mybatisplus.extension.service.IService;
import com.ice.sparkhire.model.vo.CareerVO;

import java.util.List;

/**
 * @author chenjiahan
 * @description 针对表【career(职业)】的数据库操作Service
 * @createDate 2025-07-07 20:21:25
 */
public interface CareerService extends IService<Career> {

    /**
     * 获取职业列表
     *
     * @return 职业列表
     */
    List<CareerVO> getCareerList();

    /**
     * 校验职业行业是否存在
     *
     * @param careerId   职业 id
     * @param industryId 行业 id
     */
    void checkCareerAndIndustryExist(long careerId, long industryId);

    /**
     * 刷新本地职业缓存
     */
    void refreshCareerMapCache();
}
