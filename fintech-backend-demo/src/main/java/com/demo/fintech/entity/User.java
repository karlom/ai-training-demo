package com.demo.fintech.entity;

import com.fasterxml.jackson.annotation.JsonInclude;
import javax.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "users")
@JsonInclude(JsonInclude.Include.NON_NULL)
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String username;

    private BigDecimal balance;

    private Integer vipLevel;

    @Column(nullable = false)
    private String status = "ACTIVE";

    // 默认构造函数
    public User() {
        this.status = "ACTIVE";
    }

    // 带参构造函数
    public User(Long id, String username, BigDecimal balance, Integer vipLevel) {
        this.id = id;
        this.username = username;
        this.balance = balance;
        this.vipLevel = vipLevel;
        this.status = "ACTIVE";
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public BigDecimal getBalance() {
        return balance;
    }

    public void setBalance(BigDecimal balance) {
        this.balance = balance;
    }

    public Integer getVipLevel() {
        return vipLevel;
    }

    public void setVipLevel(Integer vipLevel) {
        this.vipLevel = vipLevel;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // TODO: 演示 2.1 - 在这里添加 vipLevel 字段
    // TODO: 演示 2.2 - 在这里添加 status (ACTIVE/FROZEN) 字段
}
