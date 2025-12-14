package com.ice.sparkhire.model.dto.tag;

import com.ice.sparkhire.annotation.EnumCheck;
import com.ice.sparkhire.model.enums.TagObjTypeEnum;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.util.List;

/**
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/12/14 16:59
 */
@Data
public class TagBindRequest implements Serializable {

    /**
     * obj id
     */
    @NotNull
    private Long objId;

    /**
     * obj type
     */
    @EnumCheck(enumClass = TagObjTypeEnum.class)
    private Integer objType;

    /**
     * tag ids
     */
    @Size(max = 10, message = "绑定标签最多 10 个")
    @NotEmpty
    private List<Long> tagIdList;

    @Serial
    private static final long serialVersionUID = -8014498075718458552L;
}
