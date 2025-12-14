package com.ice.sparkhire.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ice.sparkhire.common.BaseResponse;
import com.ice.sparkhire.common.ResultUtils;
import com.ice.sparkhire.model.dto.tag.TagAddRequest;
import com.ice.sparkhire.model.dto.tag.TagBindRequest;
import com.ice.sparkhire.model.dto.tag.TagQueryRequest;
import com.ice.sparkhire.model.vo.TagVO;
import com.ice.sparkhire.service.TagService;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/12/14 15:55
 */
@RestController
@RequestMapping("/tag")
public class TagController {

    @Resource
    private TagService tagService;

    /**
     * 新增标签接口
     *
     * @param tagAddRequest 新增标签
     * @return 标签 id
     */
    @PostMapping("/add")
    public BaseResponse<Long> addTag(@RequestBody @Valid TagAddRequest tagAddRequest) {
        long tagId = tagService.addTag(tagAddRequest);

        return ResultUtils.success(tagId);
    }


    /**
     * 查询 tag 列表
     *
     * @param tagQueryRequest 查询tag
     * @return tag 列表
     */
    @PostMapping("/query")
    public BaseResponse<Page<TagVO>> queryTagPage(@RequestBody TagQueryRequest tagQueryRequest) {

        Page<TagVO> tagVOPage = tagService.pageTag(tagQueryRequest);

        return ResultUtils.success(tagVOPage);
    }

    /**
     * 绑定标签
     *
     * @param tagBindRequest 绑定标签信息
     * @return 绑定数量
     */
    @PostMapping("/binding")
    public BaseResponse<Integer> bindTagsRelation(@RequestBody @Valid TagBindRequest tagBindRequest) {

        int num = tagService.bindTagsRelation(tagBindRequest);

        return ResultUtils.success(num);
    }
}
