package com.ice.sparkhire.cache;

import com.ice.sparkhire.model.entity.Career;
import com.ice.sparkhire.model.entity.Industry;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/**
 * 本地缓存
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/7/22 20:57
 */
public class LocalCache {

    private static Map<Long, Career> CAREER_MAP = new HashMap<>();

    private static Map<Long, Industry> INDUSTRY_MAP = new HashMap<>();

    public static void setCareerMap(Map<Long, Career> careerMap) {
        CAREER_MAP = careerMap;
    }

    public static void clearCareerMap() {
        CAREER_MAP.clear();
    }

    public static Map<Long, Career> getCareerMap() {
        return CAREER_MAP != null ? CAREER_MAP : Collections.emptyMap();
    }

    public static void setIndustryMap(Map<Long, Industry> industryMap) {
        INDUSTRY_MAP = industryMap;
    }

    public static void clearIndustryMap() {
        INDUSTRY_MAP.clear();
    }

    public static Map<Long, Industry> getIndustryMap() {
        return INDUSTRY_MAP != null ? INDUSTRY_MAP : Collections.emptyMap();
    }
}
