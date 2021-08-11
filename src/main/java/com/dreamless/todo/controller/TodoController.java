package com.dreamless.todo.controller;


import cn.hutool.core.date.DateTime;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.dreamless.todo.config.ApiResult;
import com.dreamless.todo.config.RabbitmqConfig;
import com.dreamless.todo.dao.Todo;
import com.dreamless.todo.mapper.TodoMapper;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.validation.Valid;

@RestController
@RequestMapping("todo")
public class TodoController {

    @Resource
    RabbitTemplate rabbitTemplate;
    @Resource
    TodoMapper todoMapper;


    @GetMapping("list/{page}/{size}")
    public Page<Todo> getList(@PathVariable int page, @PathVariable int size) {
        Page<Todo> todoPage = todoMapper.selectPage(new Page<Todo>(page, size), new QueryWrapper<>());
        return todoPage;
    }

    @PostMapping("create")
    public ApiResult<Boolean> create(@RequestBody @Valid Todo todo, BindingResult bindingResult) {
        todo.setCreateTime(DateTime.now());
        int result = todoMapper.insert(todo);
        return result > 0 ? ApiResult.ok(true) : ApiResult.error("操作失败");
    }

    @PostMapping("update")
    public ApiResult<Boolean> update(@RequestBody Todo todo) {
        int result = todoMapper.updateById(todo);
        return result > 0 ? ApiResult.ok(true) : ApiResult.error("操作失败");
    }


    @PostMapping("delete")
    public ApiResult<Boolean> delete(@RequestBody @Valid Todo todo) {
        int result = todoMapper.deleteById(todo.getId());
        return result > 0 ? ApiResult.ok(true) : ApiResult.error("操作失败");
    }


    @GetMapping("send")
    public String send() {
        rabbitTemplate.convertAndSend(RabbitmqConfig.DIRECT_EXCHANGE, RabbitmqConfig.ROUTING, "测试消息");
        return "发送成功";
    }
}
