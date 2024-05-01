package com.example.inventoryservice.controller;

import com.example.inventoryservice.Constants;
import com.example.inventoryservice.entity.OrderStatus;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;
import com.example.inventoryservice.entity.Product;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@Component
public class InventoryController {
    @RabbitListener(queues = Constants.QUEUE )
    public void consumeMessageFromQueue(OrderStatus orderStatus) {
        System.out.println("Message Received from queue: " +orderStatus );
        List<Product> products = readProductsFromJsonFile("/Users/nazmul/IdeaProjects/Lab4/inventory-service/src/main/java/com/example/inventoryservice/products.json");
        boolean flag = false;
        for (Product product : products) {
            if (product.getProductId().equals(orderStatus.getProductId())) {
                flag = true;
                if(product.getQty() >= orderStatus.getOrder().getQty()){
                    System.out.println("Order can be completed. Product meets minimum quantity in inventory.");
                }
                else{
                    System.out.println(("Order cannot be completed. Product doesn't meet minimum quantity in inventory."));
                }
            }
        }
        if(!flag){
            System.out.println("No product under the requested id exists in the database. Order Cannot be completed!!");
        }
    }

    private static List<Product> readProductsFromJsonFile(String filename) {
        ObjectMapper objectMapper = new ObjectMapper();
        File file = new File(filename);
        try {
            return Arrays.asList(objectMapper.readValue(file, Product[].class));
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }
}