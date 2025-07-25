package com.ice.sparkhire.scheduler;

import com.ice.sparkhire.service.CareerService;
import com.ice.sparkhire.service.IndustryService;
import com.ice.sparkhire.service.MajorService;
import com.ice.sparkhire.service.SchoolService;
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

    @Resource
    private SchoolService schoolService;

    @Resource
    private MajorService majorService;

    @PostConstruct
    public void init() {
        careerService.refreshCareerMapCache();
        industryService.refreshIndustryMapCache();
        schoolService.refreshSchoolMapCache();
        majorService.refreshMajorMapCache();
    }

    @Scheduled(cron = "0 0 1 * * *")
    public void refreshCache() {
        // 刷新本地职业缓存
        careerService.refreshCareerMapCache();
        // 刷新本地行业缓存
        industryService.refreshIndustryMapCache();
        // 刷新本地学校缓存
        schoolService.refreshSchoolMapCache();
        // 刷新本地专业缓存
        majorService.refreshMajorMapCache();
    }
}
