package com.ice.sparkhire.model.dto.tag;

import lombok.Data;
import org.hibernate.validator.constraints.Length;

import java.io.Serial;
import java.io.Serializable;

/**
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/12/14 15:55
 */
@Data
public class TagAddRequest implements Serializable {

    /**
     * tag name
     */
    @Length(max = 10, message = "标签名称长度不得超过 10！")
    private String tagName;

    @Serial
    private static final long serialVersionUID = -3324531930110020349L;
}
