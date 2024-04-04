package com.example.order_services.repository;

import com.example.order_services.entity.Order;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface OrderRepository extends MongoRepository<Order, String> {
    Order findOrderById(String Id);
}