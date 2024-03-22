package com.example.order_services.entity;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;
import java.util.Date;

@Getter
@Document(collection = "orders")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Order {

    @Setter
    @Id
    private String id;

    @Setter
    @Field
    private Date date;

    @Setter
    @Field
    private String customerId;

    @Setter
    @Field
    private String productId;

    @Setter
    @Field
    private String employeeId;

}