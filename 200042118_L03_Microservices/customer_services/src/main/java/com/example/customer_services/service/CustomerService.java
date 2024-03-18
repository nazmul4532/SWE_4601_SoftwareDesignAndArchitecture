package com.example.customer_services.service;

import com.example.customer_services.entity.Customer;
import com.example.customer_services.repository.CustomerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CustomerService {
    @Autowired
    private CustomerRepository customerRepository;

    public Customer saveCustomer(Customer customer) {
        return customerRepository.save(customer);
    }

    public Customer findCustomerById(String userId) {
        return customerRepository.findCustomerById(userId);
    }
}
