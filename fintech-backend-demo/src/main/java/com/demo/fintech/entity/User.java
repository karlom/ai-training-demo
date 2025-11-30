package com.demo.fintech.entity;

import lombok.Data;
import javax.persistence.*;
import java.math.BigDecimal;

@Entity
@Data
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String username;
    
    private BigDecimal balance;

    // TODO: 演示 2.1 - 在这里添加 vipLevel 字段
    // TODO: 演示 2.2 - 在这里添加 status (ACTIVE/FROZEN) 字段
}
