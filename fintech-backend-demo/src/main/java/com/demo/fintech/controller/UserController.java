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

    @PostMapping("/{id}/freeze")
    public User freezeUser(@PathVariable Long id) {
        return userService.freezeUser(id);
    }

    @PostMapping("/{id}/unfreeze")
    public User unfreezeUser(@PathVariable Long id) {
        return userService.unfreezeUser(id);
    }

    // TODO: 演示 2.2 - 让 AI 自动生成 /api/users/{id}/freeze 接口
}
