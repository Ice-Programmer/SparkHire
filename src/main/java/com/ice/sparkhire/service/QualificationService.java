package com.ice.sparkhire.service;

import com.ice.sparkhire.model.entity.Qualification;
import com.baomidou.mybatisplus.extension.service.IService;
import com.ice.sparkhire.model.vo.QualificationVO;

import java.util.List;

/**
* @author chenjiahan
* @description 针对表【qualification(资格证书)】的数据库操作Service
* @createDate 2025-07-07 14:19:50
*/
public interface QualificationService extends IService<Qualification> {

    /**
     * 获取证书列表
     *
     * @return 证书列表
     */
    List<QualificationVO> getQualificationList();

    /**
     * 刷新证书 map 缓存
     */
    void refreshQualificationMapCache();
}
