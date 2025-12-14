package com.ice.sparkhire.model.dto.tag;

import com.ice.sparkhire.common.PageRequest;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serial;
import java.io.Serializable;
import java.util.List;

/**
 * tag 查询请求体
 *
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/12/14 16:09
 */
@Data
@EqualsAndHashCode(callSuper = true)
public class TagQueryRequest extends PageRequest implements Serializable {

    /**
     * id
     */
    private Long id;

    /**
     * ids
     */
    private List<Long> ids;

    /**
     * tag name
     */
    private String name;

    @Serial
    private static final long serialVersionUID = 7584534290359528371L;
}

