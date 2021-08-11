package com.dreamless.todo.config;

import com.rabbitmq.client.Channel;
import org.springframework.amqp.core.Message;
import org.springframework.amqp.rabbit.annotation.RabbitHandler;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
@RabbitListener(queues = "TODO_QUEUE")
public class RabbitmqReceiver {

    @RabbitHandler
    public void process(Message message, Channel channel, String body) throws IOException {
        System.out.println("接收结果 ：" + body);
        channel.basicAck(message.getMessageProperties().getDeliveryTag(), false);
    }


}
