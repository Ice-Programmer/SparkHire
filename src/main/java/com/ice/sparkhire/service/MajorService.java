package com.ice.sparkhire.service;

import com.ice.sparkhire.model.entity.Major;
import com.baomidou.mybatisplus.extension.service.IService;
import com.ice.sparkhire.model.vo.MajorVO;

import java.util.List;

/**
 * @author chenjiahan
 * @description 针对表【major(专业)】的数据库操作Service
 * @createDate 2025-07-06 16:13:53
 */
public interface MajorService extends IService<Major> {

    /**
     * 获取专业列表
     *
     * @return 获取专业列表
     */
    List<MajorVO> getMajorList();

    /**
     * 刷新本地专业缓存
     */
    void refreshMajorMapCache();
}
