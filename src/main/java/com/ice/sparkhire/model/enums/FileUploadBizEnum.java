package com.ice.sparkhire.model.enums;

import com.ice.sparkhire.common.BaseEnum;
import lombok.Getter;

/**
 * 文件上传业务类型枚举
 **/
@Getter
public enum FileUploadBizEnum implements BaseEnum<String> {

    USER_AVATAR("用户头像", "user_avatar"),
    COMPANY_IMG("公司图片", "company_img");

    private final String text;

    private final String value;

    FileUploadBizEnum(String text, String value) {
        this.text = text;
        this.value = value;
    }
}
