package com.ice.sparkhire.mapper;

import com.ice.sparkhire.model.entity.School;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ice.sparkhire.model.vo.SchoolVO;

import java.util.List;

/**
* @author chenjiahan
* @description 针对表【school(学校)】的数据库操作Mapper
* @createDate 2025-07-06 15:50:16
* @Entity com.ice.sparkhire.model.entity.School
*/
public interface SchoolMapper extends BaseMapper<School> {

    List<SchoolVO> selectSchoolList();
}




