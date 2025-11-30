package com.demo.fintech.controller;

import com.demo.fintech.entity.User;
import com.demo.fintech.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping
    public List<User> getAllUsers() {
        return userService.findAll();
    }

    @PostMapping
    public User createUser(@RequestBody User user) {
        return userService.createUser(user);
    }

    // TODO: 演示 2.2 - 让 AI 自动生成 /api/users/{id}/freeze 接口
}
