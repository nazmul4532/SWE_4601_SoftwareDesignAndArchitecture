package com.example.order_services.controller;

import com.example.order_services.entity.Order;
import com.example.order_services.service.OrderService;
import com.example.order_services.valueObject.ResponseValueObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/orders")
public class OrderController {
    @Autowired
    private OrderService orderService;

    @PostMapping("/")
    public Order saveOrder(@RequestBody Order order){
        return orderService.saveOrder(order);
    }

    @GetMapping("/{id}")
    public ResponseValueObject findOrderById(@PathVariable String id){
        return orderService.getUserWithDepartment(id);
    }
}