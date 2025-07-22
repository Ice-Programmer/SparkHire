package com.ice.sparkhire.service;

import com.ice.sparkhire.model.entity.Industry;
import com.baomidou.mybatisplus.extension.service.IService;
import com.ice.sparkhire.model.vo.IndustryVO;

import java.util.List;

/**
* @author chenjiahan
* @description 针对表【industry(行业)】的数据库操作Service
* @createDate 2025-07-07 19:58:24
*/
public interface IndustryService extends IService<Industry> {

    /**
     * 获取行业列表
     *
     * @return 行业列表
     */
    List<IndustryVO> getIndustryList();

    /**
     * 刷新行业缓存
     */
    void refreshIndustryMapCache();
}
