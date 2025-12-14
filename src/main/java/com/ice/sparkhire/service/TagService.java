package com.ice.sparkhire.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ice.sparkhire.model.dto.tag.TagAddRequest;
import com.ice.sparkhire.model.dto.tag.TagBindRequest;
import com.ice.sparkhire.model.dto.tag.TagQueryRequest;
import com.ice.sparkhire.model.entity.Tag;
import com.baomidou.mybatisplus.extension.service.IService;
import com.ice.sparkhire.model.vo.TagVO;
import jakarta.validation.Valid;

/**
 * @author chenjiahan
 * @description 针对表【tag(tag 表)】的数据库操作Service
 * @createDate 2025-12-14 15:54:31
 */
public interface TagService extends IService<Tag> {

    /**
     * 新增 tag
     *
     * @param tagAddRequest 新增 tag 信息
     * @return tag id
     */
    long addTag(TagAddRequest tagAddRequest);

    /**
     * 查询 tag 分页
     *
     * @param tagQueryRequest tag 分页列表
     * @return tag 分页信息
     */
    Page<TagVO> pageTag(TagQueryRequest tagQueryRequest);

    /**
     * 绑定标签关系
     *
     * @param tagBindRequest 标签信息
     * @return 绑定数量
     */
    int bindTagsRelation(@Valid TagBindRequest tagBindRequest);
}
