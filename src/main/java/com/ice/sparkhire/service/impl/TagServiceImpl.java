package com.ice.sparkhire.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ice.sparkhire.auth.vo.UserBasicInfo;
import com.ice.sparkhire.constant.CommonConstant;
import com.ice.sparkhire.constant.ErrorCode;
import com.ice.sparkhire.exception.BusinessException;
import com.ice.sparkhire.exception.ThrowUtils;
import com.ice.sparkhire.model.dto.tag.TagAddRequest;
import com.ice.sparkhire.model.dto.tag.TagQueryRequest;
import com.ice.sparkhire.model.entity.Tag;
import com.ice.sparkhire.model.vo.TagVO;
import com.ice.sparkhire.security.SecurityContext;
import com.ice.sparkhire.service.TagService;
import com.ice.sparkhire.mapper.TagMapper;
import com.ice.sparkhire.utils.SqlUtils;
import org.apache.commons.lang3.ObjectUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import java.util.List;

/**
 * @author chenjiahan
 * @description 针对表【tag(tag 表)】的数据库操作Service实现
 * @createDate 2025-12-14 15:54:31
 */
@Service
public class TagServiceImpl extends ServiceImpl<TagMapper, Tag>
        implements TagService {

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




