package com.example.employee_services.entity;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

@Getter
@Document(collection = "employees")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Employee {

    @Setter
    @Id
    private String id;
    @Setter
    @Field
    private String name;
    @Setter
    @Field
    private String designation;
    @Setter
    @Field
    private double salary;
}
