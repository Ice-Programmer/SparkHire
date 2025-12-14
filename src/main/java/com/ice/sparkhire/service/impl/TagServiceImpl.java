package com.ice.sparkhire.service.impl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ice.sparkhire.auth.vo.UserBasicInfo;
import com.ice.sparkhire.constant.ErrorCode;
import com.ice.sparkhire.exception.BusinessException;
import com.ice.sparkhire.exception.ThrowUtils;
import com.ice.sparkhire.model.dto.tag.TagAddRequest;
import com.ice.sparkhire.model.entity.Tag;
import com.ice.sparkhire.security.SecurityContext;
import com.ice.sparkhire.service.TagService;
import com.ice.sparkhire.mapper.TagMapper;
import org.springframework.beans.BeanUtils;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;

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
}




