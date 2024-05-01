package com.example.orderservice.controller;

import com.example.orderservice.Constants;
import com.example.orderservice.entity.Order;
import com.example.orderservice.entity.OrderStatus;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/order")
public class OrderController {
    @Autowired
    private RabbitTemplate rabbitTemplate;

    @PostMapping("/{restaurantName}")
    public String bookOrder(@RequestBody Order order, @PathVariable String restaurantName) {
        order.setOrderId(UUID.randomUUID().toString());
        OrderStatus orderStatus = new OrderStatus("54321", order, "PROCESS", "Order Successfully Placed to " + restaurantName + " with your desired product");
//        OrderStatus orderStatus = new OrderStatus(order, "PROCESS", "Order Successfully Placed to " + restaurantName + " with your desired product");
        rabbitTemplate.convertAndSend(Constants.EXCHANGE, Constants.ROUTING_KEY, orderStatus);
        return "success!!";
    }
}