package com.ice.sparkhire.model.enums;

import com.ice.sparkhire.common.BaseEnum;
import lombok.Getter;

/**
 * 省份枚举
 * 
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/07/07
 */
@Getter
public enum ProvinceEnum implements BaseEnum<Integer> {

    BEIJING("北京市", 1),
    TIANJIN("天津市", 2),
    HEBEI("河北省", 3),
    SHANXI("山西省", 4),
    INNER_MONGOLIA("内蒙古", 5),
    LIAONING("辽宁省", 6),
    JILIN("吉林省", 7),
    HEILONGJIANG("黑龙江", 8),
    SHANGHAI("上海市", 9),
    JIANGSU("江苏省", 10),
    ZHEJIANG("浙江省", 11),
    ANHUI("安徽省", 12),
    FUJIAN("福建省", 13),
    JIANGXI("江西省", 14),
    SHANDONG("山东省", 15),
    HENAN("河南省", 16),
    HUBEI("湖北省", 17),
    HUNAN("湖南省", 18),
    GUANGDONG("广东省", 19),
    GUANGXI("广西", 20),
    HAINAN("海南省", 21),
    CHONGQING("重庆市", 22),
    SICHUAN("四川省", 23),
    GUIZHOU("贵州省", 24),
    YUNNAN("云南省", 25),
    TIBET("西藏", 26),
    SHAANXI("陕西省", 27),
    GANSU("甘肃省", 28),
    QINGHAI("青海省", 29),
    NINGXIA("宁夏", 30),
    XINJIANG("新疆", 31),
    TAIWAN("台湾省", 32),
    HONGKONG("香港", 33),
    MACAU("澳门", 34);

    private final String text;

    private final Integer value;

    ProvinceEnum(String text, Integer value) {
        this.text = text;
        this.value = value;
    }
}
