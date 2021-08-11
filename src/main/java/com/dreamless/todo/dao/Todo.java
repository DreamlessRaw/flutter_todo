package com.dreamless.todo.dao;

import java.io.Serializable;
import java.util.Date;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import javax.validation.constraints.Max;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.Size;

/**
 * todo
 *
 * @author 马志伦
 */
@Data
@TableName("todo")
public class Todo implements Serializable {
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    /**
     * 标题
     */
    @NotEmpty(message = "标题不能为空")
    @Size(min = 2, max = 20, message = "标题长度范围2-20")
    private String title;

    /**
     * 内容
     */
    @NotEmpty(message = "内容不能为空")
    @Size(min = 2, max = 200, message = "内容长度范围2-200")
    private String content;

    /**
     * 删除
     */
    private boolean deleteFlag;

    private Date createTime;

    private static final long serialVersionUID = 1L;
}