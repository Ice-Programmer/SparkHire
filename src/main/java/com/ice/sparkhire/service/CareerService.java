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
}
