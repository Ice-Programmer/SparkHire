package com.ice.sparkhire.model.vo;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

/**
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/12/14 16:07
 */
@Data
public class TagVO  implements Serializable {

    /**
     * id
     */
    private Long id;

    /**
     * Tag Name
     */
    private String tagName;

    @Serial
    private static final long serialVersionUID = 3434590460118065542L;
}
