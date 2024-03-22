package com.example.customer_services.entity;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

@Document(collection = "customers")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Customer {

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
    private String address;
    @Getter
    @Setter
    @Field
    private int age;
}