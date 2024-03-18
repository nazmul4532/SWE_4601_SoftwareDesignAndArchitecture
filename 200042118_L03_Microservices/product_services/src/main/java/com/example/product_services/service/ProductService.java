package com.example.product_services.service;

import com.example.product_services.entity.Product;
import com.example.product_services.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ProductService {
    @Autowired
    private ProductRepository productRepository;

    public Product saveProduct(Product product) {
        return productRepository.save(product);
    }

    public Product findProductById(String userId) {
        return productRepository.findProductById(userId);
    }
}
