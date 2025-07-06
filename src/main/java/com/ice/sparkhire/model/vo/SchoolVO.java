package com.ice.sparkhire.model.vo;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

/**
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/7/6 15:52
 */
@Data
public class SchoolVO implements Serializable {

    /**
     * id
     */
    private Long id;

    /**
     * 专业名称
     */
    private String schoolName;


    @Serial
    private static final long serialVersionUID = -7962815157474729654L;
}
