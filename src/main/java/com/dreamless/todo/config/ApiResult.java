package com.dreamless.todo.config;


import lombok.Data;

import java.io.Serializable;

@Data
public class ApiResult<T> implements Serializable {
    public int code;
    public String msg;
    public T data;

    public static <T> ApiResult<T> ok(T data) {
        ApiResult<T> result = new ApiResult<T>();
        result.code = 0;
        result.msg = "操作成功";
        result.data = data;
        return result;
    }

    public static <T> ApiResult<T> error(String msg) {
        ApiResult<T> result = new ApiResult<T>();
        result.code = 1;
        result.msg = msg;
        return result;
    }
}
