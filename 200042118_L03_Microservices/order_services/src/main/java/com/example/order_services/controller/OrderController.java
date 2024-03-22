package com.example.order_services.controller;

import com.example.order_services.entity.Order;
import com.example.order_services.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/orders")
public class OrderController {
    @Autowired
    private OrderService orderService;

    @GetMapping("/")
    public String getOrder(){
        return "Hello";
    }

    @PostMapping("/")
    public Order saveOrder(@RequestBody Order order){
        return orderService.saveOrder(order);
    }

    @GetMapping("/{id}")
    public Order findOrderById(@PathVariable("id") String orderId){
        return orderService.findOrderById(orderId);
    }
}
