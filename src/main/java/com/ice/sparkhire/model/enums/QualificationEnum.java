package com.ice.sparkhire.model.enums;

import com.ice.sparkhire.common.BaseEnum;
import lombok.Getter;

/**
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/7/7 14:26
 */
@Getter
public enum QualificationEnum implements BaseEnum<Integer> {

    ENGLISH("英语类", 0),
    FOREIGN_LANGUAGE("外语类", 1),
    IT("IT类", 2),
    PROJECT_MANAGEMENT("项目管理类", 3),
    ACCOUNTING("会计类", 4),
    AUDITING("审计类", 5),
    STATISTICS("统计类", 6),
    ACTUARY("精算类", 7),
    FINANCE("金融类", 8),
    LAW("法律类", 9),
    EDUCATION("教育类", 10),
    PRESCHOOL_EDUCATION("幼教类", 11),
    CHINESE("汉语类", 12),
    PSYCHOLOGY_CONSULTING("心理咨询类", 13),
    MEDICAL("医疗类", 14),
    SPORTS_FITNESS("体育健身类", 15),
    REAL_ESTATE_CONSTRUCTION("房地产建筑类", 16),
    HR_ADMINISTRATION("人力行政类", 17),
    ART("艺术类", 18),
    NUTRITIONIST("营养师类", 19),
    DRIVING("驾驶类", 20),
    SKILLED_WORKER("技工类", 21),
    PRODUCTION_MANUFACTURING("生产制造类", 22),
    MARKETING("市场类", 23),
    TOURISM("旅游类", 24),
    MEDIA("传媒类", 25),
    AGRICULTURE_FORESTRY_ANIMAL_HUSBANDRY_FISHERY("农/林/牧/渔类", 26),
    ENVIRONMENTAL_PROTECTION("环保类", 27),
    SPECIAL("特殊类", 28),
    TRANSPORTATION("交通运输类", 29);

    private final String text;

    private final Integer value;

    QualificationEnum(String text, Integer value) {
        this.text = text;
        this.value = value;
    }
}
