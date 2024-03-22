package com.example.order_services.valueObject;

import com.example.order_services.entity.Order;

public class ResponseValueObject {
    private Customer customer;
    private Product product;
    private Employee employee;
    private Order order;

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public void setOrder(Order order) {
        this.order = order;
    }

    public void setEmployee(Employee employee) {
        this.employee = employee;
    }
}
