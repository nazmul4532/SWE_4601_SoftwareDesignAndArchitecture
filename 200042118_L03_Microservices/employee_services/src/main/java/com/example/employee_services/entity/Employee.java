package com.example.employee_services.entity;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

@Document(collection = "employees")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Employee {

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
    private String designation;
    @Getter
    @Setter
    @Field
    private double salary;
}
