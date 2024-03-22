package com.example.order_services.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;
import java.util.Date;

@Document(collection = "orders")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Order {

    @Id
    private String id;

    @Field
    private Date date;

    @Getter
    @Field
    private String customerId;

    @Getter
    @Field
    private String productId;

    @Getter
    @Field
    private String employeeId;

}