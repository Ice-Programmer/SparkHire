package com.ice.sparkhire.service;

import com.ice.sparkhire.model.entity.School;
import com.baomidou.mybatisplus.extension.service.IService;
import com.ice.sparkhire.model.vo.SchoolVO;

import java.util.List;

/**
* @author chenjiahan
* @description 针对表【school(学校)】的数据库操作Service
* @createDate 2025-07-06 15:50:16
*/
public interface SchoolService extends IService<School> {

    /**
     * 获取学校列表
     * @return 学校列表
     */
    List<SchoolVO> getSchoolList();
}
