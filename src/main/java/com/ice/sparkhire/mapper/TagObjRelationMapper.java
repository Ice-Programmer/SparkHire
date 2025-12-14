package com.ice.sparkhire.mapper;

import com.ice.sparkhire.model.entity.TagObjRelation;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ice.sparkhire.model.vo.TagVO;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Set;

/**
 * @author chenjiahan
 * @description 针对表【tag_obj_rel(tag_obj_rel)】的数据库操作Mapper
 * @createDate 2025-12-14 16:57:31
 * @Entity com.ice.sparkhire.model.entity.TagObjRelation
 */
public interface TagObjRelationMapper extends BaseMapper<TagObjRelation> {

    List<TagVO> selectTagListByObjIdAndObjType(@Param("obj_id") Long objId, @Param("obj_type") Integer objType);
}




