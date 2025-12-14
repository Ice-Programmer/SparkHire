package com.ice.sparkhire.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ice.sparkhire.auth.vo.UserBasicInfo;
import com.ice.sparkhire.common.BaseEnum;
import com.ice.sparkhire.constant.CommonConstant;
import com.ice.sparkhire.constant.ErrorCode;
import com.ice.sparkhire.exception.BusinessException;
import com.ice.sparkhire.exception.ThrowUtils;
import com.ice.sparkhire.mapper.RecruitmentMapper;
import com.ice.sparkhire.mapper.TagObjRelationMapper;
import com.ice.sparkhire.mapper.UserMapper;
import com.ice.sparkhire.model.dto.tag.TagAddRequest;
import com.ice.sparkhire.model.dto.tag.TagBindRequest;
import com.ice.sparkhire.model.dto.tag.TagQueryRequest;
import com.ice.sparkhire.model.entity.Recruitment;
import com.ice.sparkhire.model.entity.Tag;
import com.ice.sparkhire.model.entity.TagObjRelation;
import com.ice.sparkhire.model.entity.User;
import com.ice.sparkhire.model.enums.TagObjTypeEnum;
import com.ice.sparkhire.model.vo.TagVO;
import com.ice.sparkhire.security.SecurityContext;
import com.ice.sparkhire.service.TagService;
import com.ice.sparkhire.mapper.TagMapper;
import com.ice.sparkhire.utils.SqlUtils;
import jakarta.annotation.Resource;
import org.apache.commons.lang3.ObjectUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * @author chenjiahan
 * @description 针对表【tag(tag 表)】的数据库操作Service实现
 * @createDate 2025-12-14 15:54:31
 */
@Service
public class TagServiceImpl extends ServiceImpl<TagMapper, Tag>
        implements TagService {

    @Resource
    private TagObjRelationMapper tagObjRelationMapper;

    @Resource
    private UserMapper userMapper;

    @Resource
    private RecruitmentMapper recruitmentMapper;

    @Override
    public long addTag(TagAddRequest tagAddRequest) {
        // 1. 判断是否重名
        boolean exists = baseMapper.exists(Wrappers.<Tag>lambdaQuery()
                .eq(Tag::getTagName, tagAddRequest.getTagName()));
        if (exists) {
            throw new BusinessException(ErrorCode.OPERATION_ERROR, "当前标签已存在，请勿重复创建");
        }

        UserBasicInfo currentUser = SecurityContext.getCurrentUser();

        Tag tag = new Tag();
        BeanUtils.copyProperties(tagAddRequest, tag);
        tag.setCreateUserId(currentUser.getId());

        try {
            baseMapper.insert(tag);
        } catch (DuplicateKeyException e) {
            throw new BusinessException(ErrorCode.OPERATION_ERROR, "当前标签已存在，请勿重复创建");
        }

        return tag.getId();
    }

    @Override
    public Page<TagVO> pageTag(TagQueryRequest tagQueryRequest) {
        long current = tagQueryRequest.getCurrent();
        long pageSize = tagQueryRequest.getPageSize();

        Page<Tag> tagPage = baseMapper.selectPage(new Page<>(current, pageSize), getQueryWrapper(tagQueryRequest));

        List<Tag> tagList = tagPage.getRecords();

        List<TagVO> tagVOList = tagList.stream().map(tag -> {
            TagVO tagVO = new TagVO();
            BeanUtils.copyProperties(tag, tagVO);
            return tagVO;
        }).toList();

        Page<TagVO> tagVOPage = new Page<>(tagPage.getPages(), tagPage.getSize(), tagPage.getTotal());
        tagVOPage.setRecords(tagVOList);

        return tagVOPage;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int bindTagsRelation(TagBindRequest tagBindRequest) {
        List<Long> tagIdList = tagBindRequest.getTagIdList();

        // 判断是否都存在
        Long count = baseMapper.selectCount(Wrappers.<Tag>lambdaQuery()
                .in(Tag::getId, tagIdList));
        if (ObjectUtils.isEmpty(count) || count < tagIdList.size()) {
            throw new BusinessException(ErrorCode.OPERATION_ERROR, "tag id 存在错误");
        }

        // 判断 obj id 是否存在
        checkTagObjIdExist(tagBindRequest.getObjType(), tagBindRequest.getObjId());

        Set<TagObjRelation> tagObjRelations = tagIdList.stream().map(tagId -> {
            TagObjRelation tagRelation = new TagObjRelation();
            tagRelation.setTagId(tagId);
            tagRelation.setObjType(tagBindRequest.getObjType());
            tagRelation.setObjId(tagBindRequest.getObjId());
            return tagRelation;
        }).collect(Collectors.toSet());

        // 判断是否有重复
        boolean exists = tagObjRelationMapper.exists(Wrappers.<TagObjRelation>lambdaQuery()
                .in(TagObjRelation::getTagId, tagIdList)
                .eq(TagObjRelation::getObjId, tagBindRequest.getObjId()));
        ThrowUtils.throwIf(exists, ErrorCode.OPERATION_ERROR, "tag 关联关系已存在！");

        // 创建关联关系
        tagObjRelationMapper.insert(tagObjRelations);

        return tagObjRelations.size();
    }

    private void checkTagObjIdExist(int objType, long objId) {
        UserBasicInfo currentUser = SecurityContext.getCurrentUser();
        TagObjTypeEnum tagType = BaseEnum.getEnumByValue(TagObjTypeEnum.class, objType);

        switch (tagType) {
            case EMPLOYEE_TYPE -> {
                ThrowUtils.throwIf(!Objects.equals(currentUser.getId(), objId), ErrorCode.OPERATION_ERROR, "仅可设置自己的 tag");
                boolean exists = userMapper.exists(Wrappers.<User>lambdaQuery().eq(User::getId, objId));
                ThrowUtils.throwIf(!exists, ErrorCode.NOT_FOUND_ERROR, "用户数据不存在");
            }
            case RECRUITMENT_TYPE -> {
                Recruitment recruitment = recruitmentMapper.selectOne(Wrappers.<Recruitment>lambdaQuery()
                        .select(Recruitment::getUserId)
                        .eq(Recruitment::getId, objId));
                ThrowUtils.throwIf(ObjectUtils.isEmpty(recruitment), ErrorCode.NOT_FOUND_ERROR, "招聘数据不存在");
                ThrowUtils.throwIf(!Objects.equals(recruitment.getUserId(), currentUser.getId()), ErrorCode.OPERATION_ERROR, "仅岗位创建者可更改 tag");
            }
        }
    }

    /**
     * 拼接 tag 查询参数
     *
     * @param tagQueryRequest tag 查询参数
     * @return 查询条件
     */
    private LambdaQueryWrapper<Tag> getQueryWrapper(TagQueryRequest tagQueryRequest) {
        LambdaQueryWrapper<Tag> queryWrapper = Wrappers.lambdaQuery();
        if (tagQueryRequest == null) {
            return queryWrapper;
        }

        Long id = tagQueryRequest.getId();
        List<Long> ids = tagQueryRequest.getIds();
        String name = tagQueryRequest.getName();

        queryWrapper.eq(ObjectUtils.isNotEmpty(id), Tag::getId, id);
        queryWrapper.in(!CollectionUtils.isEmpty(ids), Tag::getId, ids);
        queryWrapper.like(StringUtils.hasLength(name), Tag::getTagName, name);

        String sortField = tagQueryRequest.getSortField();
        String sortOrder = tagQueryRequest.getSortOrder();

        if (SqlUtils.validSortField(sortField)) {
            boolean isAsc = CommonConstant.SORT_ORDER_ASC.equals(sortOrder);
            queryWrapper.last("ORDER BY " + sortField + (isAsc ? " ASC" : " DESC"));
        }

        return queryWrapper;
    }
}




