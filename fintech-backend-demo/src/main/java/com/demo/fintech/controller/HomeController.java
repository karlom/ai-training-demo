package com.demo.fintech.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
public class HomeController {

    @GetMapping("/")
    public Map<String, Object> home() {
        Map<String, Object> response = new HashMap<>();
        response.put("message", "Welcome to Fintech Demo API");
        response.put("version", "1.0.0");
        response.put("endpoints", Map.of(
            "GET /api/users", "获取所有用户列表",
            "POST /api/users", "创建新用户",
            "GET /h2-console", "H2数据库控制台"
        ));
        return response;
    }
}

