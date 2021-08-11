package com.dreamless.todo.config;


import org.springframework.amqp.core.Binding;
import org.springframework.amqp.core.BindingBuilder;
import org.springframework.amqp.core.DirectExchange;
import org.springframework.amqp.core.Queue;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class RabbitmqConfig {
    public static final String QUEUE = "TODO_QUEUE";
    public static final String DIRECT_EXCHANGE = "TODO_DIRECT_EXCHANGE";
    public static final String ROUTING  = "TODO_ROUTING";

    @Bean
    public Queue queue() {
        return new Queue(QUEUE);
    }

    @Bean
    public DirectExchange directExchange() {
        return new DirectExchange(DIRECT_EXCHANGE);
    }

    @Bean
    public Binding binding(){
        BindingBuilder.bind(queue());
        return BindingBuilder.bind(queue()).to(directExchange()).with(ROUTING);
    }

    @Bean
    public DirectExchange lonelyDirectExchange(){
        return new DirectExchange("lonelyDirectExchange");
    }

}
