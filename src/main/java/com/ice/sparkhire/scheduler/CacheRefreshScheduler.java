package com.ice.sparkhire.scheduler;

import com.ice.sparkhire.service.CareerService;
import com.ice.sparkhire.service.IndustryService;
import jakarta.annotation.PostConstruct;
import jakarta.annotation.Resource;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/7/22 21:01
 */
@Component
public class CacheRefreshScheduler {

    @Resource
    private CareerService careerService;

    @Resource
    private IndustryService industryService;

    @PostConstruct
    public void init() {
        careerService.refreshCareerMapCache();
        industryService.refreshIndustryMapCache();
    }

    @Scheduled(cron = "0 0 1 * * *")
    public void refreshCache() {
        // 刷新本地职业缓存
        careerService.refreshCareerMapCache();
        // 刷新本地行业缓存
        industryService.refreshIndustryMapCache();
    }
}
