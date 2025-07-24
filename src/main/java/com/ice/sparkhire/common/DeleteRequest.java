package com.ice.sparkhire.common;

import jakarta.validation.constraints.Min;
import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

/**
 * 删除请求
 */
@Data
public class DeleteRequest implements Serializable {

    /**
     * id
     */
    @Min(value = 1, message = "id 不得小于 0")
    private Long id;

    @Serial
    private static final long serialVersionUID = 1L;
}