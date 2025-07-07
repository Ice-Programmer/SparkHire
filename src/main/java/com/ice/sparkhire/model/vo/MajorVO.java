package com.ice.sparkhire.model.vo;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

/**
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/7/6 16:15
 */
@Data
public class MajorVO implements Serializable {

    /**
     * id
     */
    private Long id;

    /**
     * 专业名称
     */
    private String majorName;

    @Serial
    private static final long serialVersionUID = -1363057206168091611L;
}
