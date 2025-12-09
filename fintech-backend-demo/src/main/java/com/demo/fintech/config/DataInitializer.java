package com.demo.fintech.config;

import com.demo.fintech.entity.User;
import com.demo.fintech.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;

@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;

    @Override
    public void run(String... args) throws Exception {
        // 清空现有数据
        userRepository.deleteAll();

        // 创建测试用户，包含 vipLevel
        User testUser = new User();
        testUser.setUsername("JavaMaster");
        testUser.setBalance(new BigDecimal("9888.88"));
        testUser.setVipLevel(3); // 设置 VIP 等级为 3

        userRepository.save(testUser);

        System.out.println("✅ Test data initialized with VIP level!");
    }
}
