package com.ice.sparkhire.cache;

import com.ice.sparkhire.model.entity.Career;
import com.ice.sparkhire.model.entity.Industry;
import com.ice.sparkhire.model.entity.Major;
import com.ice.sparkhire.model.entity.School;

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

    private static Map<Long, School> SCHOOLS_MAP = new HashMap<>();

    private static Map<Long, Major> MAJOR_MAP = new HashMap<>();

    public static synchronized void setCareerMap(Map<Long, Career> careerMap) {
        CAREER_MAP.clear();
        CAREER_MAP = careerMap;
    }

    public static void clearCareerMap() {
        CAREER_MAP.clear();
    }

    public static Map<Long, Career> getCareerMap() {
        return CAREER_MAP != null ? CAREER_MAP : Collections.emptyMap();
    }

    public static synchronized void setIndustryMap(Map<Long, Industry> industryMap) {
        CAREER_MAP.clear();
        INDUSTRY_MAP = industryMap;
    }

    public static void clearIndustryMap() {
        INDUSTRY_MAP.clear();
    }

    public static Map<Long, Industry> getIndustryMap() {
        return INDUSTRY_MAP != null ? INDUSTRY_MAP : Collections.emptyMap();
    }

    public static synchronized void setSchoolMap(Map<Long, School> schoolMap) {
        SCHOOLS_MAP.clear();
        SCHOOLS_MAP = schoolMap;
    }

    public static void clearSchoolMap() {
        SCHOOLS_MAP.clear();
    }

    public static Map<Long, School> getSchoolMap() {
        return SCHOOLS_MAP != null ? SCHOOLS_MAP : Collections.emptyMap();
    }

    public static synchronized void setMajorMap(Map<Long, Major> majorMap) {
        MAJOR_MAP.clear();
        MAJOR_MAP = majorMap;
    }

    public static void clearMajorMap() {
        MAJOR_MAP.clear();
    }

    public static Map<Long, Major> getMajorMap() {
        return MAJOR_MAP != null ? MAJOR_MAP : Collections.emptyMap();
    }
}
