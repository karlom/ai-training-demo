package com.demo.fintech.service;

import com.demo.fintech.entity.User;
import com.demo.fintech.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public List<User> findAll() {
        return userRepository.findAll();
    }

    public User createUser(User user) {
        return userRepository.save(user);
    }

    public User freezeUser(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("用户不存在，ID: " + id));
        user.setStatus("FROZEN");
        return userRepository.save(user);
    }

    public User unfreezeUser(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("用户不存在，ID: " + id));
        user.setStatus("ACTIVE");
        return userRepository.save(user);
    }

    // TODO: 演示 2.2 - 选中这个类，让 AI 实现 freezeUser(Long userId) 逻辑
    // 要求：修改状态，并抛出异常如果用户不存在
}
