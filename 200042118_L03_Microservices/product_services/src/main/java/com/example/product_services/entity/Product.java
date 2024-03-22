package com.example.product_services.entity;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

@Document(collection = "products")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Product {

    @Getter
    @Setter
    @Id
    private String id;
    @Getter
    @Setter
    @Field
    private String name;
    @Getter
    @Setter
    @Field
    private String description;
    @Getter
    @Setter
    @Field
    private double price;
}