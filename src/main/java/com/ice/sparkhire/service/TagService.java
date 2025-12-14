package com.ice.sparkhire.service;

import com.ice.sparkhire.model.dto.tag.TagAddRequest;
import com.ice.sparkhire.model.entity.Tag;
import com.baomidou.mybatisplus.extension.service.IService;

/**
* @author chenjiahan
* @description 针对表【tag(tag 表)】的数据库操作Service
* @createDate 2025-12-14 15:54:31
*/
public interface TagService extends IService<Tag> {

    /**
     * 新增 tag
     * @param tagAddRequest 新增 tag 信息
     * @return tag id
     */
    long addTag(TagAddRequest tagAddRequest);
}
